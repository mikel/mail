require 'rubygems'
require 'spec'
$:.unshift "#{File.dirname(__FILE__)}/mail"
$:.unshift "#{File.dirname(__FILE__)}/../lib"
$:.unshift "#{File.dirname(__FILE__)}/../lib/mail"

def fixture(name)
  File.join(File.dirname(__FILE__), 'fixtures', name)
end

alias doing lambda