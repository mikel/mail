# encoding: utf-8
# 
# trace           =       [return]
#                         1*received
# 
# return          =       "Return-Path:" path CRLF
# 
# path            =       ([CFWS] "<" ([CFWS] / addr-spec) ">" [CFWS]) /
#                         obs-path
# 
# received        =       "Received:" name-val-list ";" date-time CRLF
# 
# name-val-list   =       [CFWS] [name-val-pair *(CFWS name-val-pair)]
# 
# name-val-pair   =       item-name CFWS item-value
# 
# item-name       =       ALPHA *(["-"] (ALPHA / DIGIT))
# 
# item-value      =       1*angle-addr / addr-spec /
#                          atom / domain / msg-id
# 
module Mail
  class ReceivedField < StructuredField
    
    FIELD_NAME = 'received'
    CAPITALIZED_FIELD = 'Received'
    
    def initialize(*args)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
    end
    
    def tree
      @element ||= ReceivedElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= ReceivedElement.new(value)
    end
    
    def date_time
      ::DateTime.parse("#{element.date_time}")
    end

    def info
      element.info
    end
    
    def encoded
      "#{CAPITALIZED_FIELD}: #{value}"
    end
    
    def decoded
      value
    end
    
  end
end
