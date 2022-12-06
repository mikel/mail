# frozen_string_literal: true
require 'mail/smtp_envelope'

module Mail
  # == Sending Email with SMTP
  #
  # Mail allows you to send emails using an open SMTP connection.  This is done by
  # passing a created Net::SMTP object.  This way we can get better performance to
  # our local mail server by reducing the number of connections at any one time.
  #
  # === Sending via SMTP server on Localhost
  #
  # To send mail open a connection with Net::Smtp using any options you like
  # === Delivering the email
  #
  # Once you have the settings right, sending the email is done by:
  #
  #   smtp_conn = Net::SMTP.start(settings[:address], settings[:port])
  #   Mail.defaults do
  #     delivery_method :smtp_connection, { :connection => smtp_conn }
  #   end
  #
  #   Mail.deliver do
  #     to 'mikel@test.lindsaar.net'
  #     from 'ada@test.lindsaar.net'
  #     subject 'testing sendmail'
  #     body 'testing sendmail'
  #   end
  #
  # Or by calling deliver on a Mail message
  #
  #   mail = Mail.new do
  #     to 'mikel@test.lindsaar.net'
  #     from 'ada@test.lindsaar.net'
  #     subject 'testing sendmail'
  #     body 'testing sendmail'
  #   end
  #
  #   mail.deliver!
  class SMTPConnection
    attr_accessor :smtp, :settings

    def initialize(values)
      raise ArgumentError.new('A Net::SMTP object is required for this delivery method') if values[:connection].nil?
      self.smtp = values[:connection]
      self.settings = values
    end

    # Send the message via SMTP.
    # The from and to attributes are optional. If not set, they are retrieve from the Message.
    def deliver!(mail)
      # Net::SMTP#cabable? was added in net-smtp 0.3.1 (included in Ruby 3.1).
      smtputf8 = smtp.respond_to?(:capable?) && smtp.capable?('SMTPUTF8')
      envelope = Mail::SmtpEnvelope.new(mail, smtputf8_supported: smtputf8)
      response = smtp.sendmail(envelope.message, envelope.from, envelope.to)
      settings[:return_response] ? response : self
    end
  end
end
