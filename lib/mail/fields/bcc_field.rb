# encoding: utf-8
# 
#    The "Bcc:" field (where the "Bcc" means "Blind Carbon Copy") contains
#    addresses of recipients of the message whose addresses are not to be
#    revealed to other recipients of the message.  There are three ways in
#    which the "Bcc:" field is used.  In the first case, when a message
#    containing a "Bcc:" field is prepared to be sent, the "Bcc:" line is
#    removed even though all of the recipients (including those specified
#    in the "Bcc:" field) are sent a copy of the message.  In the second
#    case, recipients specified in the "To:" and "Cc:" lines each are sent
#    a copy of the message with the "Bcc:" line removed as above, but the
#    recipients on the "Bcc:" line get a separate copy of the message
#    containing a "Bcc:" line.  (When there are multiple recipient
#    addresses in the "Bcc:" field, some implementations actually send a
#    separate copy of the message to each recipient with a "Bcc:"
#    containing only the address of that particular recipient.) Finally,
#    since a "Bcc:" field may contain no addresses, a "Bcc:" field can be
#    sent without any addresses indicating to the recipients that blind
#    copies were sent to someone.  Which method to use with "Bcc:" fields
#    is implementation dependent, but refer to the "Security
#    Considerations" section of this document for a discussion of each.
module Mail
  class BccField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'bcc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
