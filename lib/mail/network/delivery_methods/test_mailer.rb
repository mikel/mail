module Mail
  class TestMailer

    def initialize(values)
      @settings = {}
    end
    
    attr_accessor :settings

    # The Test Mailer provides a mail delivery method that does not hit
    # your network or mail agent, in this way you can send all the emails
    # you want and they will just be appended to Mail.deliveries
    # 
    # See the README under Using Mail with Testing or Spec'ing Libraries
    # for more information.
    def deliver!(mail)
      Mail.deliveries << mail
    end
    
  end
end