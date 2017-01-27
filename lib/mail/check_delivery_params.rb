# frozen_string_literal: true
module Mail
  module CheckDeliveryParams
    def check_delivery_params(mail)
      if Utilities.blank?(mail.smtp_envelope_from)
        raise ArgumentError.new('An SMTP From address is required to send a message. Set the message smtp_envelope_from, return_path, sender, or from address.')
      end

      if Utilities.blank?(mail.smtp_envelope_to)
        raise ArgumentError.new('An SMTP To address is required to send a message. Set the message smtp_envelope_to, to, cc, or bcc address.')
      end

      message = mail.encoded if mail.respond_to?(:encoded)
      if Utilities.blank?(message)
        raise ArgumentError.new('An encoded message is required to send an email')
      end

      [mail.smtp_envelope_from, mail.smtp_envelope_to, message]
    end
  end
end
