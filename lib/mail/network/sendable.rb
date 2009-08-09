# encoding: utf-8

# Include this module to make a class "sendable".
# It uses the defaults set in Configuration to retrieve SMTP settings.
module Mail
  module Sendable

    # Send the message via SMTP.
    # The from and to attributes are optional. If not set, they are retrieve from the Message.
    def deliver(from = nil, to = nil, rfc8222 = nil)
      # TODO: use the "return-path" field by default instead of the "from" field ? (see ActionMailer)
      from ||= self.from.addresses.first if self.respond_to?(:from) && self.from
      raise ArgumentError.new('An author -from- is required to send a message') if from.blank?
      to ||= self.to.addresses if self.respond_to?(:to) && self.to
      raise ArgumentError.new('At least one recipient -from- is required to send a message') if to.blank?
      rfc8222 ||= self.encoded if self.respond_to?(:encoded)
      raise ArgumentError.new('A encoded content is required to send a message') if rfc8222.blank?
      
      config = Mail::Configuration.instance
      raise ArgumentError.new('Please call +Mail.defaults+ to set the SMTP configuration') unless config.smtp
      
      smtp = Net::SMTP.new(config.smtp[0], config.smtp[1])
      if config.tls?
        smtp.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      else
        smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto)
      end
      
      smtp.start(helo = 'localhost.localdomain', config.user, config.pass, authentication = :plain) do |smtp|
        smtp.sendmail(rfc8222, from, to)
      end
      
      self
    end
  end

end
