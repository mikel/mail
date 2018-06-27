require './lib/mail/version'

gem_version = if ENV['GEM_PRE_RELEASE'].nil? || ENV['GEM_PRE_RELEASE'].empty?
                Mail::VERSION
              else
                "#{Mail::VERSION}.#{ENV['GEM_PRE_RELEASE']}"
              end

Gem::Specification.new do |s|
  s.name        = "mail"
  s.version     = gem_version
  s.author      = "Mikel Lindsaar"
  s.email       = "raasdnil@gmail.com"
  s.homepage    = "https://github.com/mikel/mail"
  s.description = "A really Ruby Mail handler."
  s.summary     = "Mail provides a nice Ruby DSL for making, sending and reading emails."
  s.license     = "MIT"

  s.has_rdoc = true
  s.extra_rdoc_files = %w[ README.md ]
  s.rdoc_options << '--exclude' << 'lib/mail/values/unicode_tables.dat'

  s.add_dependency('mini_mime', '>= 0.1.1')

  s.add_development_dependency('bundler', '>= 1.0.3')
  s.add_development_dependency('rake', '> 0.8.7')
  s.add_development_dependency('rspec', '~> 3.0')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rufo')

  s.files = %w[ README.md MIT-LICENSE ] + Dir.glob("lib/**/*")
end
