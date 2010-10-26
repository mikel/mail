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
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc", "TODO.rdoc"]

  s.add_dependency('activesupport', ">= 2.3.6")
  s.add_dependency('mime-types', "~> 1.16")
  s.add_dependency('treetop', '~> 1.4.8')
  s.add_dependency('i18n', '~> 0.4.1')

  s.require_path = 'lib'
  s.files = %w(README.rdoc Rakefile TODO.rdoc) + Dir.glob("lib/**/*")
end
