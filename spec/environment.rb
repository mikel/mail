# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

begin
  require 'byebug'
rescue LoadError
end

require 'mail'
require 'mail/parsers'
