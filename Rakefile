require File.expand_path('../spec/environment', __FILE__)

require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'cucumber/rake/task'

desc "Build a gem file"
task :build do
  system "gem build mail.gemspec"
end

task :default => :spec
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "spec/features --format pretty"
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['test/**/tc_*.rb', 'spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = t.rcov_opts << ['--exclude', '/Library,/opt,/System,/usr']
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.warning = true
  t.spec_files = FileList["#{File.dirname(__FILE__)}/spec/**/*_spec.rb"]
  t.spec_opts = %w(--backtrace --diff --color)
  t.libs << "#{File.dirname(__FILE__)}/spec"
  t.libs << "#{File.dirname(__FILE__)}/spec/mail"
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Mail'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# load custom rake tasks
Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }
