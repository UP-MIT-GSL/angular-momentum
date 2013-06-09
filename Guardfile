# This is configuration file for Guard (https://github.com/guard/guard), which
# automatically compiles all of the src/ files into build/.

# This just tells Guard to ignore a bunch of common temporary file formats
ignore %r{.nfs\h+}, %r{.swp$}, %r{~$}

# This configures the CoffeeScript compiler (https://github.com/guard/guard-coffeescript)
guard 'copy', :exclude => %r{^src/.+\.(coffee|less|jade)$}, :optimize_images => true,
    :all_on_start => true, :force => true, :output => 'build' do
  #directly copies non jade/less/coffee files to build/
  watch(%r{^src/(.+)$})
  
end

guard 'coffeescript', :output => 'build', :all_on_start => true, :error_to_js => true do
  # This tells it to watch and compile all changes to CoffeeScript files in
  # src/
  watch(%r{^src/(.+\.coffee$)})
end

# We'll use the convention that .styl files whose filenames start with underscore are
# partials and should not be compiled
guard 'stylus', :output => 'build', :all_on_start => true, :all_after_change => true, :exclude => %r{.+/_[^/]+\.styl$} do
  watch(%r{^src/(.+\.styl$)})
end

guard 'jade', :output => 'build', :all_on_start => true do
  watch(%r{^src/(.+\.jade$)})
end
