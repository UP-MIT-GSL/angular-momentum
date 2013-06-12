define flaskdb (
  $name,
  $user,
  $password,
  $host        = 'localhost',
  $driver      = 'pg',
  $path        = '/var/www/angular-momentum/backend/database.json'
){
  file { 'database.json':
    ensure => 'present',
    path => $path,
    owner => 'www-data',
    group => 'www-data',
    mode => '0660',
    content => template('flaskdb/database.erb')
  }
}
