# This Puppet (https://puppetlabs.com/) file declares the system configuration
# for the Vagrant system (you can also apply this manually using
# `puppet apply --modulepath=./modules:./vendor_modules angular-momentum.pp`).

# We declare some global variables here
$config_directory = '/vagrant/puppet/momentum-config'
$database_name = 'angular_momentum_db'
$database_username = 'momentum'
$database_password = 'momentum-password'

# This tells puppet to run `/usr/bin/apt-get update` when we provision.
exec {'apt-update':
  command => '/usr/bin/apt-get update'
} -> Package <| provider == 'apt' |>

# This is an alternative syntax to depend on a class (in this case, the
# nodejs class of the nodejs module). This differs from the above syntax
# in that you can include a class multiple times without an error,
# but you cannot supply parameters to include.
include nodejs

class database {
  # This sets up postgres using puppetlab's postgresql module.
  # Alternatively, you can visit https://forge.puppetlabs.com/puppetlabs/postgresql
  # if you want to know more about postgres configuration through puppet.
  include postgresql::server
  package { 'postgresql-server-dev-9.1':
    ensure => present
  }

  # This creates the postgres database we'll use for angular-momentum.
  # The user who owns the database is also created.
  # There are more advanced options in the link provided above,
  # but this is the most common use-case.
  postgresql::db { $database_name:
    user => $database_username,
    password => $database_password
  }

  postgresql::pg_hba_rule { 'postgres-password-login':
    description => "Allow postgres users to login with the password.",
    type => 'local',
    database => 'all',
    user => 'all',
    auth_method => 'md5',
    order => '001'
  }
}

class frontend {
  # This sets up nginx as a webserver using puppetlabs's nginx module.
  # You can visit http://forge.puppetlabs.com/puppetlabs/nginx
  # if you want to know more.
  include nginx

  # This tells nginx that the backend server for momentum is at localhost:8080
  nginx::resource::upstream { 'momentum-backend':
    members => [
      'localhost:8080'
    ]
  }

  nginx::resource::vhost { 'momentum-frontend':
    www_root => '/var/www/angular-momentum/build/'
  }
  
  nginx::resource::location { 'momentum-proxy':
    vhost => 'momentum-frontend',
    proxy => 'http://momentum-backend',
    location => '~ ^/api(/.*)?$',
    location_cfg_prepend => {
      'rewrite' => '^/api/?(.*)$ /$1 break'
    }
  }
}

class backend {
  file { '/etc/init/flask.conf':
    source => "$config_directory/init/flask.conf",
    owner => 'root',
    group => 'root'
  }
  package {'python-pip':
    ensure => present
  }
  service { 'flask':
    ensure => running,
    subscribe => File['/etc/init/flask.conf'],
    require => [Package['postgresql-server'], Package['python-pip']]
  }
  flaskdb { $database_name:
    name => $database_name,
    user => $database_username,
    password => $database_password
  }
}

class buildtools {
  package { 'make': } -> Package['ruby1.9.3']
  package { 'ruby1.9.3': } -> Package['bundler']
  package { 'bundler':
    provider => 'gem'
  }
}

# This declares a dependency on the above defined db class
class {'database':}
class {'frontend':}
class {'backend':}
