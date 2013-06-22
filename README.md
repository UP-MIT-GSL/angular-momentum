# Angular Momentum

The start-up code for the MIT AITI Philippines 2013 class.

# Set-up

## Packages required

Be sure to have the following packages installed (these are expected
to be installed in the host platform; NodeJS is actually optional,
but it might prove useful in the future or for debugging):

* VirtualBox (http://virtualbox.org)
* Vagrant (http://vagrantup.com)
* NodeJS (http://nodejs.org) (version >= 0.10)
* Ruby (http://ruby-lang.org) (version >= 1.9)
* Git (http://git-scm.com)
* Python 2.7.5 (http://python.org)

## Some notes on installing on Ubuntu

You'll need a version of Ruby higher than 1.9. Ubuntu's repository has 1.9.3,
we recommend that you use that. It also contains the gem command used earlier.
Just run the command:

    % sudo apt-get install ruby1.9.3

Also, NodeJS on Ubuntu is outdated, so you will have to add a repository that
has it. The `npm` command comes with the latest version of NodeJS in Chris Lea's
repository. We don't really know that guy, but he has lots of useful repos.
To get the latest version of NodeJS, run the commands:

    % sudo apt-get install python-software-properties
    % sudo add-apt-repository ppa:chris-lea/node.js -y
    % sudo apt-get update
    % sudo apt-get install nodejs

Lastly, we need to install the package for the Network File System used by
Vagrant to share files with the virtual machine.

    % sudo apt-get install nfs-kernel-server

After all of that, just follow the rest of the instructions listed under
"General Instructions".

## Some notes on installing on Mac

Macs don't have a package manager, so we'll have to install one called homebrew.

    % ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

Then we have to override the default Ruby in Mac because it's version 1.8.7.

    % brew install ruby

Then add the following line to your `~/.bash_profile` (or create it if it doesn't
exist). That should allow your terminal to know where Ruby things are installed.

    export PATH=/usr/local/opt/ruby/bin:$PATH

**Note:** `~/` stands for your home folder (i.e. `/Users/username/`), so `~/.bash_profile`
would be `/Users/username/.bash_profile`

**Note 2:** `~/.bash_profile` is the startup file that runs everytime you open a
terminal window. In Linux, they usually use the `~/.bashrc` file.

Then you can either restart your terminal to refresh it or update the PATH
variable manually by running:

    PATH=/usr/local/opt/ruby/bin:$PATH

Lastly, install nodejs

    brew install nodejs

After that, just continue with the general instructions below.

## General Instructions

    % git clone git@github.com:UP-MIT-GSL/angular-momentum.git
    % cd angular-momentum/
    % sudo gem install bundler
    % bundle install
    % bundle exec vagrant up

and you're ready to go!

# Directory Structure

    puppet/                   - files used for [Puppet](https://puppetlabs.com/), a system configuration management application
     modules/                 - Puppet modules made by us
     vendor_modules/          - Puppet modules made by other people
     momentum-config/         - A folder that stores configuration files we want to move into the virtual machine
     angular-momentum.pp      - the Puppet configuration file
    frontend/                 - the files related to the frontend server
      src/                    - the source files for this application
      build/                  - all of the files in src/ get compiled into here.
      Gemfile                 - the Gemfile used by [Bundler](http://gembundler.com/)
      Gemfile.lock            - used by Bundler to lock in the gem versions
      Guardfile               - configuration file for Guard which we use to watch and automatically compile the src folder
      Rakefile                - configuration file for Rake which we use to manually compile the src folder
      package.json            - a description of this NodeJS application (see http://package.json.nodejitsu.com/)
    backend/                  - the files related to the backend server
      server.py               - the script that runs Flask
      database.py             - the module that initializes SQLAlchemy
      models.py               - the module that contains all the object-relational mappings
      requirements.txt        - the requirements file used by [pip](http://www.pip-installer.org/en/latest/requirements.html)
    README.md                 - this readme file
    Vagrantfile               - the configuration file for [Vagrant](http://www.vagrantup.com/)

# Building Things
Angular Momentum is a collection of tools, libraries, and frameworks that we've
found are great for building things. In this section, we'll give a rundown
on what those tools, libraries, and frameworks are.

## Infrastructure
### [Vagrant](http://www.vagrantup.com/)
Vagrant is a tool that makes setting up and configuring virtual machines easier.

Useful commands are:

    vagrant up                - Boots up the virtual machine and provisions it. Creates it if it doesn't exist yet.
    vagrant ssh               - ssh into the virtual machine
    vagrant provision         - Applies all the things in the puppet file.
    vagrant halt              - Shuts down the virtual machine.
    vagrant reload            - Restarts the virtual machine.
    vagrant destroy           - Destroys a virtual machine completely.
    vagrant status            - Checks to see the status of a virtual machine.

### [Puppet](http://docs.puppetlabs.com/)
"Puppet manages your servers: you describe machine configurations in an
easy-to-read declarative language, and Puppet will bring your systems into the
desired state and keep them there." - Puppet Labs

The puppet file (`./puppet/angular-momentum.pp`) is where all the configurations
are kept. It's a listing of what needs to be installed, which files go where, 
what services need to run, and in which order.

The `./puppet/momentum-configs` folder is where we put all the files that need to
be transfered into the virtual machine and used by puppet is kept. Right now, it
contains the configuration files for the services that we run in the vm.

The `./puppet/vendor_modules` folder is where we keep all the modules we got from
third parties. It mostly contains modules made by Puppet Labs themselves, but
we've sourced some from some other open source projects.

Lastly, the `./puppet/modules` folder is where we keep all the modules we made
ourselves and the modules we've modified from other people.

In the likely event that you want to install more things into your virtual machine,
we recommend that you go through the puppet documentation. It's not hard at all.

### Nginx
Nginx is a high-performance reverse proxy and webserver. What that means is that
as a reverse proxy, Nginx is a program takes HTTP requests and passes them to
other programs or computers. (As an aside, it also handles email protocols)
As a web server, it serves static files as needed.

We've configured it to serve everything in the `/var/www/angular-momentum/frontend/build/`
directory which is directly shared from the host machine. It also reverse proxies
everything that starts with `/api/` onto port `8080`. That means that any url
with the location `/api/xxx` will end up getting served by Flask (because we set up
Flask to listen to port `8080`), and Flask will get a request with the url `/xxx`.

### PostgreSQL
We're using PostgreSQL, and the credentials are set up in the puppet file
(`./puppet/angular-momentum.pp`). We've set it up so that puppet automatically
generates the `./backend/database.json` file which your web app can use to get
the database access credentials.

### [Guard](https://github.com/guard/guard)
Guard is a tool that handles file system changes.
We use it to watch the `./frontend/src` directory. When things change, it runs the
proper plugin as configured in the Guardfile. That is, it runs guard-coffeescript
for changes in files that end in `.coffee`, guard-jade for those that end in `.jade`,
and guard-stylus for those that end in `.styl`. For everything else, it just
copies it directly into the build folder.

We have a service running in the background inside the virtual machine that
runs guard. It saves its logs inside `/var/log/upstart/guard.log` in case you
want to see it. Note that you can run `sudo tail -f /var/log/upstart/guard.log`
if you want to watch the log update live. This is very helpful when you make
typos to see the error messages that guard prints out.

If for any reason, guard dies, you can always restart it manually by typing
`sudo initctl start guard`. `initctl` is Ubuntu's tool to interact with the
Upstart daemon which is its service runner. In simpler terms, that means
`initctl` is the command you use to start/stop services.

For more advanced users, you may shut down the guard service inside the virtual
machine with `sudo initctl stop guard` and run guard in the host machine. By
installing things in the Gemfile on the host machine, you'll be able to have
popups on your screen that give you error messages or success messages. Guard
will also detect changes faster with the proper notification libraries installed.
Without them, Guard takes about a second to notice changes in files.

### [Flask](http://flask.pocoo.org/)
Flask is a Python microframework used to build webapps.
By default it doesn't come with much, but we've set up a database abstraction
layer for you. You can use any library you want with pip (just add it to the
requirements file, so your team mates will have an easy time with your changes).
We've even set up a database abstraction layer for you.

We've also included [SQLAlchemy](http://www.sqlalchemy.org/) and an example of how to use it for you guys.
How we've set it up is that every table in the database corresponds to a class
in models.py, so to add tables, you just modify models.py.

Inside the virtual machine, we've set up a service that runs Flask as well.
If you want to see the messages Flask prints out, you can run
`sudo tail -f /var/log/upstart/flask.log`. Again, this would likely be useful
for debugging. You can also opt to kill the service and start flask manually
with `python ./backend/server.py`. We don't really see any benefits in doing
this though. Lastly, if the service dies for any reason, you can restart it
with `sudo initctl start flask`.

## Frontend
### Layout
The two important directories here are `./src` and `./build`. The `src` folder is where
you make your changes, and the `build` folder is automatically generated by guard.
You can manually compile with `bundle exec rake`, but there isn't very much point
to it.

Inside the `src` folder, there is `html`, `js`, `css`, and `lib`. The contents of the first
three should be obvious, and the fourth one contains all the third-party libraries
that we use (Bootstrap, jQuery, AngularJS). You're free to add your own libraries
as well. It's best practice to keep them separate from your actual application
code to keep things neat and organized.

You're encouraged to add your own directories in the `src` folder (e.g. an `assets`
directory to keep all your images and flash files and so on). Just keep in mind
that everything in this folder will be publicly available on the Internet with
the correct link.

### Jade, Stylus, and CoffeeScript
[Jade](http://jade-lang.com/) is a templating language that makes writing HTML cleaner and shorter.
[Stylus](http://learnboost.github.io/stylus/) is a superset of CSS that makes it so much better.
[CoffeeScript](http://coffeescript.org/) is a language that compiles into JavaScript, and it's so much better.

We strongly recommend that you learn all of these in your own time. They will
make web development so much easier for you.

### [Bootstrap](http://twitter.github.io/bootstrap/)
Bootstrap is a collection of CSS files and
JavaScript libraries that help with making your website pretty. It's recommended
that you go through the Bootstrap tutorial on the linked site.

You may also use Bootstrap themes available online to instantly make your site
look pretty. We've found a few free themes available on http://bootswatch.com/.
But there's surely more out there on the Internet. Just download the css and
replace the one in `./lib/bootstrap/css/`.

### [jQuery](http://jquery.com/)
jQuery is a JavaScript library that makes it infinitely easier to select objects
in an HTML document. It also comes with lots of useful animations to make your
website look pretty. Lastly, it comes with event handling tools, but we'll
mainly be using AngularJS for that.

### [AngularJS](http://angularjs.org/)
AngularJS is the framework this project was named for.
At the most basic level, AngularJS provides an easy way to render HTML pages
from a template and JavaScript data. This leaves the server free to forget
absolutely everything about rendering pages, and allows us to completely
separate the frontend rendering from the backend data processing.

We strongly recommend that you go through the tutorial to see what it's all about.

## Backend Directory
The backend section is very simple for now. There is the `server.py` script
which runs Flask.

`database.json` is the file that stores database credentials.
`database.py` is the script that sets up the database connection. Just make sure
to run `db_init()` at the beginning of your code to have it working.

`models.py` is the Python module that contains all of your object definitions.
`server.py` is the script that runs Flask. Right now it also contains all of the
routes, but that style is not recommended.

We'll probably have a folder soon to put all of the routes in. We'll likely
also have a database migration tool like Alembic as well.
