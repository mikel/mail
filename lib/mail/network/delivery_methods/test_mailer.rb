module Mail
  class TestMailer
    include Singleton
    
    def TestMailer.deliver!(mail)
      Mail.deliveries << mail
    end
    
  end
end