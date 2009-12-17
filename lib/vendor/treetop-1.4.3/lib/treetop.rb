
module Treetop
  VALID_GRAMMAR_EXT = ['treetop', 'tt']
  VALID_GRAMMAR_EXT_REGEXP = /\.(#{VALID_GRAMMAR_EXT.join('|')})\Z/o
end

dir = File.dirname(__FILE__)

TREETOP_ROOT = File.join(dir, 'treetop')
require File.join(TREETOP_ROOT, "ruby_extensions")
require File.join(TREETOP_ROOT, "runtime")
require File.join(TREETOP_ROOT, "compiler")

unless defined?(::TREETOP_DISABLE_POLYGLOT)
  require 'polyglot'
  Polyglot.register(Treetop::VALID_GRAMMAR_EXT, Treetop)
end