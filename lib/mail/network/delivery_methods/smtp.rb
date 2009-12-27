module Mail
  class SMTP
    include Singleton
    
    def initialize
      @user = nil
      @pass = nil
    end
    
    def settings(&block)
      if block_given?
        instance_eval(&block)
      end
      self
    end
    
    # This is the host that you will send your SMTP mails to, defaults to 'localhost'
    def host(value = nil)
      value ? @host = value : @host ||= 'localhost'
    end

    # This is the port that SMTP email get sent to, default is 25
    def port(value = nil)
      value ? @port = value.to_i : @port ||= 25
    end
    
    # The username to use during SMTP authentication
    def user(value = nil)
      value ? @user = value : @user
    end
    
    # Password to use during SMTP authentication
    def pass(value = nil)
      value ? @pass = value : @pass
    end
    
    # The helo domain used at the begining of an SMTP conversation,
    # default is 'localhost.localdomain'
    def helo(value = nil)
      value ? @helo = value : @helo ||= 'localhost.localdomain'
    end
    
    # Turn on TLS
    def enable_tls
      @tls = true
    end
    
    # Turn off TLS
    def disable_tls
      @tls = false
    end
    
    # TLS Enabled?  Default is false
    def tls?
      @tls || false
    end
    
    # Send the message via SMTP.
    # The from and to attributes are optional. If not set, they are retrieve from the Message.
    def SMTP.deliver!(mail)
      
      config = Mail.defaults

      # TODO: use the "return-path" field by default instead of the "from" field ? (see ActionMailer)
      from = mail.from.addresses.first if mail.respond_to?(:from) && mail.from
      raise ArgumentError.new('An author -from- is required to send a message') if from.blank?
      to ||= mail.destinations if mail.respond_to?(:destinations) && mail.destinations
      raise ArgumentError.new('At least one recipient -to, cc, bcc- is required to send a message') if to.blank?
      msg_str ||= mail.encoded if mail.respond_to?(:encoded)
      raise ArgumentError.new('A encoded content is required to send a message') if msg_str.blank?
      
      smtp = Net::SMTP.new(config.smtp.host, config.smtp.port)
      if config.smtp.tls?
        if OpenSSL::SSL::VERIFY_NONE.kind_of?(OpenSSL::SSL::SSLContext)
          smtp.enable_tls(OpenSSL::SSL::VERIFY_NONE)
        else
          smtp.enable_tls
        end
      else
        smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto)
      end
      
      smtp.start(config.smtp.helo, config.smtp.user, config.smtp.pass, authentication = :plain) do |smtp|
        smtp.sendmail(msg_str, from, to)
      end
      
      self
    end
    
    
  end
end