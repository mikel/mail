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
    
    require 'header'
    require 'body'
    
    def Message.parse(message)
      new(message)
    end

    # Creates a new Mail::Message object through .new
    def initialize(raw_source, &block)
      @raw_source = raw_source
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
    
    # Sets the to filed of the message header.
    # 
    # Example:
    # 
    #  mail.to = '"Mikel Lindsaar" <mikel@me.com>'
    #  mail.to #=> '"Mikel Lindsaar" <mikel@me.com>'
    def to=(value)
      @to = value
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
      value ? @to = value : @to
    end

    # Sets the from field in the message header.
    # 
    # Example:
    # 
    #  mail.from = '"Mikel Lindsaar" <mikel@me.com>'
    #  mail.from #=> '"Mikel Lindsaar" <mikel@me.com>'
    def from=(value)
      @from = value
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
      value ? @from = value : @from
    end
    
    # Sets the subject field in the message header.
    # 
    # Example:
    # 
    #  mail.subject = 'This is the subject'
    #  mail.subject #=> 'This is the subject'
    def subject=(value)
      @subject = value
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
      value ? @subject = value : @subject
    end
    
    # Sets the body of the message object.
    # 
    # Example:
    # 
    #  mail.body = 'This is the body'
    #  mail.body #=> 'This is the body'
    def body=(value)
      @body = value
    end

    # Returns the body of the message object. Or, if passed
    # a parameter sets the value.
    # 
    # Example:
    # 
    #  mail.body = 'This is the body'
    #  mail.body #=> 'This is the body'
    # 
    #  mail.body 'This is another body'
    #  mail.body #=> 'This is another body'
    def body(value = nil)
      value ? @body = value : @body
    end

  end
end
