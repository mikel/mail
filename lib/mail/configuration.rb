# encoding: utf-8
#
# Thanks to Nicolas Fouché for this wrapper
#
require 'singleton'

module Mail
  
  # The Configuration class is a Singleton used to hold the default
  # configuration for all class wide configurations of Mail.
  # 
  # This includes things like running in Test mode, the POP3, IMAP,
  # SMTP, Sendmail and File delivery method information et al.
  # 
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
    def smtp(*args, &block)
      if args.size > 0
        host_array = [args[0], (args[1].to_i > 0 ? args[1] : 25)]
      end
      set_settings(Mail::SMTP, host_array, &block)
    end

    # Allows you to define the delivery method for mail, defaults to SMTP
    # 
    # This can either be a symbol (:smtp, :sendmail, :file, :test) or you can pass
    # in your own delivery class, in which case this will be set.
    def delivery_method(value = nil)
      value ? @delivery_method = lookup_delivery_method(value) : @delivery_method ||= Mail::SMTP
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
    #    pop3 '127.0.0.1', 995 do
    #      enable_tls
    #    end
    #  end
    def pop3(*args, &block)
      if args.size > 0
        host_array = [args[0], (args[1].to_i > 0 ? args[1] : 110)]
      end
      set_settings(Mail::POP3, host_array, &block)
    end

    def sendmail(sendmail_path = nil)
      delivery_method :sendmail
      set_settings(Mail::Sendmail) do
        path sendmail_path
      end
    end
    
    # Allows you to define the retriever method for mail, defaults to POP3
    # 
    # This can either be a symbol (:pop3, :imap) or you can pass
    # in your own retriever class, in which case this will be set.
    def retriever_method(value = nil)
      value ? @retriever_method = lookup_retriever_method(value) : @retriever_method ||= Mail::POP3
    end

    def param_encode_language(value = nil)
      value ? @encode_language = value : @encode_language ||= 'en'
    end
    
    private
    
    def set_settings(klass, host_array = nil, &block)
      if host_array
        klass.instance.settings do
          host host_array[0]
          port host_array[1]
        end
      end
      klass.instance.settings(&block)
    end

     def lookup_delivery_method(method)
       case method
       when :smtp || nil
         Mail::SMTP
       when :sendmail
         Mail::Sendmail
       when :file
         Mail::FileDelivery
       when :test
         Mail::TestMailer
       else
         method
       end
     end

     def lookup_retriever_method(method)
       case method
       when :pop3 || nil
         Mail::POP3
 #      when :imap
 #        Mail::IMAP
       else
         method
       end
     end
 
  end

end