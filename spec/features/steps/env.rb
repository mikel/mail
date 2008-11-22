$:.unshift "#{File.dirname(__FILE__)}/../../../lib"
$:.unshift "#{File.dirname(__FILE__)}/../../../lib/mail"

require 'mail'

alias :doing :lambda