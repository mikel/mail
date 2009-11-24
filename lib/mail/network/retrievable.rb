# encoding: utf-8

# Include this module to retrieve emails via POP3. Each email retrieved is given to a new instance of the "includer".
# This module uses the defaults set in Configuration to retrieve POP3 settings.
#
# Thanks to Nicolas Fouché for this wrapper
#
module Mail
  module Retrievable

    def self.get_messages
      Mail.defaults.retriever_method.get_messages
    end
  
  end
  
end
