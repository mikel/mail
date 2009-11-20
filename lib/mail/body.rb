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
      if string.blank?
        @raw_source = ''
      else
        @raw_source = string
      end
      set_charset
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
        encoded_parts = parts.map { |p| p.to_s }
        ([preamble] + encoded_parts).join(crlf_boundary) + end_boundary + epilogue.to_s
      else
        raw_source.to_crlf
      end
    end
    
    alias :to_s :encoded
    
    # Returns the raw source right now.  Need to implement
    def decoded
      raw_source.to_lf
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
      @parts ||= []
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