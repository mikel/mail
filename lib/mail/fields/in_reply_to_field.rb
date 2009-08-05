# encoding: utf-8
# 
#    The "In-Reply-To:" field will contain the contents of the "Message-
#    ID:" field of the message to which this one is a reply (the "parent
#    message").  If there is more than one parent message, then the "In-
#    Reply-To:" field will contain the contents of all of the parents'
#    "Message-ID:" fields.  If there is no "Message-ID:" field in any of
#    the parent messages, then the new message will have no "In-Reply-To:"
#    field.
module Mail
  class InReplyToField < StructuredField
    
  end
end
