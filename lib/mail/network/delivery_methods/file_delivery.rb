module Mail
  class FileDelivery
    include Singleton
    
    def settings(&block)
      if block_given?
        instance_eval(&block)
      end
      self
    end
    
    def FileDelivery.deliver!(mail)
      # To be implemented
      Mail.deliveries << mail
    end
    
  end
end