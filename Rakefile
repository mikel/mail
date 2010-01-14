environment = File.expand_path('../../vendor/gems/environment')
if File.exist?("#{environment}.rb")
  require environment
end

require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'cucumber/rake/task'
require 'bundler'

spec = Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = "1.6.0"
  s.author      = "Mike Lindsaar"
  s.email       = "raasdnil@gmail.com"
  s.homepage    = "http://github.com/mikel/mail"
  s.description = "A really Ruby Mail handler."
  s.summary     = "Mail provides a nice Ruby DSL for making, sending and reading emails."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc", "TODO.rdoc"]

  s.add_dependency('activesupport', ">= 2.3.4")
  s.add_dependency('mime-types')

  s.require_path = 'lib'
  s.files = %w(README.rdoc Rakefile TODO.rdoc) + Dir.glob("lib/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec
end

task :default => :spec
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "spec/features --format pretty"
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['test/**/tc_*.rb', 'spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = t.rcov_opts << ['--exclude', '/Library,/opt,/System']
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.warning = true
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(--backtrace --diff --color)
  t.libs << "#{File.dirname(__FILE__)}/spec"
  t.libs << "#{File.dirname(__FILE__)}/spec/mail"
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/tc_*.rb'
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
