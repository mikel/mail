module Mail

  module CheckDeliveryParams

    def self.included(klass)
      klass.class_eval do

        def check_params(mail)
          envelope_from = mail.return_path || mail.sender || mail.from_addrs.first
          if envelope_from.blank?
            raise ArgumentError.new('A sender (Return-Path, Sender or From) required to send a message')
          end

          destinations ||= mail.destinations if mail.respond_to?(:destinations) && mail.destinations
          if destinations.blank?
            raise ArgumentError.new('At least one recipient (To, Cc or Bcc) is required to send a message')
          end

          message ||= mail.encoded if mail.respond_to?(:encoded)
          if message.blank?
            raise ArgumentError.new('A encoded content is required to send a message')
          end

          [envelope_from, destinations, message]
        end

      end
    end
  end
end
