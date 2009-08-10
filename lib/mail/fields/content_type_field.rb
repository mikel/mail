# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTypeField < StructuredField
    
    FIELD_NAME = 'content-type'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
