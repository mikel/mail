# encoding: utf-8
# 3.6.4. Identification fields
#  
#   Though optional, every message SHOULD have a "Message-ID:" field.
#   Furthermore, reply messages SHOULD have "In-Reply-To:" and
#   "References:" fields as appropriate, as described below.
#   
#   The "Message-ID:" field contains a single unique message identifier.
#   The "References:" and "In-Reply-To:" field each contain one or more
#   unique message identifiers, optionally separated by CFWS.
#   
#   The message identifier (msg-id) is similar in syntax to an angle-addr
#   construct without the internal CFWS.
#  
#  message-id      =       "Message-ID:" msg-id CRLF
#  
#  in-reply-to     =       "In-Reply-To:" 1*msg-id CRLF
#  
#  references      =       "References:" 1*msg-id CRLF
#  
#  msg-id          =       [CFWS] "<" id-left "@" id-right ">" [CFWS]
#  
#  id-left         =       dot-atom-text / no-fold-quote / obs-id-left
#  
#  id-right        =       dot-atom-text / no-fold-literal / obs-id-right
#  
#  no-fold-quote   =       DQUOTE *(qtext / quoted-pair) DQUOTE
#  
#  no-fold-literal =       "[" *(dtext / quoted-pair) "]"
#  
#    The "Message-ID:" field provides a unique message identifier that
#    refers to a particular version of a particular message.  The
#    uniqueness of the message identifier is guaranteed by the host that
#    generates it (see below).  This message identifier is intended to be
#    machine readable and not necessarily meaningful to humans.  A message
#    identifier pertains to exactly one instantiation of a particular
#    message; subsequent revisions to the message each receive new message
#    identifiers.
#     
#    Note: There are many instances when messages are "changed", but those
#    changes do not constitute a new instantiation of that message, and
#    therefore the message would not get a new message identifier.  For
#    example, when messages are introduced into the transport system, they
#    are often prepended with additional header fields such as trace
#    fields (described in section 3.6.7) and resent fields (described in
#    section 3.6.6).  The addition of such header fields does not change
#    the identity of the message and therefore the original "Message-ID:"
#    field is retained.  In all cases, it is the meaning that the sender
#    of the message wishes to convey (i.e., whether this is the same
#    message or a different message) that determines whether or not the
#    "Message-ID:" field changes, not any particular syntactic difference
#    that appears (or does not appear) in the message.
module Mail
  class MessageIdField < StructuredField
    
    include Mail::CommonMessageId
    
    FIELD_NAME = 'message-id'
    
    def initialize(*args)
      @uniq = 1
      if args.last.blank?
        self.name = FIELD_NAME
        self.value = generate_message_id
        self
      else
        super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
      end
    end
    
    def name
      'Message-ID'
    end
    
    private
    
    def generate_message_id
      fqdn ||= ::Socket.gethostname
      "<#{random_tag}@#{fqdn}.mail>"
    end
    
    def random_tag
      @uniq += 1
      t = Time.now
      sprintf('%x%x_%x%x%d%x',
              t.to_i, t.tv_usec,
              $$, Thread.current.object_id, @uniq, rand(255))
    end
    
  end
end
