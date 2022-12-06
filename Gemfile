source 'https://rubygems.org'

gemspec

gem 'psych', '!= 5.0.0' # 5.0.0 does not work on JRuby (cannot find _native_parse method)

if RUBY_VERSION < '2.7.0'
  gem 'activesupport', '< 6'
else
  gem 'activesupport', :git => 'https://github.com/rails/rails', :branch => 'main'
end

gem 'jruby-openssl', :platforms => :jruby

gem 'mini_mime'

gem 'byebug', :platforms => :mri
