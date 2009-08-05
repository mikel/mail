# encoding: utf-8
# 
# comments        =       "Comments:" unstructured CRLF
module Mail
  class CommentsField < UnstructuredField
    
    FIELD_NAME = 'comments'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
