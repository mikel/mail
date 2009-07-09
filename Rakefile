require 'rubygems'
require 'rspec'
require 'cucumber/rake/task'
 
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty"
end

multiruby_path = `which multiruby`.chomp
if multiruby_path.length > 0 && Spec::Rake::SpecTask.instance_methods.include?("ruby_cmd")
  namespace :spec do
      desc "Run all specs with multiruby and ActiveSupport"
      Spec::Rake::SpecTask.new(:multi) do |t|
        t.spec_opts = ['--options', "spec/spec.opts"]
        t.spec_files = FileList['spec/**/*_spec.rb']
        t.ruby_cmd = multiruby_path
       end
   end
end
