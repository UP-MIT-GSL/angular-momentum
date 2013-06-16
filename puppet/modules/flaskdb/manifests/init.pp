# This module generates the /backend/database.json file.
# For more information on creating your own puppet modules, check out:
# http://docs.puppetlabs.com/puppet/2.7/reference/modules_fundamentals.html

define flaskdb (
  $name,
  $user,
  $password,
  $host        = 'localhost',
  $driver      = 'postgresql',
  $path        = '/var/www/angular-momentum/backend/database.json'
){
  file { 'database.json':
    ensure => 'present',
    path => $path,
    mode => '0660',
    content => template('flaskdb/database.erb')
  }
}
