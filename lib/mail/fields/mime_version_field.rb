# encoding: utf-8
# 
# 
# 
module Mail
  class MimeVersionField < StructuredField
    
    FIELD_NAME = 'mime-version'

    def initialize(*args)
      if args.last.blank?
        self.name = FIELD_NAME
        self.value = '1.0'
        self
      else
        super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
      end
    end
    
    def tree
      @element ||= MimeVersionElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= MimeVersionElement.new(value)
    end
    
    def version
      "#{element.major}.#{element.minor}"
    end

    def major
      element.major.to_i
    end

    def minor
      element.minor.to_i
    end
    
  end
end
