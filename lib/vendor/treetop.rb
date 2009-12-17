# Have to vendor treetop to avoid loading polyglot

$:.unshift "#{File.dirname(__FILE__)}/treetop-1.4.3"
TREETOP_DISABLE_POLYGLOT = true
require 'treetop'
