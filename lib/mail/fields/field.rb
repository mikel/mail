module Mail
  # Provides a single class to call to create a new structured or unstructured
  # field.  Works out per RFC what type of field it is being given and returns
  # the correct type of class back on new.
  # 
  # ===Per RFC 2822
  #  
  #  2.2. Header Fields
  #  
  #     Header fields are lines composed of a field name, followed by a colon
  #     (":"), followed by a field body, and terminated by CRLF.  A field
  #     name MUST be composed of printable US-ASCII characters (i.e.,
  #     characters that have values between 33 and 126, inclusive), except
  #     colon.  A field body may be composed of any US-ASCII characters,
  #     except for CR and LF.  However, a field body may contain CRLF when
  #     used in header "folding" and  "unfolding" as described in section
  #     2.2.3.  All field bodies MUST conform to the syntax described in
  #     sections 3 and 4 of this standard.
  #  
  class Field
    
    STRUCTURED_FIELDS = %w[ date from sender reply-to to cc bcc message-id in-reply-to
                            references keywords resent-date resent-from resent-sender
                            resent-to resent-cc resent-bcc resent-message-id 
                            return-path received ]
    
    require 'fields/structured_field'
    require 'fields/unstructured_field'
    
    def Field.new(name, value = '')
      if STRUCTURED_FIELDS.include?(name.downcase)
        @field = Mail::StructuredField.new(name, value)
      else
        @field = Mail::UnstructuredField.new(name, value)
      end
    end
    
    def valid?
      @field.valid?
    end
    
  end
  
end
