module Mail
  class POP3
    include Singleton
    
    require 'net/pop'
    
    def settings(&block)
      if block_given?
        instance_eval(&block)
      end
      self
    end
    
    # This is the host that you will send your POP3 mails to, defaults to 'localhost'
    def host(value = nil)
      value ? @host = value : @host ||= 'localhost'
    end

    # This is the port that POP3 email get sent to, default is 110
    def port(value = nil)
      value ? @port = value.to_i : @port ||= 110
    end
    
    # The username to use during POP3 authentication
    def user(value = nil)
      value ? @user = value : @user
    end
    
    # Password to use during POP3 authentication
    def pass(value = nil)
      value ? @pass = value : @pass
    end
    
    # Turn on TLS
    def enable_tls
      @tls = true
    end
    
    # Turn on TLS
    def disable_tls
      @tls = false
    end
    
    # TLS Enabled?  Default is false
    def tls?
      @tls || false
    end
    
    # Get all emails via POP3.
    # TODO :limit option
    # TODO :order option
    def POP3.get_messages(&block)
      config = Mail.defaults
      if config.pop3.host.blank? || config.pop3.port.blank?
        raise ArgumentError.new('Please call +Mail.defaults+ to set the POP3 configuration')
      end
      
      start do |pop3|
        if block_given?
          pop3.each_mail do |pop_mail|
            yield Mail.new(pop_mail.pop)
          end
        else
          emails = []
          pop3.each_mail do |pop_mail|
            emails << Mail.new(pop_mail.pop)
          end
          emails
        end
      end
      
    end
    
    private
    
    def POP3.start(config = Mail::Configuration.instance, &block)
      raise ArgumentError.new("Mail::Retrievable#pop3_start takes a block") unless block_given?
      
      pop3 = Net::POP3.new(config.pop3.host, config.pop3.port, isapop = false)
      pop3.enable_ssl(verify = OpenSSL::SSL::VERIFY_NONE) if config.pop3.tls?
      pop3.start(config.pop3.user, config.pop3.pass)
      
      yield pop3
    ensure
      if defined?(pop3) && pop3 && pop3.started?
        pop3.reset # This clears all "deleted" marks from messages.
        pop3.finish
      end
    end
  
  end
end