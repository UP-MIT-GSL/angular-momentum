class {'apt': 
  always_apt_update => true
}

include nodejs

# The database
class db {
  class {'rethinkdb':
    instance_name => 'momentum',
    rethinkdb_bind => '172.16.0.*,127.0.0.1'
  }
}

class {'db':}
