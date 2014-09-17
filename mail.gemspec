require './lib/mail/version'

Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = Mail::VERSION::STRING
  s.author      = "Mikel Lindsaar"
  s.email       = "raasdnil@gmail.com"
  s.homepage    = "https://github.com/mikel/mail"
  s.description = "A really Ruby Mail handler."
  s.summary     = "Mail provides a nice Ruby DSL for making, sending and reading emails."
  s.license     = "MIT"

  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "CONTRIBUTING.md", "CHANGELOG.rdoc", "TODO.rdoc"]
  s.rdoc_options << '--exclude' << 'lib/mail/values/unicode_tables.dat'

  s.add_dependency('mime-types', [">= 1.16", "< 3"])

  s.add_development_dependency('bundler', '>= 1.0.3')
  s.add_development_dependency('rake', '> 0.8.7')
  s.add_development_dependency('rspec', '~> 3.0.0')
  s.add_development_dependency('rdoc')

  s.files = %w(README.md MIT-LICENSE CONTRIBUTING.md CHANGELOG.rdoc Dependencies.txt Gemfile Rakefile TODO.rdoc) + Dir.glob("lib/**/*")
end
