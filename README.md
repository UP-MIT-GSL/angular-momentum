# Angular Momentum

The start-up code for the MIT AITI Philippines 2013 class.

# Set-up

Be sure to have [Node](http://nodejs.org/) (≥ 0.10) installed. If you plan
to use Vagrant, be sure to have [Ruby](http://www.ruby-lang.org/en/) (≥ 1.9)
installed.

    % # The following two commands are only needed if you plan to use Vagrant
    % sudo gem install bundler
    % bundle install
    % vagrant up
    % npm install

and you're ready to go!

# Directory Structure

    puppet/                   - files used for Puppet (https://puppetlabs.com/), a system configuration management application
     modules/                 - Puppet modules made by us
     vendor_modules/          - Puppet modules made by other people
     angular-momentum.pp      - the Puppet configuration file
    src/                      - the source files for this application
    build/                    - all of the files in src/ get compiled into here.
    Gemfile                   - the Gemfile used by Bundler (http://gembundler.com/)
    Gemfile.lock              - used by Bundler to lock in the gem versions
    package.json              - a description of this NodeJS application (see http://package.json.nodejitsu.com/)
    README.md                 - this readme file
    Vagrantfile               - the configuration file for Vagrant (http://www.vagrantup.com/)

# Migrations

When you modify your database schema, it's recommended to use a migration tool.
For this project, we will use db-migrate for schema migration. You can opt
to translate the generated migrations into CoffeeScript if you wish (like in
the initial migration example).

To create a migration, run:
`db-migrate create <migrationName> -m src/backend/migrations`

To use a migration:
`db-migrate up <migrationName> -m build/backend/migrations`

To rollback a migration:
`db-migrate down <migrationName> -m build/backend/migrations`

For more information, check out https://github.com/nearinfinity/node-db-migrate 
