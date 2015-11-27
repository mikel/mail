source "https://rubygems.org"

gemspec

gem "tlsmail", "~> 0.0.1" if RUBY_VERSION <= "1.8.6"
gem "jruby-openssl", :platforms => :jruby

# For gems not required to run tests
group :local_development, :test do
  gem "appraisal", "~> 1.0" unless RUBY_VERSION <= "1.8.7"
end
