source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gemspec

gem 'tlsmail', '~> 0.0.1' if RUBY_VERSION <= '1.8.6'
gem 'jruby-openssl', :platforms => :jruby

gem 'rake', '< 11.0' if RUBY_VERSION < '1.9.3'
gem 'rdoc', '< 4.3' if RUBY_VERSION < '2.0'

gem 'mini_mime', :github => 'discourse/mini_mime'
