source "https://rubygems.org"

gemspec

gem "mime-types", "~> 1.16"

gem "tlsmail", "~> 0.0.1" if RUBY_VERSION <= "1.8.6"
gem "jruby-openssl", :platforms => :jruby

group :test do
  gem "ruby-debug", :platforms => :mri_18
end
