# encoding: utf-8
# 
# subject         =       "Subject:" unstructured CRLF
module Mail
  class SubjectField < UnstructuredField
    
    FIELD_NAME = 'subject'
    CAPITALIZED_FIELD = "Subject"
    
    def initialize(*args)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
