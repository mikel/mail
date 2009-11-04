# encoding: utf-8
# 
# resent-date     =       "Resent-Date:" date-time CRLF
module Mail
  class ResentDateField < StructuredField
    
    include Mail::CommonDate
    
    FIELD_NAME = 'resent-date'
    CAPITALIZED_FIELD = 'Resent-Date'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def encoded
      do_encode(CAPITALIZED_FIELD)
    end
    
    def decoded
      do_decode
    end
    
  end
end
