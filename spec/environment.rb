# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

begin
  require 'byebug'
rescue LoadError
end

require 'mail'

if ENV['MBCHARS'] == 'activesupport'
  require 'active_support'
  Mail::Multibyte.proxy_class = ActiveSupport::Multibyte::Chars
else
  require 'mail/multibyte/chars'
  Mail::Multibyte.proxy_class = Mail::Multibyte::Chars
end
