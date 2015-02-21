require 'mail/check_delivery_params'

module Mail
  class LoggerDelivery
    include Mail::CheckDeliveryParams

    attr_reader :logger, :severity, :settings

    def initialize(settings)
      @settings = settings
      @logger   = settings.fetch(:logger) { default_logger }
      @severity = settings.fetch(:severity, :info)
    end

    def deliver!(mail)
      Mail::CheckDeliveryParams.check(mail)
      logger.log(severity) { mail.encoded }
    end

    private
      def default_logger
        require 'logger'
        ::Logger.new($stdout)
      end
  end
end
