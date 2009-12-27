require 'rubygems'

module Treetop
  VALID_GRAMMAR_EXT = ['treetop', 'tt']
  VALID_GRAMMAR_EXT_REGEXP = /\.(#{VALID_GRAMMAR_EXT.join('|')})\Z/o
end

dir = File.dirname(__FILE__)

TREETOP_ROOT = File.join(dir, 'treetop')
require File.join(TREETOP_ROOT, "ruby_extensions")
require File.join(TREETOP_ROOT, "runtime")
require File.join(TREETOP_ROOT, "compiler")

# To have Polyglot extensions loaded, you need to require 'polyglot'
# before you require 'treetop'
if defined?(Polyglot)
  Polyglot.register(Treetop::VALID_GRAMMAR_EXT, Treetop)
end