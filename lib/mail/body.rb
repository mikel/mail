# encoding: utf-8
module Mail
  
  # = Body
  # 
  # The body is where the meat of the email is stored.  You can assign
  # this as a string.  It provides a raw_source accessor.
  class Body

    attr_accessor :preamble, :epilogue
    
    def initialize(string = '')
      if string.blank?
        @raw_source = ''
      else
        @raw_source = string
      end
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