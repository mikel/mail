# encoding: utf-8
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
    
    include Mail::CommonField
    include Mail::Utilities
    
    def initialize(*args)
      self.name = args.first
      self.value = args.last
      self
    end
    
    def encoded
      do_encode(self.name)
    end
    
    def decoded
      do_decode
    end

    def default
      decoded
    end
    
    def parse # An unstructured field does not parse
      self
    end

    private
    
    def do_encode(name)
      value.nil? ? '' : "#{wrapped_value}\r\n"
    end
    
    def do_decode
      value.blank? ? nil : Encodings.decode_encode(value, :decode)
    end
    
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
    def wrapped_value # :nodoc:
      case
      when decoded.to_s.ascii_only? && field_length <= 78
        "#{name}: #{value}"
      when field_length <= 40 # Allow for =?ISO-8859-1?B?=...=
        "#{name}: #{encode(value)}"
      else
        @folded_line = []
        @unfolded_line = value.clone
        fold("#{name}: ".length)
        folded = @folded_line.map { |l| l unless l.blank? }.compact.join("\r\n\t")
        "#{name}: #{folded}"
      end
    end

    def fold(prepend = 0) # :nodoc:
      # Get the last whitespace character, OR we'll just choose 
      # 78 if there is no whitespace
      @unfolded_line.ascii_only? ? (limit = 78 - prepend) : (limit = 40 - prepend)
      wspp = @unfolded_line.slice(0..limit) =~ /[ \t][^ \T]*$/ || limit
      wspp = limit if wspp == 0
      @folded_line << encode(@unfolded_line.slice!(0...wspp))
      if @unfolded_line.length > limit
        fold
      else
        @folded_line << encode(@unfolded_line)
      end
    end

    def encode(value)
      if value.ascii_only?
        value
      else
        RUBY_VERSION < '1.9' ? encoding = $KCODE : encoding = @value.encoding
        Encodings.b_value_encode(value, encoding)
      end
    end

  end
end
