# encoding: utf-8
# 
# resent-from     =       "Resent-From:" mailbox-list CRLF
module Mail
  class ResentFromField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'resent-from'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
