# encoding: utf-8
module Mail
  # The Message class provides a single point of access to all things to do with an
  # email message.
  # 
  # You create a new email message by calling the Mail::Message.new method, or just
  # Mail.new
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
    include Utilities
    include Deliverable
    include RetrieveViaPop3
    
    # Creates a new Mail::Message object through .new
    def initialize(*args, &block)
      self.raw_source = args.flatten[0]
      set_envelope_header
      parse_message
      separate_parts if multipart?
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
    
    def set_envelope( val )
      @raw_envelope = val
      @envelope = Mail::Envelope.new( val )
    end
    
    def set_envelope( val )
      @raw_envelope = val
      @envelope = Mail::Envelope.new( val )
    end
    
    # The raw_envelope is the From mikel@test.lindsaar.net Mon May  2 16:07:05 2009
    # type field that you can see at the top of any email that has come
    # from a mailbox
    def raw_envelope
      @raw_envelope
    end
    
    def envelope_from
      @envelope ? @envelope.from : nil
    end
    
    def envelope_date
      @envelope ? @envelope.date : nil
    end
    
    # Sets the header of the message object.
    # 
    # Example:
    # 
    #  mail.header = 'To: mikel@test.lindsaar.net\r\nFrom: Bob@bob.com'
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
    #  mail.to = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
    #  mail.to #=> '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
    def to=(value)
      header[:to] = value
    end
    
    # Returns the to field in the message header. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.to = '"M L" <mikel@test.lindsaar.net>'
    #  mail.to.to_s #=> '"M L" <mikel@test.lindsaar.net>'
    #  mail.to.formatted #=> ['"M L" <mikel@test.lindsaar.net>']
    #  mail.to.addresses #=> ['mikel@test.lindsaar.net']
    def to(value = nil)
      value ? self.to = value : header[:to]
    end

    # Sets the from field in the message header.
    # 
    # Example:
    # 
    #  mail.from = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
    #  mail.from.to_s #=> '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
    def from=(value)
      header[:from] = value
    end
    
    # Returns the from field in the message header. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.from = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
    #  mail.from.to_s #=> '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
    # 
    #  mail.from '"M L" <mikel@test.lindsaar.net>'
    #  mail.from.to_s #=> '"M L" <mikel@test.lindsaar.net>'
    #  mail.from.formatted #=> ['"M L" <mikel@test.lindsaar.net>']
    #  mail.from.addresses #=> ['mikel@test.lindsaar.net']
    def from(value = nil)
      value ? self.from = value : header[:from]
    end
    
    # Sets the subject field in the message header.
    # 
    # Example:
    # 
    #  mail.subject = 'This is the subject'
    #  mail.subject.to_s #=> 'This is the subject'
    def subject=(value)
      header[:subject] = value
    end
    
    # Returns the subject field in the message header. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.subject = 'This is the subject'
    #  mail.subject.to_s #=> 'This is the subject'
    # 
    #  mail.subject 'This is another subject'
    #  mail.subject.to_s #=> 'This is another subject'
    def subject(value = nil)
      value ? self.subject = value : header[:subject]
    end
    
    # Allows you to add an arbitrary header
    # 
    # Example:
    #
    #  mail['foo'] = '1234'
    #  mail['foo'].to_s #=> '1234'
    def []=(name, value)
      if name.to_s == 'body'
        self.body = value
      else
        header[underscoreize(name)] = value
      end
    end

    # Allows you to read an arbitrary header
    # 
    # Example:
    #
    #  mail['foo'] = '1234'
    #  mail['foo'].to_s #=> '1234'
    def [](name)
      header[underscoreize(name)]
    end
    
    # Method Missing in this implementation allows you to set any of the
    # standard fields directly as you would the "to", "subject" etc.
    # 
    # Those fields used most often (to, subject et al) are given their
    # own method for ease of documentation and also to avoid the hook 
    # call to method missing.
    # 
    # This will only catch the known fields listed in:
    #
    #  Mail::Field::KNOWN_FIELDS
    #
    # as per RFC 2822, any ruby string or method name could pretty much
    # be a field name, so we don't want to just catch ANYTHING sent to
    # a message object and interpret it as a header.
    # 
    # This method provides all three types of header call to set, read
    # and explicitly set with the = operator
    # 
    # Examples:
    # 
    #  mail.comments = 'These are some comments'
    #  mail.comments.to_s #=> 'These are some comments'
    # 
    #  mail.comments 'These are other comments'
    #  mail.comments.to_s #=> 'These are other comments'
    # 
    # 
    #  mail.date = 'Tue, 1 Jul 2003 10:52:37 +0200'
    #  mail.date.to_s #=> 'Tue, 1 Jul 2003 10:52:37 +0200'
    # 
    #  mail.date 'Tue, 1 Jul 2003 10:52:37 +0200'
    #  mail.date.to_s #=> 'Tue, 1 Jul 2003 10:52:37 +0200'
    # 
    #
    #  mail.resent_msg_id = '<1234@resent_msg_id.lindsaar.net>'
    #  mail.resent_msg_id.to_s #=> '<1234@resent_msg_id.lindsaar.net>'
    # 
    #  mail.resent_msg_id '<4567@resent_msg_id.lindsaar.net>'
    #  mail.resent_msg_id.to_s #=> '<4567@resent_msg_id.lindsaar.net>'
    def method_missing(name, *args, &block)
      #:nodoc:
      # Only take the structured fields, as we could take _anything_ really
      # as it could become an optional field... "but therin lies the dark side"
      field_name = underscoreize(name).chomp("=")
      if Mail::Field::KNOWN_FIELDS.include?(field_name)
        if args.empty?
          header[field_name]
        else
          header[field_name] = args.first
        end
      else
        super # otherwise pass it on 
      end 
      #:startdoc:
    end 

    # Returns an FieldList of all the fields in the header in the order that
    # they appear in the header
    def header_fields
      header.fields
    end

    # Returns true if the message has a message ID field, the field may or may
    # not have a value, but the field exists or not.
    def has_message_id?
      header.has_message_id?
    end

    # Returns true if the message has a Date field, the field may or may
    # not have a value, but the field exists or not.
    def has_date?
      header.has_date?
    end

    # Creates a new empty Message-ID field and inserts it in the correct order
    # into the Header.  The MessageIdField object will automatically generate
    # a unique message ID if you try and encode it or output it to_s without
    # specifying a message id.
    # 
    # It will preserve the message ID you specify if you do.
    def add_message_id(msg_id = nil)
      header.fields << MessageIdField.new(msg_id)
    end
    
    # Creates a new empty Date field and inserts it in the correct order
    # into the Header.  The DateField object will automatically generate
    # DateTime.now's date if you try and encode it or output it to_s without
    # specifying a date yourself.
    # 
    # It will preserve any date you specify if you do.
    def add_date(date = nil)
      header.fields << DateField.new(date)
    end
    
    # Outputs an encoded string representation of the mail message including
    # all headers, attachments, etc.  This is an encoded email in US-ASCII,
    # so it is able to be directly sent to an email server.
    def encoded
      add_message_id unless has_message_id?
      add_date unless has_date?
      buffer = header.encoded
      buffer << "\r\n"
      buffer << body.encoded
      buffer
    end
    
    alias :to_s :encoded
    
    # Mime Version returns the version string out of the Mime-Version header
    # field if present, otherwise returns nil
    def mime_version
      header ? header.mime_version : nil
    end
    
    # Returns the content transfer encoding of the email
    def transfer_encoding
      header ? header.transfer_encoding : nil
    end
    
    # Returns the content description of the email
    def description
      header ? header.description : nil
    end
    
    # Returns the content type
    def content_type
      header ? header.content_type : nil
    end
    
    # Returns the main content type
    def main_type
      header ? header.main_type : nil
    end
    
    # Returns the sub content type
    def sub_type
      header ? header.sub_type : nil
    end
    
    # Returns the content type parameters
    def mime_parameters
      header ? header.mime_parameters : nil
    end
    
    # Returns true if the message is multipart
    def multipart?
      main_type =~ /^multipart$/i
    end
    
    # Returns an array of parts in the message
    def parts
      @parts
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
        set_envelope(match_data[1])
        self.raw_source = match_data[2]
      end
    end

    def separate_parts
      @parts = body.split(mime_parameters['boundary'])
    end

    class << self

      # Only POP3 is supported for now
      def get_all_mail(&block)
        self.pop3_get_all_mail(&block)
      end

    end

  end
end
