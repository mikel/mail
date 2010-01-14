# encoding: utf-8
module Mail
  
  # = Body
  # 
  # The body is where the text of the email is stored.  Mail treats the body
  # as a single object.  The body itself has no information about boundaries
  # used in the MIME standard, it just looks at it's content as either a single
  # block of text, or (if it is a multipart message) as an array of blocks o text.
  # 
  # A body has to be told to split itself up into a multipart message by calling
  # #split with the correct boundary.  This is because the body object has no way
  # of knowing what the correct boundary is for itself (there could be many
  # boundaries in a body in the case of a nested MIME text).
  # 
  # Once split is called, Mail::Body will slice itself up on this boundary,
  # assigning anything that appears before the first part to the preamble, and
  # anything that appears after the closing boundary to the epilogue, then
  # each part gets initialized into a Mail::Part object.
  # 
  # The boundary that is used to split up the Body is also stored in the Body
  # object for use on encoding itself back out to a string.  You can 
  # overwrite this if it needs to be changed.
  # 
  # On encoding, the body will return the preamble, then each part joined by
  # the boundary, followed by a closing boundary string and then the epilogue.
  class Body

    def initialize(string = '')
      @boundary = nil
      @preamble = nil
      @epilogue = nil
      @part_sort_order = [ "text/plain", "text/enriched", "text/html" ]
      @parts = []
      if string.blank?
        @raw_source = ''
      else
        @raw_source = string
      end
      @encoding = nil
      set_charset
    end
    
    # Matches this body with another body.  Also matches the decoded value of this
    # body with a string.
    # 
    # Examples:
    # 
    #   body = Mail::Body.new('The body')
    #   body == body #=> true
    #   
    #   body = Mail::Body.new('The body')
    #   body == 'The body' #=> true
    #   
    #   body = Mail::Body.new("VGhlIGJvZHk=\n")
    #   body.encoding = 'base64'
    #   body == "The body" #=> true
    def ==(other)
      if other.class == String
        self.decoded == other
      else
        super
      end
    end
    
    # Accepts a string and performs a regular expression against the decoded text
    # 
    # Examples:
    # 
    #   body = Mail::Body.new('The body')
    #   body =~ /The/ #=> 0
    #   
    #   body = Mail::Body.new("VGhlIGJvZHk=\n")
    #   body.encoding = 'base64'
    #   body =~ /The/ #=> 0
    def =~(regexp)
      self.decoded =~ regexp
    end
    
    # Accepts a string and performs a regular expression against the decoded text
    # 
    # Examples:
    # 
    #   body = Mail::Body.new('The body')
    #   body.match(/The/) #=> #<MatchData "The">
    #   
    #   body = Mail::Body.new("VGhlIGJvZHk=\n")
    #   body.encoding = 'base64'
    #   body.match(/The/) #=> #<MatchData "The">
    def match(regexp)
      self.decoded.match(regexp)
    end

    # Allows you to set the sort order of the parts, overriding the default sort order.
    # Defaults to 'text/plain', then 'text/enriched', then 'text/html' with any other content
    # type coming after.
    def set_sort_order(order)
      @part_sort_order = order
    end
    
    # Allows you to sort the parts according to the default sort order, or the sort order you
    # set with :set_sort_order.
    #
    # sort_parts! is also called from :encode, so there is no need for you to call this explicitly
    def sort_parts!
      order = @part_sort_order
      @parts = @parts.sort do |a, b|
        # OK, 10000 is arbitrary... if anyone actually wants to explicitly sort 10000 parts of a
        # single email message... please show me a use case and I'll put more work into this method,
        # in the meantime, it works :)
        a_order = order.index(a[:content_type].string.downcase) || 10000
        b_order = order.index(b[:content_type].string.downcase) || 10000
        a_order <=> b_order
      end
    end
    
    # Returns the raw source that the body was initialized with, without
    # any tampering
    def raw_source
      @raw_source
    end
    
    # Returns a US-ASCII 7-bit compliant body.  Right now just returns the
    # raw source.  Need to implement
    def encoded
      if multipart?
        self.sort_parts!
        encoded_parts = parts.map { |p| p.encoded }
        ([preamble] + encoded_parts).join(crlf_boundary) + end_boundary + epilogue.to_s
      else
        raw_source.to_crlf
      end
    end
    
    def decoded
      if encoding.nil? || !Encodings.defined?(encoding)
        raw_source.to_lf
      else
        Encodings.get_encoding(encoding).decode(raw_source)
      end
    end
    
    def to_s
      decoded
    end
    
    def to_str
      to_s
    end
    
    def charset
      @charset
    end
    
    def charset=( val )
      @charset = val
    end

    def encoding
      @encoding
    end
    
    def encoding=( val )
      @encoding = val
    end

    # Returns the preamble (any text that is before the first MIME boundary)
    def preamble
      @preamble
    end

    # Sets the preamble to a string (adds text before the first mime boundary)
    def preamble=( val )
      @preamble = val
    end
    
    # Returns the epilogue (any text that is after the last MIME boundary)
    def epilogue
      @epilogue
    end
    
    # Sets the epilogue to a string (adds text after the last mime boundary)
    def epilogue=( val )
      @epilogue = val
    end
    
    # Returns true if there are parts defined in the body
    def multipart?
      true unless parts.empty?
    end
    
    # Returns the boundary used by the body
    def boundary
      @boundary
    end
    
    # Allows you to change the boundary of this Body object
    def boundary=( val )
      @boundary = val
    end

    def parts
      @parts
    end
    
    def <<( val )
      if @parts
        @parts << val
      else
        @parts = [val]
      end
    end
    
    def split!(boundary)
      self.boundary = boundary
      parts = raw_source.split("--#{boundary}")
      # Make the preamble equal to the preamble (if any)
      self.preamble = parts[0].to_s.strip
      # Make the epilogue equal to the epilogue (if any)
      self.epilogue = parts[-1].to_s.sub('--', '').strip
      @parts = parts[1...-1].to_a.map { |part| Mail::Part.new(part) }
      self
    end
    
    def only_us_ascii?
      !!raw_source.to_s.ascii_only?
    end
    
    private
    
    def crlf_boundary
      "\r\n\r\n--#{boundary}\r\n"
    end
    
    def end_boundary
      "\r\n\r\n--#{boundary}--\r\n"
    end
    
    def set_charset
      raw_source.ascii_only? ? @charset = 'US-ASCII' : @charset = nil
    end
  end
end
