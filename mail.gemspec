require File.dirname(__FILE__) + "/lib/mail/version"

Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = Mail::VERSION::STRING
  s.author      = "Mikel Lindsaar"
  s.email       = "raasdnil@gmail.com"
  s.homepage    = "http://github.com/mikel/mail"
  s.description = "A really Ruby Mail handler."
  s.summary     = "Mail provides a nice Ruby DSL for making, sending and reading emails."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.mkd", "CHANGELOG.rdoc", "TODO.rdoc"]

  s.add_dependency('mime-types', "~> 1.16")
  s.add_dependency('treetop', '~> 1.4.8')
  s.add_dependency('i18n', '>= 0.4.0')
  s.add_dependency('jruby-openssl') if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'
  s.add_dependency('tlsmail', '~> 0.0.1') if RUBY_VERSION == '1.8.6'

  s.require_path = 'lib'
  s.files = %w(README.mkd CHANGELOG.rdoc Dependencies.txt Gemfile Rakefile TODO.rdoc) + Dir.glob("lib/**/*")
end
