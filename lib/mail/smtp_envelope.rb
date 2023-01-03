# frozen_string_literal: true

module Mail
  class SmtpEnvelope #:nodoc:
    # Reasonable cap on address length to avoid SMTP line length
    # overflow on old SMTP servers.
    MAX_ADDRESS_BYTESIZE = 2000

    attr_reader :from, :to, :message

    def initialize(mail, smtputf8_supported: false)
      # Net::SMTP::Address was added in net-smtp 0.3.1 (included in Ruby 3.1).
      @smtputf8_supported = smtputf8_supported && defined?(Net::SMTP::Address)
      self.to = mail.smtp_envelope_to
      self.from = mail.smtp_envelope_from
      self.message = mail.encoded
    end

    def from=(addr)
      if Utilities.blank? addr
        raise ArgumentError, "SMTP From address may not be blank: #{addr.inspect}"
      end

      addr = validate_addr 'From', addr
      addr = Net::SMTP::Address.new(addr, 'SMTPUTF8') if @smtputf8

      @from = addr
    end

    def to=(addr)
      if Utilities.blank?(addr)
        raise ArgumentError, "SMTP To address may not be blank: #{addr.inspect}"
      end

      @to = Array(addr).map do |addr|
        validate_addr 'To', addr
      end
    end

    def message=(message)
      if Utilities.blank?(message)
        raise ArgumentError, 'SMTP message may not be blank'
      end

      @message = message
    end


    private
      def validate_addr(addr_name, addr)
        if /[\r\n]/.match?(addr)
          raise ArgumentError, "SMTP #{addr_name} address may not contain CR or LF line breaks: #{addr.inspect}"
        end

        if !addr.ascii_only?
          if @smtputf8_supported
            # The SMTP server supports the SMTPUTF8 extension, so we can legally pass
            # non-ASCII addresses, if we specify the SMTPUTF8 parameter for MAIL FROM.
            @smtputf8 = true
          elsif Encodings.idna_supported?
            # The SMTP server does not announce support for the SMTPUTF8 extension, so do the
            # IDNa encoding of the domain part client-side.
            addr = Address.new(addr).address_idna
          end

          # If we cannot IDNa-encode the domain part, of if the local part contains
          # non-ASCII characters, there is no standards-complaint way to send the
          # mail via a server without SMTPUTF8 support. Our best chance is to just
          # pass the UTF8-encoded address to the server.
        end

        if addr.to_s.bytesize > MAX_ADDRESS_BYTESIZE
          raise ArgumentError, "SMTP #{addr_name} address may not exceed #{MAX_ADDRESS_BYTESIZE} bytes: #{addr.inspect}"
        end

        addr
      end
  end
end
