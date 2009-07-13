  # 
  #    The "To:" field contains the address(es) of the primary recipient(s)
  #    of the message.
module Mail
  class ToField < StructuredField
    
    include Mail::Patterns
    
    def addresses
      get_addresses(value)
    end
    
    def get_addresses
      
    end
    
  end
end
