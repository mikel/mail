begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("1.0.0")
  raise RuntimeError, "Your bundler version is too old for Mail" +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

require File.expand_path('../spec/environment', __FILE__)

require 'rake/rdoctask'
require 'rake/testtask'
require 'rspec/core/rake_task'

desc "Build a gem file"
task :build do
  system "gem build mail.gemspec"
end

task :default => :spec

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts ||= []
  t.rcov_opts = t.rcov_opts << ['--exclude', '/Library,/opt,/System,/usr']
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = '-w'
  t.rspec_opts = %w(--backtrace --color)
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Mail - A Ruby Mail Library'

  rdoc.options << '-c' << 'utf-8'
  rdoc.options << '--line-numbers'
  rdoc.options << '--inline-source'
  rdoc.options << '-m' << 'README.rdoc'

  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('lib/network/**/*.rb')
  rdoc.rdoc_files.exclude('lib/parsers/*')
end

# load custom rake tasks
Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }
