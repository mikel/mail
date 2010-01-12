# encoding: utf-8
# 
# 
# 
module Mail
  class MimeVersionField < StructuredField
    
    FIELD_NAME = 'mime-version'
    CAPITALIZED_FIELD = 'Mime-Version'

    def initialize(*args)
      if args.last.blank?
        self.name = CAPITALIZED_FIELD
        self.value = '1.0'
      else
        super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
      end
      self.parse
      self

    end
    
    def parse(val = value)
      unless val.blank?
        @element = Mail::MimeVersionElement.new(val)
      end
    end
    
    def element
      @element ||= Mail::MimeVersionElement.new(value)
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
    
    def encoded
      "#{CAPITALIZED_FIELD}: #{value}\r\n"
    end
    
    def decoded
      value
    end
    
  end
end
