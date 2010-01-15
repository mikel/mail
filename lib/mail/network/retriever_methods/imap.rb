module Mail
  class IMAP
    
    def initialize(values)
      self.settings = { :address              => "localhost",
                        :port                 => 110,
                        :user_name            => nil,
                        :password             => nil,
                        :authentication       => nil,
                        :enable_ssl           => false }.merge!(values)
    end
    
    def IMAP.get_messages(&block)
      # To be implemented
    end
    
  end
end