  # 
  #    The "To:" field contains the address(es) of the primary recipient(s)
  #    of the message.
module Mail
  class ToField < StructuredField
    
    include Mail::AddressField
    
  end
end
