# encoding: utf-8
module Mail
  # Provides a single class to call to create a new structured or unstructured
  # field.  Works out per RFC what field of field it is being given and returns
  # the correct field of class back on new.
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
    
    include Patterns
    include Comparable
    
    STRUCTURED_FIELDS = %w[ bcc cc content-description content-disposition
                            content-id content-location content-transfer-encoding
                            content-type date from in-reply-to keywords message-id
                            mime-version received references reply-to
                            resent-bcc resent-cc resent-date resent-from
                            resent-message-id resent-sender resent-to
                            return-path sender to ]

    KNOWN_FIELDS = STRUCTURED_FIELDS + ['comments', 'subject']
    
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
    
    # Accepts a string:
    # 
    #  Field.new("field-name: field data")
    # 
    # Or name, value pair:
    # 
    #  Field.new("field-name", "value")
    # 
    # Or a name by itself:
    # 
    #  Field.new("field-name")
    # 
    # Note, does not want a terminating carriage return.  Returns
    # self appropriately parsed.  If value is not a string, then
    # it will be passed through as is, for example, content-type
    # field can accept an array with the type and a hash of 
    # parameters:
    # 
    #  Field.new('content-type', ['text', 'plain', {:charset => 'UTF-8'}])
    def initialize(name, value = nil)
      case
      when name =~ /:/ && value.blank?   # Field.new("field-name: field data")
        name, value = split(name)
        create_field(name, value)
      when name !~ /:/ && value.blank?  # Field.new("field-name")
        create_field(name, nil)
      else                              # Field.new("field-name", "value")
        create_field(name, value)
      end
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
    
    def value
      field.value
    end
    
    def value=(str)
      create_field(name, str)
    end
    
    def to_s
      field.to_s
    end
    
    def update(name, value)
      create_field(name, value)
    end
    
    def same( other )
      match_to_s(other.name, field.name)
    end
    
    def <=>( other )
      self_order = FIELD_ORDER.rindex(self.name.to_s.downcase) || 100
      other_order = FIELD_ORDER.rindex(other.name.to_s.downcase) || 100
      self_order <=> other_order
    end
    
    def method_missing(name, *args, &block)
      field.send(name, *args, &block)
    end
    
    FIELD_ORDER = %w[ return-path received
                      resent-date resent-from resent-sender resent-to
                      resent-cc resent-bcc resent-message-id
                      date from sender reply-to to cc bcc
                      message-id in-reply-to references
                      subject comments keywords
                      mime-version content-type content-transfer-encoding
                      content-location content-disposition content-description ]
    
    private
    
    def split(raw_field)
      match_data = raw_field.match(/^(#{FIELD_NAME})\s*:\s*(#{FIELD_BODY})?$/)
      [match_data[1].to_s.strip, match_data[2].to_s.strip]
    rescue
      STDERR.puts "WARNING: Could not parse (and so ignorning) '#{raw_field}'"
    end

    def create_field(name, value)
      begin
        self.field = new_field(name, value)
      rescue
        self.field = Mail::UnstructuredField.new(name, value)
      end
    end

    def new_field(name, value)
      # Could do this with constantize and make it "as DRY as", but a simple case 
      # statement is, well, simpler... 
      case name.to_s
      when /^to$/i
        ToField.new(name, value)
      when /^cc$/i
        CcField.new(name, value)
      when /^bcc$/i
        BccField.new(name, value)
      when /^message-id$/i
        MessageIdField.new(name, value)
      when /^in-reply-to$/i
        InReplyToField.new(name, value)
      when /^references$/i
        ReferencesField.new(name, value)
      when /^subject$/i
        SubjectField.new(name, value)
      when /^comments$/i
        CommentsField.new(name, value)
      when /^keywords$/i
        KeywordsField.new(name, value)
      when /^date$/i
        DateField.new(name, value)
      when /^from$/i
        FromField.new(name, value)
      when /^sender$/i
        SenderField.new(name, value)
      when /^reply-to$/i
        ReplyToField.new(name, value)
      when /^resent-date$/i
        ResentDateField.new(name, value)
      when /^resent-from$/i
        ResentFromField.new(name, value)
      when /^resent-sender$/i 
        ResentSenderField.new(name, value)
      when /^resent-to$/i
        ResentToField.new(name, value)
      when /^resent-cc$/i
        ResentCcField.new(name, value)
      when /^resent-bcc$/i
        ResentBccField.new(name, value)
      when /^resent-message-id$/i
        ResentMessageIdField.new(name, value)
      when /^return-path$/i
        ReturnPathField.new(name, value)
      when /^received$/i
        ReceivedField.new(name, value)
      when /^mime-version$/i
        MimeVersionField.new(name, value)
      when /^content-transfer-encoding$/i
        ContentTransferEncodingField.new(name, value)
      when /^content-description$/i
        ContentDescriptionField.new(name, value)
      when /^content-disposition$/i
        ContentDispositionField.new(name, value)
      when /^content-type$/i
        ContentTypeField.new(name, value)
      when /^content-id$/i
        ContentIdField.new(name, value)
      when /^content-location$/i
        ContentLocationField.new(name, value)
      else 
        OptionalField.new(name, value)
      end
      
    end

  end
  
end
