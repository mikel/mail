# encoding: utf-8

module Mail
  # The Pop3 retriever allows to get the last, first or all emails from a POP3 server.
  # Each email retrieved (RFC2822) is given as an instance of +Message+.
  #
  # While being retrieved, emails can be yielded if a block is given.
  # 
  # === Example of retrieving Emails from GMail:
  # 
  #   Mail.defaults do
  #     retriever_method :pop3, { :address             => "pop.gmail.com",
  #                               :port                => 995,
  #                               :user_name           => '<username>',
  #                               :password            => '<password>',
  #                               :enable_ssl          => true }
  #   end
  # 
  #   Mail.all    #=> Returns an array of all emails
  #   Mail.first  #=> Returns the first unread email
  #   Mail.last   #=> Returns the first unread email
  # 
  # You can also pass options into Mail.find to locate an email in your pop mailbox
  # with the following options:
  # 
  #   what:  last or first emails. The default is :first.
  #   order: order of emails returned. Possible values are :asc or :desc. Default value is :asc.
  #   count: number of emails to retrieve. The default value is 10. A value of 1 returns an
  #          instance of Message, not an array of Message instances.
  # 
  #   Mail.find(:what => :first, :count => 10, :order => :asc)
  #   #=> Returns the first 10 emails in ascending order
  # 
  class POP3
    require 'net/pop'

    def initialize(values)
      self.settings = { :address              => "localhost",
                        :port                 => 110,
                        :user_name            => nil,
                        :password             => nil,
                        :authentication       => nil,
                        :enable_ssl           => false }.merge!(values)
    end
    
    attr_accessor :settings
    
    # Get the oldest received email(s)
    #
    # Possible options:
    #   count: number of emails to retrieve. The default value is 1.
    #   order: order of emails returned. Possible values are :asc or :desc. Default value is :asc.
    #
    def first(options = {}, &block)
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
    def last(options = {}, &block)
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
    def all(options = {}, &block)
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
    def find(options = {}, &block)
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
    
    # Delete all emails from a POP3 server   
    def delete_all
      start do |pop3|
        unless pop3.mails.empty?
          pop3.delete_all
          pop3.finish
        end
      end
    end
    
  private
  
    # Set default options
    def validate_options(options)
      options ||= {}
      options[:count] ||= 10
      options[:order] ||= :asc
      options[:what]  ||= :first
      options
    end
  
    # Start a POP3 session and ensures that it will be closed in any case.
    def start(config = Mail::Configuration.instance, &block)
      raise ArgumentError.new("Mail::Retrievable#pop3_start takes a block") unless block_given?
    
      pop3 = Net::POP3.new(settings[:address], settings[:port], isapop = false)
      pop3.enable_ssl(verify = OpenSSL::SSL::VERIFY_NONE) if settings[:enable_ssl]
      pop3.start(settings[:user_name], settings[:password])
    
      yield pop3
    ensure
      if defined?(pop3) && pop3 && pop3.started?
        pop3.reset # This clears all "deleted" marks from messages.
        pop3.finish
      end
    end
  
  end
end