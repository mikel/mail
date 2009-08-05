# encoding: utf-8
# 
# resent-cc       =       "Resent-Cc:" address-list CRLF
module Mail
  class ResentCcField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'resent-cc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
