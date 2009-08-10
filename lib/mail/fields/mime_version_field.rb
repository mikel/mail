# encoding: utf-8
# 
# 
# 
module Mail
  class MimeVersionField < StructuredField
    
    FIELD_NAME = 'mime-version'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
