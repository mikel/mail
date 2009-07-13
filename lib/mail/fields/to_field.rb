  # 
  #    The "To:" field contains the address(es) of the primary recipient(s)
  #    of the message.
module Mail
  class ToField < StructuredField
    
    include Mail::Patterns
    
    
    def addresses
      result = AddressListParser.new.parse(value)
      
      if result
        result.addresses
      else
        raise Field::ParseError, "Can not understand <#{value}>"
      end
    end
    
  end
end
