define nodedb (
  $name,
  $user,
  $password,
  $host        = 'localhost',
  $driver      = 'pg',
  $path        = '/var/www/angular-momentum/database.json'
){
  file { 'database.json':
    ensure => 'present',
    path => $path,
    owner => 'www-data',
    group => 'www-data',
    mode => '0660',
    content => template('nodedb/database.erb')
  }
}
