module Mail
  module Patterns

    white_space = %Q|\x9\x20|
    text        = %Q|\x1-\x8\xB\xC\xE-\x7f|
    field_name  = %Q|\x21-\x39\x3b-\x7e|
    field_body  = text
    
    aspecial     = %Q|()<>[]:;.\\,"|
    tspecial     = %Q|()<>[];:\\,"/?=|
    lwsp         = %Q| \t\r\n|
    control      = %Q|\x00-\x1f\x7f-\xff|
    
    CRLF          = /\r\n/
    WSP           = /[#{white_space}]/
    FWS           = /#{CRLF}#{WSP}*/
    TEXT          = /[#{text}]/ # + obs-text
    FIELD_NAME    = /[#{field_name}]+/
    FIELD_BODY    = /[#{field_body}]+/
    FIELD_LINE    = /^[#{field_name}]+:\s*[#{field_body}]+$/
    HEADER_LINE   = /^([#{field_name}]+:\s*[#{field_body}]+)/

    CONTROL_CHAR  = /[#{control}]/n
    ATOM_UNSAFE   = /[#{Regexp.quote aspecial}#{control}#{lwsp}]/n
    PHRASE_UNSAFE = /[#{Regexp.quote aspecial}#{control}]/n
    TOKEN_UNSAFE  = /[#{Regexp.quote tspecial}#{control}#{lwsp}]/n
    
    
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