module Mail
  class IMAP
    include Singleton
    
    def settings(&block)
      if block_given?
        instance_eval(&block)
      end
      self
    end
    
    def IMAP.get_messages(&block)
      # To be implemented
    end
    
  end
end