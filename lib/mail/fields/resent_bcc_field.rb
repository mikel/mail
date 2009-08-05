# encoding: utf-8
# 
# resent-bcc      =       "Resent-Bcc:" (address-list / [CFWS]) CRLF
module Mail
  class ResentBccField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'resent-bcc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
