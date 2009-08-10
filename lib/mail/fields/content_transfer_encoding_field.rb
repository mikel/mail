# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTransferEncodingField < StructuredField
    
    FIELD_NAME = 'content-transfer-encoding'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
