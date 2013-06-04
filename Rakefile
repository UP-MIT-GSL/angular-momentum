require 'guard'

task :default do
  Guard.setup
  # We don't use Guard.run_all because (1) it doesn't propagate
  # errors, and (2) we need to enforce a specific ordering.
  %w{Jade Stylus Coffeescript Copy}.each do |g|
    Guard.guards.each do |guard|
      if guard.inspect == g
        guard.run_all
      end
    end
  end
end
