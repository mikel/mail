# encoding: utf-8
# 
# = Blind Carbon Copy Field
# 
# The Bcc field inherits from StructuredField and handles the Bcc: header
# filed in the document.
# 
# Only one Bcc field can appear in a header, though it can have multiple
# addresses and groups of addresses.
# 
# Examples:
# 
#  mail = Mail.new
# 
module Mail
  class BccField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'bcc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
