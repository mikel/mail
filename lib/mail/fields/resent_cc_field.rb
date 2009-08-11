# encoding: utf-8
# 
# = Resent-Cc Field
# 
# The Resent-Cc field inherits resent-cc StructuredField and handles the Resent-Cc: header
# field in the email.
# 
# Sending resent_cc to a mail message will instantiate a Mail::Field object that
# has a ResentCcField as it's field type.  This includes all Mail::CommonAddress
# module instance metods.
# 
# Only one Resent-Cc field can appear in a header, though it can have multiple
# addresses and groups of addresses.
# 
# == Examples:
# 
#  mail = Mail.new
#  mail.resent_cc = 'Mikel Lindsaar <mikel@test.lindsaar.net>, ada@test.lindsaar.net'
#  mail.resent_cc    #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentCcField:0x180e1c4
#  mail[:resent_cc]  #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentCcField:0x180e1c4
#  mail['resent-cc'] #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentCcField:0x180e1c4
#  mail['Resent-Cc'] #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentCcField:0x180e1c4
# 
#  mail.resent_cc.to_s  #=> 'Mikel Lindsaar <mikel@test.lindsaar.net>, ada@test.lindsaar.net'
#  mail.resent_cc.addresses #=> ['mikel@test.lindsaar.net', 'ada@test.lindsaar.net']
#  mail.resent_cc.formatted #=> ['Mikel Lindsaar <mikel@test.lindsaar.net>', 'ada@test.lindsaar.net']
# 
module Mail
  class ResentCcField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'resent-cc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
