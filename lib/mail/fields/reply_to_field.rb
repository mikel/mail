# encoding: utf-8
# 
# reply-to        =       "Reply-To:" address-list CRLF
# 
module Mail
  class ReplyToField < StructuredField
    
    include Mail::AddressField
    
    FIELD_NAME = 'reply-to'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
