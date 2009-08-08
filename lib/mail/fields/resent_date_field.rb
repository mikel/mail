# encoding: utf-8
# 
# resent-date     =       "Resent-Date:" date-time CRLF
module Mail
  class ResentDateField < StructuredField
    
    include Mail::CommonDate
    
    FIELD_NAME = 'resent-date'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
