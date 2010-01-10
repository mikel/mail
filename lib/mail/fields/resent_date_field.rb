# encoding: utf-8
# 
# resent-date     =       "Resent-Date:" date-time CRLF
module Mail
  class ResentDateField < StructuredField
    
    include Mail::CommonDate
    
    FIELD_NAME = 'resent-date'
    CAPITALIZED_FIELD = 'Resent-Date'
    
    def initialize(*args)
      if args.last.blank?
        self.name = CAPITALIZED_FIELD
        self.value = Time.now.strftime('%a, %d %b %Y %H:%M:%S %z')
        self
      else
        value = strip_field(FIELD_NAME, args.last)
        value = ::DateTime.parse(value.to_s).strftime('%a, %d %b %Y %H:%M:%S %z')
        super(CAPITALIZED_FIELD, value)
      end
    end
    
    def encoded
      do_encode(CAPITALIZED_FIELD)
    end
    
    def decoded
      do_decode
    end
    
  end
end
