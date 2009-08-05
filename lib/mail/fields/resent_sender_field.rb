# 
# resent-sender   =       "Resent-Sender:" mailbox CRLF
module Mail
  class ResentSenderField < StructuredField
    
    include Mail::AddressField
    
    FIELD_NAME = 'resent-sender'

    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end

    def addresses
      [address]
    end

    def address
      result = tree.addresses.first
    end
    
  end
end
