# encoding: utf-8
# 
#    The "Cc:" field (where the "Cc" means "Carbon Copy" in the sense of
#    making a copy on a typewriter using carbon paper) contains the
#    addresses of others who are to receive the message, though the
#    content of the message may not be directed at them.
module Mail
  class CcField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'cc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
