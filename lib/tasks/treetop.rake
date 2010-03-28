namespace :treetop do

  desc "Pre-generate all the .treetop files into .rb files"
  task :generate do
    Dir[File.join(File.dirname(__FILE__), '..', 'mail', 'parsers', '*.treetop')].each do |filename|
      `lib/mail/vendor/treetop-1.4.3/bin/tt #{filename}`
    end
  end
  
end