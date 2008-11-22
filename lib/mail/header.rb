module Mail
  
  # Provides access to a header object.
  # 
  # ===Per RFC2822
  # 
  #  2.2. Header Fields
  # 
  #   Header fields are lines composed of a field name, followed by a colon
  #   (":"), followed by a field body, and terminated by CRLF.  A field
  #   name MUST be composed of printable US-ASCII characters (i.e.,
  #   characters that have values between 33 and 126, inclusive), except
  #   colon.  A field body may be composed of any US-ASCII characters,
  #   except for CR and LF.  However, a field body may contain CRLF when
  #   used in header "folding" and  "unfolding" as described in section
  #   2.2.3.  All field bodies MUST conform to the syntax described in
  #   sections 3 and 4 of this standard.
  class Header
    require 'fields/field'
    require 'utilities'
    include Utilities
    
    def initialize(header_text = nil)
      self.raw_source = header_text
      split_header if header_text
    end
    
    def raw_source
      @raw_source
    end
    
    def raw_source=(val)
      @raw_source = val
    end
    
    def fields
      @fields
    end
    
    def fields=(raw_fields)
      @fields = raw_fields.map { |field| Field.new(field) }
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
    #  simply WSP characters), a CRLF may be inserted before any WSP.  For
    #  example, the header field:
    #  
    #          Subject: This is a test
    #  
    #  can be represented as:
    #  
    #          Subject: This
    #           is a test
    #  
    #  Note: Though structured field bodies are defined in such a way that
    #  folding can take place between many of the lexical tokens (and even
    #  within some of the lexical tokens), folding SHOULD be limited to
    #  placing the CRLF at higher-level syntactic breaks.  For instance, if
    #  a field body is defined as comma-separated values, it is recommended
    #  that folding occur after the comma separating the structured items in
    #  preference to other places where the field could be folded, even if
    #  it is allowed elsewhere.
    def fold(string)
      string
    end
    
    # 2.2.3. Long Header Fields
    # 
    #  The process of moving from this folded multiple-line representation
    #  of a header field to its single line representation is called
    #  "unfolding". Unfolding is accomplished by simply removing any CRLF
    #  that is immediately followed by WSP.  Each header field should be
    #  treated in its unfolded form for further syntactic and semantic
    #  evaluation.
    def unfold(string)
      string.gsub(/\n([\t\s]+)/, '\1')
    end
    
    def unfolded_header
      @unfolded_header ||= unfold(raw_source.to_lf)
    end
    
    def split_header
      self.fields = unfolded_header.split("\n")
    end
    
  end
end