# encoding: utf-8
# 
# = Resent-Bcc Field
# 
# The Resent-Bcc field inherits resent-bcc StructuredField and handles the 
# Resent-Bcc: header field in the email.
# 
# Sending resent_bcc to a mail message will instantiate a Mail::Field object that
# has a ResentBccField as it's field type.  This includes all Mail::CommonAddress
# module instance metods.
# 
# Only one Resent-Bcc field can appear in a header, though it can have multiple
# addresses and groups of addresses.
# 
# == Examples:
# 
#  mail = Mail.new
#  mail.resent_bcc = 'Mikel Lindsaar <mikel@test.lindsaar.net>, ada@test.lindsaar.net'
#  mail.resent_bcc    #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentBccField:0x180e1c4
#  mail[:resent_bcc]  #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentBccField:0x180e1c4
#  mail['resent-bcc'] #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentBccField:0x180e1c4
#  mail['Resent-Bcc'] #=> '#<Mail::Field:0x180e5e8 @field=#<Mail::ResentBccField:0x180e1c4
# 
#  mail.resent_bcc.to_s  #=> 'Mikel Lindsaar <mikel@test.lindsaar.net>, ada@test.lindsaar.net'
#  mail.resent_bcc.addresses #=> ['mikel@test.lindsaar.net', 'ada@test.lindsaar.net']
#  mail.resent_bcc.formatted #=> ['Mikel Lindsaar <mikel@test.lindsaar.net>', 'ada@test.lindsaar.net']
# 
module Mail
  class ResentBccField < StructuredField
    
    include Mail::CommonAddress
    
    FIELD_NAME = 'resent-bcc'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
  end
end
