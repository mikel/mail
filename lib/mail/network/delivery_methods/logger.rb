require 'mail/check_delivery_params'
require 'logger'

module Mail
  class Logger
    include Mail::CheckDeliveryParams

    def initialize(values)
      self.settings = values
    end

    attr_accessor :settings

    def deliver!(mail)
      check_delivery_params(mail)
      logger.send(severity, mail.encoded)
    end

    def logger
      settings[:logger] ||= default_logger
    end

    def severity
      settings[:severity] ||= :info
    end

    private

    def default_logger
      ::Logger.new($stdout)
    end

  end
end
