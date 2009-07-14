module Mail
  module Patterns

    white_space = %Q|\x9\x20|
    text        = %Q|\x1-\x8\xB\xC\xE-\x7f|
    field_name  = %Q|\x21-\x39\x3b-\x7e|
    field_body  = text
    
    TEXT       = /[#{text}]/ # + obs-text
    FIELD_NAME = /[#{field_name}]+/
    FIELD_BODY = /[#{field_body}]+/
    CRLF       = /\r\n/
    WSP        = /[#{white_space}]/
    FWS        = /#{CRLF}#{WSP}+/
    
    module ClassMethods
      
    end
  
    module InstanceMethods
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end