# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

begin
  if RUBY_VERSION >= '2.0'
    require 'byebug'
  elsif RUBY_VERSION >= '1.9'
    require 'debugger'
  else
    require 'ruby-debug'
  end
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
