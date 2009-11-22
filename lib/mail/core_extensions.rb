# encoding: utf-8
module Mail
  begin
    require 'active_support/core_ext/object/blank'
  rescue LoadError
    # Unneeded for Active Support <= 3.0.pre
  end
  require 'mail/core_extensions/nil'
  require 'mail/core_extensions/string'
end
