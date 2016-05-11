source 'https://rubygems.org'

gemspec

gem "rake", "< 11.0" if RUBY_VERSION < '1.9.3'

gem "treetop", "~> 1.4.10"
gem "mime-types", "~> 1.16"
gem "tlsmail" if RUBY_VERSION <= '1.8.6'

gem 'jruby-openssl', :platform => :jruby

# For gems not required to run tests
group :local_development, :test do
end
