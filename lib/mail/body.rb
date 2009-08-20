# encoding: utf-8
module Mail
  
  # = Body
  # 
  # The body is where the meat of the email is stored.  You can assign
  # this as a string.  It provides a raw_source accessor.
  class Body

    def initialize(string = '')
      if string.blank?
        @raw_source = ''
      else
        @raw_source = string
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
      raw_source
    end
    
    alias :to_s :encoded

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
    
    def split(boundary)
      parts = raw_source.split(boundary)
      # Make the preamble equal to the preamble (if any)
      self.preamble = parts[0].to_s.chomp
      # Make the epilogue equal to the preamble (if any)
      self.epilogue = parts[-1].to_s.chomp.chomp('--')
      parts[1...-1].map { |part| Mail::Part.new(part) }
    end
    
    def only_us_ascii?
      !!raw_source.to_s.ascii_only?
    end
    
  end
end