# encoding: utf-8
# 
# 
# 
module Mail
  class ContentLocationField < StructuredField
    
    FIELD_NAME = 'content-location'
    CAPITALIZED_FIELD = 'Content-Location'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def tree
      @element ||= Mail::ContentLocationElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= Mail::ContentLocationElement.new(value)
    end

    def location
      element.location
    end

    # TODO: Fix this up
    def encoded
      "#{CAPITALIZED_FIELD}: #{value}\r\n"
    end
    
    def decoded
      value
    end

  end
end
