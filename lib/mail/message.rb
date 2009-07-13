module Mail
  # The Message class provides a single point of access to all things to do with an
  # email message.
  # 
  # You create a new email message by calling the Mail::Message.new method, or just
  # Mail.message
  # 
  # A Message object by default has the following objects inside it:
  # 
  # * A Header object which contians all information and settings of the header of the email
  # * Body object which contains all parts of the email that are not part of the header, this
  #   includes any attachments, body text, mime parts etc.
  # 
  # ==Per RFC2822
  # 
  #  2.1. General Description
  # 
  #   At the most basic level, a message is a series of characters.  A
  #   message that is conformant with this standard is comprised of
  #   characters with values in the range 1 through 127 and interpreted as
  #   US-ASCII characters [ASCII].  For brevity, this document sometimes
  #   refers to this range of characters as simply "US-ASCII characters".
  # 
  #   Note: This standard specifies that messages are made up of characters
  #   in the US-ASCII range of 1 through 127.  There are other documents,
  #   specifically the MIME document series [RFC2045, RFC2046, RFC2047,
  #   RFC2048, RFC2049], that extend this standard to allow for values
  #   outside of that range.  Discussion of those mechanisms is not within
  #   the scope of this standard.
  # 
  #   Messages are divided into lines of characters.  A line is a series of
  #   characters that is delimited with the two characters carriage-return
  #   and line-feed; that is, the carriage return (CR) character (ASCII
  #   value 13) followed immediately by the line feed (LF) character (ASCII
  #   value 10).  (The carriage-return/line-feed pair is usually written in
  #   this document as "CRLF".)
  # 
  #   A message consists of header fields (collectively called "the header
  #   of the message") followed, optionally, by a body.  The header is a
  #   sequence of lines of characters with special syntax as defined in
  #   this standard. The body is simply a sequence of characters that
  #   follows the header and is separated from the header by an empty line
  #   (i.e., a line with nothing preceding the CRLF).
  class Message
    
    include Patterns
    
    # Creates a new Mail::Message object through .new
    def initialize(*args, &block)
      self.raw_source = args.flatten[0]
      set_envelope_header
      parse_message 
      if block_given?
        instance_eval(&block)
      end
      self
    end
    
    # Provides access to the raw source of the message as it was when it
    # was instantiated. This is set at initialization and so is untouched
    # by the parsers or decoder / encoders
    #
    # Example:
    # 
    #  mail = Mail.new('This is an invalid email message')
    #  mail.raw_source #=> "This is an invalid email message"
    def raw_source
      @raw_source
    end
    
    def raw_source=(value)
      @raw_source = value.to_crlf
    end
    
    # The raw_envelope is the From mikel@me.com Mon May  2 16:07:05 2009
    # type field that you can see at the top of any email that has come
    # from a mailbox
    def raw_envelope
      @raw_envelope
    end
    
    # Sets the header of the message object.
    # 
    # Example:
    # 
    #  mail.header = 'To: mikel@me.com\r\nFrom: Bob@bob.com'
    #  mail.header #=> <#Mail::Header
    def header=(value)
      @header = Mail::Header.new(value)
    end

    # Returns the header object of the message object. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail = Mail::Message.new('To: mikel\r\nFrom: you')
    #  mail.header #=> #<Mail::Header:0x13ce14 @raw_source="To: mikel\r\nFr...
    # 
    #  mail.header #=> nil
    #  mail.header 'To: mikel\r\nFrom: you'
    #  mail.header #=> #<Mail::Header:0x13ce14 @raw_source="To: mikel\r\nFr...
    def header(value = nil)
      value ? self.header = value : @header
    end
    
    # Sets the body object of the message object.
    # 
    # Example:
    # 
    #  mail.body = 'This is the body'
    #  mail.body #=> #<Mail::Body:0x13919c @raw_source="This is the bo...
    def body=(value)
      @body = Mail::Body.new(value)
    end

    # Returns the body of the message object. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail = Mail::Message.new('To: mikel\r\n\r\nThis is the body')
    #  mail.body #=> #<Mail::Body:0x13919c @raw_source="This is the bo...
    # 
    #  mail.body 'This is another body'
    #  mail.body #=> #<Mail::Body:0x13919c @raw_source="This is anothe...
    def body(value = nil)
      value ? self.body = value : @body
    end
    
    # Sets the to filed of the message header.
    # 
    # Example:
    # 
    #  mail.to = '"Mikel Lindsaar" <mikel@me.com>'
    #  mail.to #=> '"Mikel Lindsaar" <mikel@me.com>'
    def to=(value)
      header[:to] = value
    end
    
    # Returns the to field in the message header. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.to = '"Mikel Lindsaar" <mikel@me.com>'
    #  mail.to #=> '"Mikel Lindsaar" <mikel@me.com>'
    #
    #  mail.to '"M L" <mikel@you.com>'
    #  mail.to #=> '"M L" <mikel@you.com>'
    def to(value = nil)
      value ? self.to = value : header[:to]
    end

    # Sets the from field in the message header.
    # 
    # Example:
    # 
    #  mail.from = '"Mikel Lindsaar" <mikel@me.com>'
    #  mail.from #=> '"Mikel Lindsaar" <mikel@me.com>'
    def from=(value)
      header[:from] = value
    end
    
    # Returns the from field in the message header. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.from = '"Mikel Lindsaar" <mikel@me.com>'
    #  mail.from #=> '"Mikel Lindsaar" <mikel@me.com>'
    # 
    #  mail.from '"M L" <mikel@you.com>'
    #  mail.from #=> '"M L" <mikel@you.com>'
    def from(value = nil)
      value ? self.from = value : header[:from]
    end
    
    # Sets the subject field in the message header.
    # 
    # Example:
    # 
    #  mail.subject = 'This is the subject'
    #  mail.subject #=> 'This is the subject'
    def subject=(value)
      header[:subject] = value
    end
    
    # Returns the subject field in the message header. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.subject = 'This is the subject'
    #  mail.subject #=> 'This is the subject'
    # 
    #  mail.subject 'This is another subject'
    #  mail.subject #=> 'This is another subject'
    def subject(value = nil)
      value ? self.subject = value : header[:subject]
    end

    # Allows you to add an arbitrary header
    # 
    # Example:
    #
    #  mail['foo'] = '1234'
    def []=(name, value)
      header[name] = value
    end

    # Allows you to read an arbitrary header
    # 
    # Example:
    #
    #  mail['foo'] = '1234'
    #  mail['foo'] #=> '1234'
    def [](name)
      header[name]
    end

    def header_fields
      header.fields
    end

    private

    #  2.1. General Description
    #   A message consists of header fields (collectively called "the header
    #   of the message") followed, optionally, by a body.  The header is a
    #   sequence of lines of characters with special syntax as defined in
    #   this standard. The body is simply a sequence of characters that
    #   follows the header and is separated from the header by an empty line
    #   (i.e., a line with nothing preceding the CRLF).
    # 
    # Additionally, I allow for the case where someone might have put whitespace
    # on the "gap line"
    def parse_message
      header_part, body_part = raw_source.split(/#{CRLF}#{WSP}*#{CRLF}/m, 2)
      self.header = header_part
      self.body   = body_part
    end
    
    def set_envelope_header
      if match_data = raw_source.match(/From\s(#{TEXT}+)#{CRLF}(.*)/m)
        @raw_envelope   = match_data[1]
        self.raw_source = match_data[2]
      end
    end

  end
end
