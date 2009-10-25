# encoding: utf-8
#
# Thanks to Nicolas Fouché for this wrapper
#
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
    
    # Allows you to specify the SMTP Server by passing the hostname
    # or IP Address as a String with an optional port number as a
    # string or integer.
    # 
    # Defaults to 127.0.0.1 and port 25.
    # 
    # Example:
    # 
    #  Mail.defaults.do
    #    smtp '127.0.0.1'
    #  end
    # 
    #  Mail.defaults do
    #    smtp '127.0.0.1', 25
    #  end
    def smtp(*args)
      if args.size > 0
        @smtp = [args[0], (args[1].to_i > 0 ? args[1] : 25)]
      end
      @smtp
    end
    
    # Allows you to specify the POP3 Server by passing the hostname
    # or IP Address as a String with an optional port number as a
    # string or integer.
    # 
    # Defaults to 127.0.0.1 and port 110.
    # 
    # Example:
    # 
    #  Mail.defaults.do
    #    pop3 '127.0.0.1'
    #  end
    # 
    #  Mail.defaults do
    #    pop3 '127.0.0.1', 110
    #  end
    def pop3(*args)
      if args.size > 0
        @pop3 = [args[0], (args[1].to_i > 0 ? args[1] : 110)]
      end
      @pop3
    end
    
    # Pass in the username to use for POP3 or IMAP access
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