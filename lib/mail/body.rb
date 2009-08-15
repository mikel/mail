# encoding: utf-8
module Mail
  
  # = Body
  # 
  # The body is where the meat of the email is stored.  You can assign
  # this as a string.  It provides a raw_source accessor.
  class Body

    attr_accessor :preamble, :epilogue
    
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
    
    def split(boundary)
      parts = raw_source.split(boundary)
      # Make the preamble equal to the preamble (if any)
      self.preamble = parts[0].to_s
      # Make the epilogue equal to the preamble (if any)
      self.epilogue = $1 if parts[-1].to_s =~ /^--(.*)/
      parts[1...-1].map { |part| Mail.new(part) }
    end
    
    def only_us_ascii?
      !!raw_source.to_s.ascii_only?
    end

    private
    
    def raw_source=(raw_source)
      @raw_source = raw_source
    end
    
  end
end