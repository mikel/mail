  # 
  #    The "To:" field contains the address(es) of the primary recipient(s)
  #    of the message.
module Mail
  class ToField < StructuredField
    
    include Mail::AddressField
    
    FIELD_NAME = 'to'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
