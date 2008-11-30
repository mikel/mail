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
    
    # Generic Field Exception
    class FieldError < StandardError
    end

    # Raised when a parsing error has occurred (ie, a StructuredField has tried
    # to parse a field that is invalid or improperly written)
    class ParseError < FieldError #:nodoc:
    end

    # Raised when attempting to set a structured field's contents to an invalid syntax
    class SyntaxError < FieldError #:nodoc:
    end
    
    require 'fields/structured_field'
    require 'fields/unstructured_field'
    
    # Accepts a text string in the format of:
    # 
    #  "field-name: field data"
    # 
    # Note, does not want a terminating carriage return.  Returns
    # self appropriately parsed
    def initialize(raw_field_text)
      name, value = split(raw_field_text)
      create_field(name, value)
      return self
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
    
    def to_s
      field.to_s
    end
    
    private
    
    def split(raw_field)
      match_data = raw_field.match(/^(.+):\s(.*)$/)
      [match_data[1], match_data[2]]
    end
    
    STRUCTURED_FIELDS = %w[ date from sender reply-to to cc bcc message-id in-reply-to
                            references keywords resent-date resent-from resent-sender
                            resent-to resent-cc resent-bcc resent-message-id 
                            return-path received ]

    # Attempts to parse the field as a structured field if it is of the 
    # appropriate type, if this fails, parses it as a plain field to keep
    # the data, otherwise, if it is not a structured field, parses it as
    # an unstructured field.... You'll understand if you read the code :)
    # The idea is to ALWAYS parse the data and return the data, not to
    # dump and delete on unknown headers.
    def create_field(name, value)
      if STRUCTURED_FIELDS.include?(name.downcase)
        begin
          self.field = Mail::StructuredField.new(name, value)
        rescue
          self.field = Mail::UnstructuredField.new(name, value)
        end
      else
        self.field = Mail::UnstructuredField.new(name, value)
      end
    end

  end
  
end
