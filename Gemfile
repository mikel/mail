source 'https://rubygems.org'

gemspec

gem 'activesupport', '>= 2.3.6' if RUBY_VERSION >= '1.9.3'
gem 'activesupport', '>= 2.3.6', '< 4.0.0' if RUBY_VERSION < '1.9.3'
gem "tlsmail" if RUBY_VERSION <= '1.8.6'
gem "mime-types", "~> 1.16"
gem "treetop", "~> 1.4.10"

gem 'jruby-openssl', :platform => :jruby

# For gems not required to run tests
group :local_development, :test do
  gem 'rake', '> 0.8.7' if RUBY_VERSION >= '1.9.3'
  gem 'rake', '> 0.8.7', '< 11.0.1' if RUBY_VERSION < '1.9.3'
  gem 'rdoc', '< 5' if RUBY_VERSION < '1.9'
  gem "rspec",      "~> 2.8.0"
  case
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    # Skip it
  when RUBY_PLATFORM == 'java'
    # Skip it
  when RUBY_VERSION < '1.9'
    gem "ruby-debug"
  else
    # Skip it
  end
end
