lib_dir = File.expand_path('../lib', __FILE__)
$:.unshift lib_dir unless $:.include? lib_dir
require 'mail/version'

Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = Mail::VERSION::STRING
  s.author      = "Mikel Lindsaar"
  s.email       = "raasdnil@gmail.com"
  s.homepage    = "http://github.com/mikel/mail"
  s.description = "A really Ruby Mail handler."
  s.summary     = "Mail provides a nice Ruby DSL for making, sending and reading emails."
  s.license     = "MIT"

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "CONTRIBUTING.md", "CHANGELOG.rdoc", "TODO.rdoc"]
  s.rdoc_options << '--exclude' << 'lib/mail/values/unicode_tables.dat'

  s.add_dependency('mime-types', ">= 1.16")
  s.add_dependency('jruby-openssl') if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
  s.add_dependency('tlsmail', '~> 0.0.1') if RUBY_VERSION == '1.8.6'

  s.add_development_dependency('bundler', '>= 1.0.3')
  s.add_development_dependency('rake', '> 0.8.7')
  s.add_development_dependency('rspec', '~> 2.12.0')
  s.add_development_dependency('rdoc')

  s.require_path = 'lib'
  s.files = %w(README.md VERSION MIT-LICENSE CONTRIBUTING.md CHANGELOG.rdoc Dependencies.txt Gemfile Rakefile TODO.rdoc) + Dir.glob("lib/**/*")
end
