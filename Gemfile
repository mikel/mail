source 'https://rubygems.org'

gemspec

# only needed if this condition holds (see environment.rb)
if ENV['MBCHARS'] == 'activesupport'
  if RUBY_VERSION < '2.7.0'
    gem 'activesupport', '< 6'
  else
    gem 'activesupport', :git => 'https://github.com/rails/rails', :branch => 'main'
  end
end

gem 'jruby-openssl', :platforms => :jruby

gem 'mini_mime'

gem 'byebug', :platforms => :mri

gem "strscan", ">= 3.0.2.pre1"
