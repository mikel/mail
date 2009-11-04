# encoding: utf-8
# 
# resent-msg-id   =       "Resent-Message-ID:" msg-id CRLF
module Mail
  class ResentMessageIdField < StructuredField
    
    include CommonMessageId
    
    FIELD_NAME = 'resent-message-id'
    CAPITALIZED_FIELD = 'Resent-Message-ID'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def name
      'Resent-Message-ID'
    end
    
    def encoded
      do_encode(CAPITALIZED_FIELD)
    end
    
    def decoded
      do_decode
    end
    
  end
end
