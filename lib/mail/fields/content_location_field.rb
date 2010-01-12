# encoding: utf-8
# 
# 
# 
module Mail
  class ContentLocationField < StructuredField
    
    FIELD_NAME = 'content-location'
    CAPITALIZED_FIELD = 'Content-Location'
    
    def initialize(*args)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
      self.parse
      self

    end
    
    def parse(val = value)
      unless val.blank?
        @element = Mail::ContentLocationElement.new(val)
      end
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
