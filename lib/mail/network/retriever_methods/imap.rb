module Mail
  class IMAP
    require 'net/imap'
    
    def initialize(values)
      self.settings = { :address              => "localhost",
                        :port                 => 110,
                        :user_name            => nil,
                        :password             => nil,
                        :authentication       => nil,
                        :enable_ssl           => false }.merge!(values)
    end

    attr_accessor :settings

    def first(options={}, &block)
      options ||= {}
      options[:what] = :first
      options[:count] ||= 1
      find(options, &block)
    end

    def last(options={}, &block)
      options ||= {}
      options[:what] = :last
      options[:count] ||= 1
      find(options, &block)
    end

    def all(options={}, &block)
      options ||= {}
      options[:count] = :all
      find(options, &block)
    end
    

    def find(options={}, &block)
      options = validate_options(options)

      start do |imap|
        imap.select(options[:mailbox])

        message_ids = imap.search(['ALL'])
        message_ids.reverse! if options[:what].to_sym == :last
        message_ids = message_ids.first(options[:count]) if options[:count].is_a?(Integer)
        message_ids.reverse! if (options[:what].to_sym == :last && options[:order].to_sym == :asc) ||
                                (options[:what].to_sym != :last && options[:order].to_sym == :desc)

        if block_given?
          message_ids.each do |message_id|
            fetchdata = imap.fetch(message_id, ['RFC822'])[0]

            yield Mail.new(fetchdata.attr['RFC822'])
          end
        else
          emails = []
          message_ids.each do |message_id|
            fetchdata = imap.fetch(message_id, ['RFC822'])[0]

            emails << Mail.new(fetchdata.attr['RFC822'])
          end
          emails.size == 1 && options[:count] == 1 ? emails.first : emails
        end
      end
    end


    def delete_all(mailbox='INBOX')
      mailbox ||= 'INBOX'

      start do |imap|
        imap.select(mailbox)
        imap.search(['ALL']).each do |message_id|
          imap.store(message_id, "+FLAGS", [Net::IMAP::DELETED])
        end
        imap.expunge
      end
    end

    private

      def validate_options(options)
        options ||= {}
        options[:mailbox] ||= 'INBOX'
        options[:count]   ||= 10
        options[:order]   ||= :asc
        options[:what]    ||= :first
        options
      end

      def start(config=Mail::Configuration.instance, &block)
        raise ArgumentError.new("Mail::Retrievable#imap_start takes a block") unless block_given?

        imap = Net::IMAP.new(settings[:address], settings[:port], settings[:enable_ssl], nil, false)
        imap.login(settings[:user_name], settings[:password])

        yield imap
      ensure
        if defined?(imap) && imap && !imap.disconnected?
          imap.disconnect
        end
      end

  end
end
