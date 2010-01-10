module Mail
  class SMTP
    include Singleton
    
    def initialize
      @user = nil
      @pass = nil
      @tls  = false
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

      # Set the envelope from to be either the return-path, the sender or the first from address
      envelope_from = mail.return_path || mail.sender || mail.from_addrs.first
      raise ArgumentError.new('An sender (Return-Path, Sender or From) required to send a message') if envelope_from.blank?
      destinations ||= mail.destinations if mail.respond_to?(:destinations) && mail.destinations
      raise ArgumentError.new('At least one recipient (To, Cc or Bcc) is required to send a message') if destinations.blank?
      message ||= mail.encoded if mail.respond_to?(:encoded)
      raise ArgumentError.new('A encoded content is required to send a message') if message.blank?
      
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
        smtp.sendmail(message, envelope_from, destinations)
      end
      
      self
    end
    
    
  end
end