# encoding: utf-8
module Mail
  
  # = Body
  # 
  # The body is where the meat of the email is stored.  You can assign
  # this as a string.  It provides a raw_source accessor.
  class Body
    
    def initialize(raw_source = nil)
      self.raw_source = raw_source
    end
    
    def raw_source
      @raw_source
    end
    
    def encoded
      raw_source
    end
    
    alias :to_s :encoded
    
    private
    
    def raw_source=(raw_source)
      @raw_source = raw_source
    end
    
  end
end