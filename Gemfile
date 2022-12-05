source 'https://rubygems.org'

gemspec

gem 'psych', '!= 5.0.0' # fails with undefined method `_native_parse' for #<Psych::Parser:0x2bd276f0>

if RUBY_VERSION < '2.7.0'
  gem 'activesupport', '< 6'
else
  gem 'activesupport', :git => 'https://github.com/rails/rails', :branch => 'main'
end

gem 'jruby-openssl', :platforms => :jruby

gem 'mini_mime'

gem 'byebug', :platforms => :mri
