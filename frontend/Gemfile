# This Gemfile describes our Gem dependencies, and is read by Bundler
# when we run `bundle install`.
source 'https://rubygems.org'

gem 'rake'

# The following are the dependencies of Guard (https://github.com/guard/guard),
# the build system we're using.
gem 'guard', '~> 1.7.0'
group :development do
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false

  gem 'terminal-notifier-guard', :require => false
  gem 'libnotify', :require => false

  gem 'stylus'

  gem 'guard-coffeescript', '~> 1.2.1'
  gem 'guard-helpers', '~> 0.0.3'
  gem 'guard-stylus', '~> 0.0.2'
  gem 'guard-jade', '~> 0.1.2'

  gem 'guard-copy2', '~> 0.0.2'
end
