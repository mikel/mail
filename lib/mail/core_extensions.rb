# encoding: utf-8
module Mail
  begin
    require 'active_support/core_ext/object/blank'
  rescue LoadError
    # For Active Support <= 2.3.4
    require 'active_support/core_ext/blank'
  end
  require 'mail/core_extensions/nil'
  require 'mail/core_extensions/string'
end
