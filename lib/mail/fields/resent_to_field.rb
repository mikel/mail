# encoding: utf-8
# 
# resent-to       =       "Resent-To:" address-list CRLF
module Mail
  class ResentToField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'resent-to'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
