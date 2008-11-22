require 'rubygems'
require 'spec'
$:.unshift "#{File.dirname(__FILE__)}/mail"
$:.unshift "#{File.dirname(__FILE__)}/../lib"
$:.unshift "#{File.dirname(__FILE__)}/../lib/mail"

FIXTURE_PATH = File.join(File.dirname(__FILE__), 'fixtures')

alias doing lambda