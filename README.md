# Angular Momentum

The start-up code for the MIT AITI Philippines 2013 class.

# Set-up

## Packages required

Be sure to have the following packages installed:

* VirtualBox (http://virtualbox.org)
* Vagrant (http://vagrantup.com)
* NodeJS (http://nodejs.org) >= 0.10)
* Ruby (http://ruby-lang.org)
* Git (http://git-scm.com)
* Python 2.7.5 (http://python.org)

[Node](http://nodejs.org/) (≥ 0.10) installed. If you plan
to use Vagrant, be sure to have [Ruby](http://www.ruby-lang.org/en/) (≥ 1.9)
installed.

## Commands to run

    % # The following two commands are only needed if you plan to use Vagrant
    % sudo gem install bundler
    % cd frontend/
    % bundle install
    % sudo npm install -g coffee-script
    % vagrant up
    % npm install

and you're ready to go!

# Directory Structure

    puppet/                   - files used for Puppet (https://puppetlabs.com/), a system configuration management application
     modules/                 - Puppet modules made by us
     vendor_modules/          - Puppet modules made by other people
     momentum-config/         - A folder that stores configuration files we want to move into the virtual machine
     angular-momentum.pp      - the Puppet configuration file
    frontend/                 - the files related to the frontend server
      src/                    - the source files for this application
      build/                  - all of the files in src/ get compiled into here.
      Gemfile                 - the Gemfile used by Bundler (http://gembundler.com/)
      Gemfile.lock            - used by Bundler to lock in the gem versions
      Guardfile               - configuration file for Guard which we use to watch and automatically compile the src folder
      Rakefile                - configuration file for Rake which we use to manually compile the src folder
      package.json            - a description of this NodeJS application (see http://package.json.nodejitsu.com/)
    backend/                  - the files related to the backend server
      server.py               - the script that runs Flask
      database.py             - the module that initializes SQLAlchemy
      models.py               - the module that contains all the object-relational mappings
      requirements.txt        - the requirements file used by pip (http://www.pip-installer.org/en/latest/requirements.html)
    README.md                 - this readme file
    Vagrantfile               - the configuration file for Vagrant (http://www.vagrantup.com/)

