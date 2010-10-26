require File.dirname(__FILE__) + "/lib/mail/version"

Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = Mail::VERSION::STRING
  s.authors     = ["Mikel Lindsaar", "Donald Ball"]
  s.email       = ["raasdnil@gmail.com", "donald.ball@gmail.com"]
  s.homepage    = "http://github.com/dball/mail"
  s.description = "A really Ruby Mail handler."
  s.summary     = "Mail provides a nice Ruby DSL for making, sending and reading emails."

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc", "TODO.rdoc"]

  s.add_dependency('activesupport', ">= 2.3.6")
  s.add_dependency('mime-types')
  s.add_dependency('treetop', '>= 1.4.5')

  s.require_path = 'lib'
  s.files = %w(README.rdoc Rakefile TODO.rdoc) + Dir.glob("lib/**/*")
end
