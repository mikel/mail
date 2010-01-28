# encoding: utf-8
# 
# 
# 
module Mail
  class ContentDescriptionField < UnstructuredField
    
    FIELD_NAME = 'content-description'
    CAPITALIZED_FIELD = 'Content-Description'
    
    def initialize(*args)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
      self.parse
      self

    end
    
  end
end
