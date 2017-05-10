source 'https://rubygems.org'

gemspec

gem 'tlsmail', '~> 0.0.1' if RUBY_VERSION <= '1.8.6'
gem 'jruby-openssl', :platforms => :jruby

gem 'rake', '< 11.0' if RUBY_VERSION < '1.9.3'
gem 'rdoc', '< 4.3' if RUBY_VERSION < '2.0'

gem 'mini_mime', :git => 'https://github.com/discourse/mini_mime'

if RUBY_VERSION >= '2.0'
  gem 'byebug', :platforms => :mri
elsif RUBY_VERSION >= '1.9'
  gem 'debugger', :platforms => :mri
else
  gem 'ruby-debug', :platforms => :mri
end
