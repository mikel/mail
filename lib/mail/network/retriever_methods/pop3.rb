# encoding: utf-8

# The Pop3 retriever allows to get the last, first or all emails from a Pop3 server.
# Each email retrieved (RFC2822) is given as an instance of +Message+.
#
# While being retrieved, emails can be yielded if a block is given.
#
# This module uses the defaults set in Configuration to retrieve POP3 settings.
# 
module Mail
  class POP3
    include Singleton
    
    def initialize
      @user = nil
      @pass = nil
      @tls  = false
    end
    
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
    
    # Get the oldest received email(s)
    #
    # Possible options:
    #   count: number of emails to retrieve. The default value is 1.
    #   order: order of emails returned. Possible values are :asc or :desc. Default value is :asc.
    #
    def POP3.first(options = {}, &block)
      options ||= {}
      options[:what] = :first
      options[:count] ||= 1
      find(options, &block)
    end
    
    # Get the most recent received email(s)
    #
    # Possible options:
    #   count: number of emails to retrieve. The default value is 1.
    #   order: order of emails returned. Possible values are :asc or :desc. Default value is :asc.
    #
    def POP3.last(options = {}, &block)
      options ||= {}
      options[:what] = :last
      options[:count] ||= 1
      find(options, &block)
    end
    
    # Get all emails.
    #
    # Possible options:
    #   order: order of emails returned. Possible values are :asc or :desc. Default value is :asc.
    #
    def POP3.all(options = {}, &block)
      options ||= {}
      options[:count] = :all
      find(options, &block)
    end
    
    # Find emails in a POP3 mailbox. Without any options, the 5 last received emails are returned.
    #
    # Possible options:
    #   what:  last or first emails. The default is :first.
    #   order: order of emails returned. Possible values are :asc or :desc. Default value is :asc.
    #   count: number of emails to retrieve. The default value is 10. A value of 1 returns an
    #          instance of Message, not an array of Message instances.
    #
    def POP3.find(options = {}, &block)
      validate_configuration
      options = validate_options(options)
      
      start do |pop3|
        mails = pop3.mails
        mails.sort! { |m1, m2| m2.number <=> m1.number } if options[:what] == :last
        mails = mails.first(options[:count]) if options[:count].is_a? Integer
        
        if options[:what].to_sym == :last && options[:order].to_sym == :desc ||
           options[:what].to_sym == :first && options[:order].to_sym == :asc ||
          mails.reverse!
        end
        
        if block_given?
          mails.each do |mail|
            yield Mail.new(mail.pop)
          end
        else
          emails = []
          mails.each do |mail|
            emails << Mail.new(mail.pop)
          end
          emails.size == 1 && options[:count] == 1 ? emails.first : emails
        end
        
      end
    end
    
  private
    
    # Ensure that the POP3 configuration is set
    def POP3.validate_configuration
      config = Mail::Configuration.instance
      if config.pop3.host.blank? || config.pop3.port.blank?
        raise ArgumentError.new('Please call +Mail.defaults+ to set the POP3 configuration')
      end
    end
  
    # Set default options
    def POP3.validate_options(options)
      options ||= {}
      options[:count] ||= 10
      options[:order] ||= :asc
      options[:what] ||= :first
      options
    end
  
    # Start a POP3 session and ensures that it will be closed in any case.
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