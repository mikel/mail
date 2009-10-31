# encoding: utf-8
# 
# 
# 
module Mail
  class ContentLocationField < StructuredField
    
    FIELD_NAME = 'content-location'

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

  end
end
