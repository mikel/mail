# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTransferEncodingField < StructuredField
    
    FIELD_NAME = 'content-transfer-encoding'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last.to_s.downcase))
    end
    
    def tree
      @element ||= ContentTransferEncodingElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= ContentTransferEncodingElement.new(value)
    end
    
    def encoding
      element.encoding
    end
    
  end
end
