# encoding: utf-8

# Include this module to make a class "deliverable".
# It uses the defaults set in Configuration to retrieve SMTP settings.
#
# Thanks to Nicolas Fouché for this wrapper
#
module Mail
  module Deliverable

    # Send the message via SMTP.
    # The from and to attributes are optional. If not set, they are retrieve from the Message.
    def deliver!(from = nil, to = nil, rfc2822 = nil)
      config = Mail::Configuration.instance
      if config.smtp.blank? || config.smtp[0].blank?
        raise ArgumentError.new('Please call +Mail.defaults+ to set the SMTP configuration')
      end
      
      # TODO: use the "return-path" field by default instead of the "from" field ? (see ActionMailer)
      from ||= self.from.addresses.first if self.respond_to?(:from) && self.from
      raise ArgumentError.new('An author -from- is required to send a message') if from.blank?
      to ||= self.to.addresses if self.respond_to?(:to) && self.to
      raise ArgumentError.new('At least one recipient -from- is required to send a message') if to.blank?
      rfc2822 ||= self.encoded if self.respond_to?(:encoded)
      raise ArgumentError.new('A encoded content is required to send a message') if rfc2822.blank?
      
      smtp = Net::SMTP.new(config.smtp[0], config.smtp[1] || 25)
      if config.tls?
        if OpenSSL::SSL::VERIFY_NONE.kind_of?(OpenSSL::SSL::SSLContext)
          smtp.enable_tls(OpenSSL::SSL::VERIFY_NONE)
        else
          smtp.enable_tls
        end
      else
        smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto)
      end
      
      smtp.start(helo = 'localhost.localdomain', config.user, config.pass, authentication = :plain) do |smtp|
        smtp.sendmail(rfc2822, from, to)
      end
      
      self
    end
  end

end
