# encoding: utf-8
module Mail
  class Body
    
    #  2.1. General Description
    #   A message consists of header fields (collectively called "the header
    #   of the message") followed, optionally, by a body.  The header is a
    #   sequence of lines of characters with special syntax as defined in
    #   this standard. The body is simply a sequence of characters that
    #   follows the header and is separated from the header by an empty line
    #   (i.e., a line with nothing preceding the CRLF).
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