source 'http://rubygems.org'

gem "activesupport", "~> 2.3.6.pre"
gem "tlsmail" if RUBY_VERSION <= '1.8.6'
gem "mime-types"
gem "treetop", ">= 1.4.5"

group :test do
  gem "rcov"
  gem "rake"
  gem "bundler"
  gem "cucumber"
  gem "rspec"
  gem "diff-lcs"
  case
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    # Skip it
  when RUBY_PLATFORM == 'java'
    # Skip it
  when RUBY_VERSION < '1.9'
    gem "ruby-debug"
  when RUBY_VERSION > '1.9' && RUBY_VERSION < '1.9.2'
    gem "ruby-debug19"
  else
    # Skip it
  end
  gem "ZenTest"
end
