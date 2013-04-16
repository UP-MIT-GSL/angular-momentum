class {'apt': }

include nodejs

# The database
class db {
  # TODO: don't hardcode this
  # Password for the PostgreSQL database
  $dbpassword = 'hWSCtfVM'

  class {'rethinkdb':
    instance_name => 'momentum',
    rethinkdb_bind => '172.16.0.*,127.0.0.1'
  }

}

class {'db':}
