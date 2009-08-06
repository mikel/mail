module Mail

  #  3.6. Field definitions
  #   ...
  # 
  #   It is important to note that the header fields are not guaranteed to
  #   be in a particular order.  They may appear in any order, and they
  #   have been known to be reordered occasionally when transported over
  #   the Internet.  However, for the purposes of this standard, header
  #   fields SHOULD NOT be reordered when a message is transported or
  #   transformed.  More importantly, the trace header fields and resent
  #   header fields MUST NOT be reordered, and SHOULD be kept in blocks
  #   prepended to the message.  See sections 3.6.6 and 3.6.7 for more
  #   information.
  #  ...
  #   fields = *(trace
  #              *(resent-date /
  #                resent-from /
  #                resent-sender /
  #                resent-to /
  #                resent-cc /
  #                resent-bcc /
  #                resent-msg-id))
  #  
  #  3.6.7. Trace fields
  #  
  #     The trace fields are a group of header fields consisting of an
  #     optional "Return-Path:" field, and one or more "Received:" fields.
  #     The "Return-Path:" header field contains a pair of angle brackets
  #     that enclose an optional addr-spec.  The "Received:" field contains a
  #     (possibly empty) list of name/value pairs followed by a semicolon and
  #     a date-time specification.  The first item of the name/value pair is
  #     defined by item-name, and the second item is either an addr-spec, an
  #     atom, a domain, or a msg-id.  Further restrictions may be applied to
  #     the syntax of the trace fields by standards that provide for their
  #     use, such as [RFC2821].
  #  
  #   trace           =   [return]
  #                       1*received
  #                       
  #   return          =   "Return-Path:" path CRLF
  #                       
  #   path            =   ([CFWS] "<" ([CFWS] / addr-spec) ">" [CFWS]) /
  #                       obs-path
  #                       
  #   received        =   "Received:" name-val-list ";" date-time CRLF
  #                       
  #   name-val-list   =   [CFWS] [name-val-pair *(CFWS name-val-pair)]
  #                       
  #   name-val-pair   =   item-name CFWS item-value
  #                       
  #   item-name       =   ALPHA *(["-"] (ALPHA / DIGIT))
  #                       
  #   item-value      =   1*angle-addr / addr-spec /
  #                       atom / domain / msg-id
  #  
  #     A full discussion of the Internet mail use of trace fields is
  #     contained in [RFC2821].  For the purposes of this standard, the trace
  #     fields are strictly informational, and any formal interpretation of
  #     them is outside of the scope of this document.
  class TraceField
    def initialize(args)
    
    end
    
    
    
  end
end