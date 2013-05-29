# This Puppet (https://puppetlabs.com/) file declares the system configuration
# for the Vagrant system (you can also apply this manually using
# `puppet apply --modulepath=./modules:./vendor_modules angular-momentum.pp`).

# This declares a dependency on the apt class of the apt Puppet module
# (https://forge.puppetlabs.com/puppetlabs/apt)
class {'apt': 
  # This configures apt to always update when provisioning
  always_apt_update => true
}

# This is an alternative syntax to depend on a class (in this case, the
# nodejs class of the nodejs module). This differs from the above syntax
# in that you can include a class multiple times without an error,
# but you cannot supply parameters to include.
include nodejs

# This defines the db class
class db {
  # This creates the server with some default configurations provided by puppetlabs.
  # Alternatively, you can visit https://forge.puppetlabs.com/puppetlabs/postgresql
  # if you want to know more about postgres configuration through puppet.
  include postgresql::server

  # This creates the postgres database we'll use for angular-momentum.
  # The user who owns the database is also created.
  # There are more advanced options in the link provided above,
  # but this is the most common use-case.
  postgresql::db { 'angular_momentum_db':
    user => 'momentum',
    password => 'momentum-password'
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

# This declares a dependency on the above defined db class
class {'db':}
