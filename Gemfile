source 'https://rubygems.org'

gemspec

if RUBY_VERSION < '2.7.0'
  gem 'activesupport', '< 6'
else
  gem 'activesupport', :git => 'https://github.com/rails/rails', :branch => 'main'
end

gem 'jruby-openssl', :platforms => :jruby

gem 'mini_mime'
gem 'simpleidn' if RUBY_VERSION >= '1.9.3' && ENV['SIMPLEIDN'] != 'no'

gem 'byebug', :platforms => :mri
