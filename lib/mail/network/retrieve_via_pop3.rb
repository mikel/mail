# encoding: utf-8

# Include this module to retrieve emails via POP3. Each email retrieved is given to a new instance of the "includer".
# This module uses the defaults set in Configuration to retrieve POP3 settings.
module Mail
  module RetrieveViaPop3
    
    module ClassMethods
    
      # Get all emails via POP3.
      # TODO :limit option
      # TODO :order option
      def pop3_get_all_mail(&block)
        config = Mail::Configuration.instance
        if config.pop3.blank? || config.pop3[0].blank?
          raise ArgumentError.new('Please call +Mail.defaults+ to set the POP3 configuration')
        end
        
        pop3 = Net::POP3.new(config.pop3[0], config.pop3[1] || 110, isapop = false)
        
        pop3.enable_ssl(verify = OpenSSL::SSL::VERIFY_NONE) if config.tls?
        
        pop3.start(config.user, config.pass)
        
        if block_given?
          pop3.each_mail do |pop_mail|
            yield self.new(pop_mail.pop)
          end
        else
          emails = []
          pop3.each_mail do |pop_mail|
            emails << self.new(pop_mail.pop)
          end
          emails
        end
        
      ensure
        if defined?(pop3) && pop3 && pop3.started?
          pop3.reset # This clears all "deleted" marks from messages.
          pop3.finish
        end
      end
      
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
  
  end
  
end
