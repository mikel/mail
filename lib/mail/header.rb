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
    
    # Creates a new header object.
    # 
    # Accepts raw text or nothing.  If given raw text will attempt to parse
    # it and split it into the various fields, instantiating each field as
    # it goes.
    # 
    # If it finds a field that should be a structured field (such as content
    # type), but it fails to parse it, it will simply make it an unstructured
    # field and leave it along.  This will mean that the data is preserved but
    # no automatic processing of that field will happen.  If you find one of
    # these cases, please make a patch and send it in, or at the lease, send
    # me the example so we can fix it.
    def initialize(header_text = nil)
      self.raw_source = header_text
      split_header if header_text
    end
    
    # The preserved raw source of the header as you passed it in, untouched
    # for your Regexing glory.
    def raw_source
      @raw_source
    end
    
    # Returns an array of all the fields in the header in order that they
    # were read in.
    def fields
      @fields ||= []
    end
    
    #  3.6. Field definitions
    #  
    #   It is important to note that the header fields are not guaranteed to
    #   be in a particular order.  They may appear in any order, and they
    #   have been known to be reordered occasionally when transported over
    #   the Internet.  However, for the purposes of this standard, header
    #   fields SHOULD NOT be reordered when a message is transported or
    #   transformed.  More importantly, the trace header fields and resent
    #   header fields MUST NOT be reordered, and SHOULD be kept in blocks
    #   prepended to the message.  See sections 3.6.6 and 3.6.7 for more
    #   information.
    # 
    # Populates the fields container with Field objects in the order it
    # receives them in.
    #
    # Acceps an array of field string values, for example:
    # 
    #  h = Header.new
    #  h.fields = ['From: mikel@me.com', 'To: bob@you.com']
    def fields=(unfolded_fields)
      @fields = unfolded_fields.map { |field| Field.new(field) }
    end
    
    #  3.6. Field definitions
    #  
    #   The following table indicates limits on the number of times each
    #   field may occur in a message header as well as any special
    #   limitations on the use of those fields.  An asterisk next to a value
    #   in the minimum or maximum column indicates that a special restriction
    #   appears in the Notes column.
    #
    #   <snip table from 3.6>
    #
    # As per RFC, many fields can appear more than once, we will return a string
    # of the value if there is only one header, or if there is more than one 
    # matching header, will return an array of values in order that they appear
    # in the header ordered from top to bottom.
    # 
    # Example:
    # 
    #  h = Header.new
    #  h.fields = ['To: mikel@me.com', 'X-Mail-SPAM: 15', 'X-Mail-SPAM: 20']
    #  h['To']          #=> 'mikel@me.com'
    #  h['X-Mail-SPAM'] #=> ['15', '20']
    def [](name)
      field = fields.select { |f| f.name == name }
      case
      when field.length > 1
        field.map { |f| f.value }
      when !field.blank?
        field.first.value
      else
        nil
      end
    end
    
    # Sets the FIRST matching field in the header to passed value, or deletes
    # the FIRST field matched from the header if passed nil
    # 
    # Example:
    # 
    #  h = Header.new
    #  h.fields = ['To: mikel@me.com', 'X-Mail-SPAM: 15', 'X-Mail-SPAM: 20']
    #  h['To'] = 'bob@you.com'
    #  h['To']    #=> 'bob@you.com'
    #  h['X-Mail-SPAM'] = '10000'
    #  h['X-Mail-SPAM']    #=> ['1000', '20']
    #  h['X-Mail-SPAM'] = nil
    #  h['X-Mail-SPAM']    #=> ['1000']
    def []=(name, value)
      selected = fields.select { |f| f.name == name }
      case
      when !selected.blank? && value == nil # User wants to delete the field
        fields.delete_if { |f| selected.include?(f) }
      when !selected.blank?                 # User wants to change the field
        selected.first.value = value
      else                                  # User wants to create the field
        self.fields << Field.new("#{name}: #{value}")
      end
    end
    
    private

    def raw_source=(val)
      @raw_source = val
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
    
    # Returns the header with all the folds removed and all line breaks
    # converted to \n only.
    def unfolded_header
      @unfolded_header ||= unfold(raw_source.to_lf)
    end
    
    # Splits an unfolded and line break cleaned header into individual field
    # strings.
    def split_header
      self.fields = unfolded_header.split("\n")
    end
    
  end
end