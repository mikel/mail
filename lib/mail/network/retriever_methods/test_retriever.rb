# encoding: utf-8

module Mail

  class TestRetriever
    cattr_accessor :emails

    def initialize(values)
      @@emails = []
    end

    def find(options = {}, &block)
      emails = @@emails
      case count = options[:count]
        when :all then emails
        when 1 then emails.first
        when Fixnum then emails[0, count]
        else
          raise 'Invalid count option value'
      end
    end

    def all(options = {}, &block)
      options ||= {}
      options[:count] = :all
      find(options, &block)
    end

  end

end
