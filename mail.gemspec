# encoding: utf-8
MAIL_ROOT = File.dirname(__FILE__)

Gem::Specification.new do |s|
  s.name = %q{mail}
  s.version = "1.0.0"
 
  s.requirements << 'treetop, Treetop is a Ruby-based DSL for text parsing and interpretation'
  s.requirements << 'mime/types, A list of a lot of Mime Types'
  s.requirements << 'tlsmail, Used for encrypted SMTP, only if you are on RUBY_VERSION <= 1.8.6'
 
  s.add_dependency('treetop', '>= 1.4')
  s.add_dependency('mime-types', '>= 1.0')
  s.add_dependency('tlsmail', '>= 0.0.1') if RUBY_VERSION <= '1.8.6'
 
  s.add_development_dependency('rspec', '>= 1.2.9')
 
  s.required_rubygems_version = Gem::Requirement.new(">= 1.2.0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mikel Lindsaar"]
  s.date = %q{2009-10-25}
  s.description = %q{A really Ruby Mail handler.}
  s.email = %q{raasdnil@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  
  # I like knowing what goes into my gem... Manifest.txt is only ever edited
  # by hand
  s.files = File.read(File.join(MAIL_ROOT, 'Manifest.txt')).lines.map do |f|
    File.join(MAIL_ROOT, f.chomp)
  end

  s.homepage = %q{http://github.com/mikel/mail}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Mail provides a nice Ruby DSL for making, sending and reading emails.}
 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
 
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end