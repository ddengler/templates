gem 'spork', :lib => false
gem 'ZenTest', :lib => false

gem 'rspec', :lib => false
gem 'rspec-rails', :lib => false
generate :rspec

gem 'thoughtbot-shoulda', :lib => false, :source => 'http://gems.github.com'

if yes?("Use haml? (yn)")
  gem 'haml'
  run "haml --rails ."
end

git :init

file "spec/spec_helper.rb", <<-SP
require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  ENV["RAILS_ENV"] ||= 'test'
  require File.dirname(__FILE__) + "/../config/environment"
  require 'spec/autorun'
  require 'spec/rails'
  require 'shoulda'
  
  Spec::Runner.configure do |config|
    # If you're not using ActiveRecord you should remove these
    # lines, delete config/database.yml and disable :active_record
    # in your config/boot.rb
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures  = false
    config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  end
  
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
SP

file "spec/spec.opts", <<-SP
--drb
--format progress
--loadby mtime
--reverse
SP
 
run "echo 'TODO readme' > README"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
 
file ".gitignore", <<-END
log/*.log
log/*.pid
tmp/**/*
.DS_Store
public/cache/**/*
doc/api
doc/app
db/*.sqlite3
.autotest
END
 
git :add => ".", :commit => "-m 'initial commit'"

run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/images/rails.png"