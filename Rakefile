require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'cucumber/rake/task'

task :default => :spec

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "spec/features --format pretty"
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['**/test/**/tc_*.rb', '**/spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = t.rcov_opts << ['--exclude', '/Library,/opt,/System']
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['**/spec/**/*_spec.rb']
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = '**/test/**/tc_*.rb'
  t.verbose = true
  t.warning = false
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Mail'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# load custom rake tasks
Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }
