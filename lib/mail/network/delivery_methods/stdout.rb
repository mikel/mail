require 'mail/check_delivery_params'
require 'logger'

module Mail
  class Stdout
    include Mail::CheckDeliveryParams

    def initialize(values)
      self.settings = default_settings.merge!(values)
    end

    attr_accessor :settings

    def deliver!(mail)
      check_delivery_params(mail)
      settings[:logger].send(settings[:severity], mail.encoded)
    end

    private

    def default_settings
      { :logger => ::Logger.new(STDOUT), :severity => :info }
    end

  end
end
