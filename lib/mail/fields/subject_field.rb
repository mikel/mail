# encoding: utf-8
# 
# subject         =       "Subject:" unstructured CRLF
module Mail
  class SubjectField < UnstructuredField
    
    FIELD_NAME = 'subject'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
