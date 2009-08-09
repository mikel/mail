# encoding: utf-8
# 
# resent-msg-id   =       "Resent-Message-ID:" msg-id CRLF
module Mail
  class ResentMessageIdField < StructuredField
    
    include CommonMessageId
    
    FIELD_NAME = 'resent-message-id'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def name
      'Resent-Message-ID'
    end
    
  end
end
