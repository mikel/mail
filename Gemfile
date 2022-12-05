source 'https://rubygems.org'

gem 'psych', '4.0.6' # temp fix; looks like 5.0.0 is broken

gemspec


if RUBY_VERSION < '2.7.0'
  gem 'activesupport', '< 6'
else
  gem 'activesupport', :git => 'https://github.com/rails/rails', :branch => 'main'
end

gem 'jruby-openssl', :platforms => :jruby

gem 'mini_mime'

gem 'byebug', :platforms => :mri
