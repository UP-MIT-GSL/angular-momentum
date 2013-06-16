# This Puppet (https://puppetlabs.com/) file declares the system configuration
# for the Vagrant system (you can also apply this manually using
# `puppet apply --modulepath=./modules:./vendor_modules angular-momentum.pp`).

# We declare some global variables here
$config_directory = '/vagrant/puppet/momentum-config'
$database_name = 'angular_momentum_db'
$database_username = 'momentum'
$database_password = 'momentum-password'

# Classes are blocks of puppet code that describe things that should be done
# when provisioning a machine. They are not applied until invoked later on.
# (See the bottom of this file)
class update {
  # There seems to be a problem with apt-get update without this.
  exec {'dpkg-configure':
    command => '/usr/bin/dpkg --configure -a',
    before => Exec['apt-initialize']
  }
  # This defines a resource named 'apt-initialize' that tells puppet to
  # execute `/usr/bin/apt-get update`
  # It is run before the 'python-software-properties' resource
  exec {'apt-initialize':
    command => '/usr/bin/apt-get update',
    before => Package['python-software-properties']
  }

  # This tells puppet to install the package named 'python-software-properties'
  package {'python-software-properties':
    ensure => present,
    before => Exec['add-node-js']
  }

  # This adds Chris Lea's node.js repository to apt by running
  # `/usr/bin/add-apt-repository ppa:chris-lea/node.js -y`
  exec {'add-node-js':
    command => '/usr/bin/add-apt-repository ppa:chris-lea/node.js -y',
    before => Exec['apt-update']
  }

  # Finally, after adding the new repository, we tell apt-get to update
  # one final time before we can proceed with installing the other things.
  exec {'apt-update':
    command => '/usr/bin/apt-get update'
  }
}


class database {
  # The following line means that the database class will use every package inside
  # the postgresql::server class (defined somewhere in /puppet/vendor_modules).
  # You can visit https://forge.puppetlabs.com/puppetlabs/postgresql
  # if you want to know more about postgres configuration through puppet.
  include postgresql::server

  # Then we use the 'postgresql-server-dev-9.1' package in apt.
  package { 'postgresql-server-dev-9.1':
    provider => 'apt',
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

  # This is some additional configuration for postgres.
  postgresql::pg_hba_rule { 'postgres-password-login':
    description => "Allow postgres users to login with the password.",
    type => 'local',
    database => 'all',
    user => 'all',
    auth_method => 'md5',
    order => '001'
  }
}

# The inherits syntax is similar to the include above, but it allows us to
# override definitions in the class. In this case, we're doing this so that
# npm will not be installed. It comes free with the nodejs package in
# Chris Lea's repository, so installing it through apt would lead to conflicts.
class build inherits nodejs {
  Package['npm'] {
    ensure => 'absent',
  }

  package { 'make':
    provider => 'apt'
  }

  package { 'ruby1.9.3':
    provider => 'apt',
    require => Package['make']
  }

  package { 'bundler':
    provider => 'gem',
    require => Package['ruby1.9.3']
  }

  file { '/etc/init/guard.conf':
    source => "$config_directory/init/guard.conf",
    owner => 'root',
    group => 'root'
  }

  service { 'guard':
    ensure => running,
    subscribe => File['/etc/init/guard.conf'],
    require => [Package['bundler'], Package['nodejs']]
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
    www_root => '/var/www/angular-momentum/frontend/build/'
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
  # We copy the flask.conf file  from the momentum-config directory into
  # /etc/init/ . That location is where Ubuntu services are defined.
  # Effectively, this means that we're creating a service called flask.
  file { '/etc/init/flask.conf':
    source => "$config_directory/init/flask.conf",
    owner => 'root',
    group => 'root'
  }

  package {'python-dev':
    provider => 'apt'
  }

  package {'python-pip':
    provider => 'apt'
  }

  # This tells puppet to run the Flask service.
  # From the command-line inside vagrant, you can do the same with
  # `sudo initctl start flask`
  service { 'flask':
    ensure => running,
    subscribe => File['/etc/init/flask.conf'],
    require => [Package['postgresql-server'], Package['python-pip'], Package['python-dev']]
  }

  # This resource is our own creation. It creates the database.json file in
  # the backend folder, so we only really set database configuration data
  # in one place (at the top of this file).
  flaskdb { $database_name:
    name => $database_name,
    user => $database_username,
    password => $database_password
  }
}

# Invoke the classes defined above.
class {'update':}
class {'database':}
class {'build':}
class {'frontend': }
class {'backend': }

# Define the ordering of provisions
Class['update'] -> Class['database'] -> Class['backend']
Class['update'] -> Class['build'] -> Class['frontend']
