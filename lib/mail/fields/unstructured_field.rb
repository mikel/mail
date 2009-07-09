module Mail
  # Provides access to an unstructured header field
  #
  # ===Per RFC 2822:
  #  2.2.1. Unstructured Header Field Bodies
  #  
  #     Some field bodies in this standard are defined simply as
  #     "unstructured" (which is specified below as any US-ASCII characters,
  #     except for CR and LF) with no further restrictions.  These are
  #     referred to as unstructured field bodies.  Semantically, unstructured
  #     field bodies are simply to be treated as a single line of characters
  #     with no further processing (except for header "folding" and
  #     "unfolding" as described in section 2.2.3).
  class UnstructuredField
    
    def initialize(name, value = '')
      self.name = name
      self.value = value
      self
    end
    
    def name=(value)
      @name = value
    end
    
    def name
      @name
    end
    
    def value=(value)
      @value = value
    end
    
    def value
      @value
    end
    
    def to_s
      value.blank? ? '' : "#{name}: #{value}"
    end
    
    def encoded
      to_s.blank? ? nil : do_encode
    end
    
    private
    
    # 2.2.3. Long Header Fields
    # 
    #  Each header field is logically a single line of characters comprising
    #  the field name, the colon, and the field body.  For convenience
    #  however, and to deal with the 998/78 character limitations per line,
    #  the field body portion of a header field can be split into a multiple
    #  line representation; this is called "folding".  The general rule is
    #  that wherever this standard allows for folding white space (not
    #  simply WSP characters), a CRLF may be inserted before any WSP.
    def do_encode
      case
      when to_s.length <= 78
        to_s
      when to_s.length > 78
        @folded_line = []
        @unfolded_line = to_s
        wspp = @unfolded_line =~ /[ \t]/
        fold
        @folded_line.join("\r\n\t")
      end
    end
    
    def fold
      # Get the last whitespace character, OR we'll just choose 
      # 78 if there is no whitespace
      wspp = @unfolded_line.slice(0..78) =~ /[ \t][^ \T]*$/ || 78
      @folded_line << @unfolded_line.slice!(0...wspp)
      if @unfolded_line.length > 78
        fold
      else
        @folded_line << @unfolded_line
      end
    end
    
  end
end
