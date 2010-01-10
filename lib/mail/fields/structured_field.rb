# encoding: utf-8
module Mail
  # Provides access to a structured header field
  #
  # ===Per RFC 2822:
  #  2.2.2. Structured Header Field Bodies
  #  
  #     Some field bodies in this standard have specific syntactical
  #     structure more restrictive than the unstructured field bodies
  #     described above. These are referred to as "structured" field bodies.
  #     Structured field bodies are sequences of specific lexical tokens as
  #     described in sections 3 and 4 of this standard.  Many of these tokens
  #     are allowed (according to their syntax) to be introduced or end with
  #     comments (as described in section 3.2.3) as well as the space (SP,
  #     ASCII value 32) and horizontal tab (HTAB, ASCII value 9) characters
  #     (together known as the white space characters, WSP), and those WSP
  #     characters are subject to header "folding" and "unfolding" as
  #     described in section 2.2.3.  Semantic analysis of structured field
  #     bodies is given along with their syntax.
  class StructuredField
    
    include Mail::CommonField
    include Mail::Utilities
    
    def initialize(*args)
      self.name = args.first
      self.value = args.last
      self
    end
    
    def default
      decoded
    end

  end
end
