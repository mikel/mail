source 'http://rubygems.org'

gem 'activesupport', '2.3.6',
  :git => 'git://github.com/rails/rails.git',
  :ref => '2-3-stable'
gem "tlsmail" if RUBY_VERSION <= '1.8.6'
gem "mime-types"

group :test do
  gem "rcov"
  gem "rake"
  gem "bundler", "~> 0.9.10"
  gem "cucumber"
  gem "rspec"
  gem "diff-lcs"
  gem "ruby-debug" if RUBY_VERSION < '1.9'
end
