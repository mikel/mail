# encoding: utf-8
# 
# 
# 
module Mail
  class ContentDescriptionField < UnstructuredField
    
    FIELD_NAME = 'content-description'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
