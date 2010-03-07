# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTransferEncodingField < StructuredField
    
    FIELD_NAME = 'content-transfer-encoding'
    CAPITALIZED_FIELD = 'Content-Transfer-Encoding'
    
    def initialize(value = nil, charset = 'utf-8')
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, value.to_s.downcase), charset)
    end
    
    def parse(val = value)
      unless val.blank?
        @element = Mail::ContentTransferEncodingElement.new(val)
        @tree = @element.tree
      end
    end
    
    def tree
      @element ||= Mail::ContentTransferEncodingElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= Mail::ContentTransferEncodingElement.new(value)
    end
    
    def encoding
      element.encoding
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
