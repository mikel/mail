#!/usr/bin/env ruby

require 'rubygems'
dir = File.dirname(__FILE__)
require File.join(dir, '..', 'lib', 'treetop', 'bootstrap_gen_1_metagrammar')

GENERATED_METAGRAMMAR_PATH = File.join(TREETOP_ROOT, 'compiler', 'metagrammar.rb')

File.open(METAGRAMMAR_PATH) do |source_file|
  File.open(GENERATED_METAGRAMMAR_PATH, 'w') do |target_file|
    generated_source = Treetop::Compiler::MetagrammarParser.new.parse(source_file.read).compile
    target_file.write(generated_source)
  end
end