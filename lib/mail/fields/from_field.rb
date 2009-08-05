# encoding: utf-8
# 
# from            =       "From:" mailbox-list CRLF
# 
module Mail
  class FromField < StructuredField
    
    include Mail::AddressField
    
    FIELD_NAME = 'from'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
