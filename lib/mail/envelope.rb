# encoding: utf-8
# 
# From RFC4155 The application/mbox Media Type
#
#   o Each message in the mbox database MUST be immediately preceded
#     by a single separator line, which MUST conform to the following
#     syntax:
#
#        The exact character sequence of "From";
#
#        a single Space character (0x20);
#
#        the email address of the message sender (as obtained from the
#        message envelope or other authoritative source), conformant
#        with the "addr-spec" syntax from RFC 2822;
#
#        a single Space character;
#
#        a timestamp indicating the UTC date and time when the message
#        was originally received, conformant with the syntax of the
#        traditional UNIX 'ctime' output sans timezone (note that the
#        use of UTC precludes the need for a timezone indicator);
#
#        an end-of-line marker.
#
module Mail
  class Envelope < StructuredField
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def tree
      @element ||= Mail::EnvelopeFromElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= Mail::EnvelopeFromElement.new(value)
    end
    
    def date
      ::DateTime.parse("#{element.date_time}")
    end

    def from
      element.address
    end
    
  end
end
