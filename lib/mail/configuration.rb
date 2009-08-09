require 'singleton'

module Mail
  
  # The Configuration class is a Singleton used to hold the default
  # configuration for all SMTP, POP3 and IMAP operations handled by Mail.
  # See Mail.defaults for more information.
  class Configuration
    include Singleton
    
    # Creates a new Mail::Configuration object through .defaults
    def defaults(&block)
      if block_given?
        instance_eval(&block)
      end
      self
    end
    
    def smtp(*args)
      if args.size > 0
        @smtp = [args[0], args[1] || 25]
      end
      @smtp
    end
    
    def pop3(*args)
      if args.size > 0
        @pop3 = [args[0], args[1] || 110]
      end
      @pop3
    end
    
    def user(value = nil)
      value ? @user = value : @user
    end
    
    def pass(value = nil)
      value ? @pass = value : @pass
    end
    
    def enable_tls
      @tls = true
    end
    
    def disable_tls
      @tls = false
    end
    
    def tls?
      @tls || false
    end
    
  end

end