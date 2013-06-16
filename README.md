# Angular Momentum

The start-up code for the MIT AITI Philippines 2013 class.

# Set-up

## Packages required

Be sure to have the following packages installed (these are expected
to be installed in the host platform; NodeJS is actually optional,
but it might prove useful in the future or for debugging):

* VirtualBox (http://virtualbox.org)
* Vagrant (http://vagrantup.com)
* NodeJS (http://nodejs.org) >= 0.10)
* Ruby (http://ruby-lang.org)
* Git (http://git-scm.com)
* Python 2.7.5 (http://python.org)

## Some notes on installing on Ubuntu

You'll want a newer version of Ruby than 1.8.x. Ubuntu's repository has 1.9.3,
we recommend that you use that. It also contains the gem command used earlier.
Just run the command:

    % sudo apt-get install ruby1.9.3

Also, NodeJS on Ubuntu is outdated, so you will have to add a repository that
has it. The npm command comes with the latest version of NodeJS in Chris Lea's
repository. We don't really know that guy, but he has lots of useful repos.
To get the latest version of NodeJS, run the commands:

    % sudo apt-get install python-software-packages
    % sudo add-apt-repository ppa:chris-lea/node.js -y
    % sudo apt-get update
    % sudo apt-get install nodejs

After all of that, just follow the rest of the instructions listed in
"Commands to run".

## Some notes on installing on Mac

Macs don't have a package manager, so we'll have to install one called homebrew.

    % ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

Then we have to override the default Ruby in Mac because it's version 1.8.7.

    % brew install ruby

Then add the following line to your ~/.bash_profile (or create it if it doesn't
exist). That should allow your terminal to know where Ruby things are installed.

    export PATH=/usr/local/opt/ruby/bin:$PATH

Note: ~/ stands for your home folder (i.e. /Users/username/), so ~/.bash_profile
would be /Users/username/.bash_profile
Note 2: ~/.bash_profile is the startup file that runs everytime you open a
terminal window. In Linux, they usually use the ~/.bashrc file.

Then you can either restart your terminal to refresh it or update the PATH
variable manually by running:

    PATH=/usr/local/opt/ruby/bin:$PATH

Lastly, install nodejs

    brew install nodejs

After that, just run the rest of the commands below.

## Commands to run

    % git clone git@github.com:UP-MIT-GSL/angular-momentum.git
    % cd angular-momentum/
    % sudo gem install bundler
    % bundle install
    % bundle exec vagrant up

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

