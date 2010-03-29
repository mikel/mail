begin
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # bust gem prelude
  if defined? Gem
    Gem.cache
    gem 'bundler'
  else
    require 'rubygems'
  end
  require 'bundler'
  Bundler.setup
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
