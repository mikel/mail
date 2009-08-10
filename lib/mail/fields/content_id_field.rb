# encoding: utf-8
# 
# 
# 
module Mail
  class ContentIdField < StructuredField
    
    FIELD_NAME = 'content-id'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def name
      'Content-ID'
    end
    
  end
end
