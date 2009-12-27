# Have to vendor treetop to avoid loading polyglot

$:.unshift "#{File.dirname(__FILE__)}/treetop-1.4.3/lib"
require 'treetop'
