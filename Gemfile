source 'https://rubygems.org'

gemspec

if ENV['MBCHARS'] # see spec/environment.rb
  if RUBY_VERSION < '2.7.0'
    gem 'activesupport', '< 6'
  else
    gem 'activesupport', :git => 'https://github.com/rails/rails', :branch => 'main'
  end
end

gem 'jruby-openssl', :platforms => :jruby

gem 'mini_mime'

gem 'byebug', :platforms => :mri
