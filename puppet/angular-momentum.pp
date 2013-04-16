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
  class {'rethinkdb':
    instance_name => 'momentum',
    rethinkdb_bind => '172.16.0.*,127.0.0.1'
  }
}

# This declares a dependency on the above defined db class
class {'db':}
