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

  end
end
