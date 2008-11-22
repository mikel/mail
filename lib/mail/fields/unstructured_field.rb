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
      @name = name.to_s
      @value = value.to_s
    end
    
    def valid?
      true unless value.blank?
    end
    
    def name
      @name
    end
    
    def value
      @value
    end
    
    def value=(value)
      @value = value
    end
    
    def to_s
      value.blank? ? '' : "#{name}: #{value}"
    end
    
    def encoded
      to_s.blank? ? nil : to_s
    end
    
  end
end
