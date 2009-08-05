# encoding: utf-8
# 
# sender          =       "Sender:" mailbox CRLF
# 
module Mail
  class SenderField < StructuredField
    
    include Mail::AddressField
    
    FIELD_NAME = 'sender'

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
