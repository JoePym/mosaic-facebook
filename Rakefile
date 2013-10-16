require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'bundler'

Bundler::GemHelper.install_tasks


desc "Run RSpec"
RSpec::Core::RakeTask.new(:spec) 
task :default => [:spec]
