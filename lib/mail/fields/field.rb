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
    
    def initialize(raw_field)
      name, value = split(raw_field)
      if STRUCTURED_FIELDS.include?(name.downcase)
        self.field = Mail::StructuredField.new(raw_field, name, value)
      else
        self.field = Mail::UnstructuredField.new(raw_field, name, value)
      end
    end

    def field=(value)
      @field = value
    end
    
    def field
      @field
    end
    
    def name
      field.name
    end
    
    def name=(value)
      field.name = value
    end
    
    def value
      field.value
    end
    
    def value=(value)
      field.value = value
    end
    
    private
    
    def split(raw_field)
      match_data = raw_field.match(/^(.+):\s(.*)$/)
      [match_data[1], match_data[2]]
    end
    
  end
  
end
