# frozen_string_literal: true
require 'mail/smtp_envelope'
require 'mail/utilities'

module Mail
  # == Sending Email with SMTP
  # 
  # Mail allows you to send emails using SMTP.  This is done by wrapping Net::SMTP in
  # an easy to use manner.
  # 
  # === Sending via SMTP server on Localhost
  # 
  # Sending locally (to a postfix or sendmail server running on localhost) requires
  # no special setup.  Just to Mail.deliver &block or message.deliver! and it will
  # be sent in this method.
  # 
  # === Sending via MobileMe
  # 
  #   Mail.defaults do
  #     delivery_method :smtp, { :address              => "smtp.me.com",
  #                              :port                 => 587,
  #                              :domain               => 'your.host.name',
  #                              :user_name            => '<username>',
  #                              :password             => '<password>',
  #                              :authentication       => 'plain',
  #                              :enable_starttls_auto => true  }
  #   end
  # 
  # === Sending via GMail
  # 
  #   Mail.defaults do
  #     delivery_method :smtp, { :address              => "smtp.gmail.com",
  #                              :port                 => 587,
  #                              :domain               => 'your.host.name',
  #                              :user_name            => '<username>',
  #                              :password             => '<password>',
  #                              :authentication       => 'plain',
  #                              :enable_starttls_auto => true  }
  #
  #     # ...or using the url-attribute (note the URL-encoded userinfo):
  #     delivery_method :smtp,
  #        { :url => 'smtps://user%40gmail.com:app-password@smtp.gmail.com' }
  #   end
  #
  # === Sending via Fastmail
  #
  #   Mail.defaults do
  #     delivery_method :smtp,
  #       { :url => 'smtps://user%40fastmail.fm:app-pw@smtp.fastmail.com' }
  #   end
  #
  #
  # === Certificate verification
  #
  # When using TLS, some mail servers provide certificates that are self-signed
  # or whose names do not exactly match the hostname given in the address.
  # OpenSSL will reject these by default. The best remedy is to use the correct
  # hostname or update the certificate authorities trusted by your ruby. If
  # that isn't possible, you can control this behavior with
  # an :openssl_verify_mode setting. Its value may be either an OpenSSL
  # verify mode constant (OpenSSL::SSL::VERIFY_NONE, OpenSSL::SSL::VERIFY_PEER),
  # or a string containing the name of an OpenSSL verify mode (none, peer).
  #
  # === Others 
  # 
  # Feel free to send me other examples that were tricky
  # 
  # === Delivering the email
  # 
  # Once you have the settings right, sending the email is done by:
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
  class SMTP
    class UrlResolver

      DEFAULTS = {
        "smtp" => {
          :address              => 'localhost',
          :port                 => 25,
          :domain               => 'localhost.localdomain',
          :enable_starttls_auto => true
        },
        "smtps" => {
          :address              => 'localhost',
          :port                 => 465,
          :domain               => 'localhost.localdomain',
          :enable_starttls_auto => false,
          :tls                  => true
        }
      }

      def initialize(url)
        @uri = url.is_a?(URI) ? url : uri_parser.parse(url)
        unless DEFAULTS.has_key?(@uri.scheme)
          raise ArgumentError, "#{url} is not a valid SMTP-url. Required format: smtp(s)://host?domain=sender.org"
        end
        @query = uri.query
      end

      def to_hash
        config = raw_config
        config.map { |key, value| config[key] = uri_parser.unescape(value) if value.is_a? String }
        config
      end

      private
        attr_reader :uri

        def raw_config
          scheme_defaults.merge(query_hash).merge({
              :address              => uri.host,
              :port                 => uri.port,
              :user_name            => uri.user,
              :password             => uri.password
          }.delete_if {|_key, value| Utilities.blank?(value) })
        end

        def uri_parser
          Utilities.uri_parser
        end

        def query_hash
          @query_hash = begin
            result = Hash[(@query || "").split("&").map { |pair| k,v = pair.split("="); [k.to_sym, v] }]
            result[:open_timeout] &&= result[:open_timeout].to_i
            result[:read_timeout] &&= result[:read_timeout].to_i
            result
          end
        end

        def scheme_defaults
          DEFAULTS[uri.scheme]
        end
    end

    attr_accessor :settings

    DEFAULTS = {
      :address              => 'localhost',
      :port                 => 25,
      :domain               => 'localhost.localdomain',
      :user_name            => nil,
      :password             => nil,
      :authentication       => nil,
      :enable_starttls      => nil,
      :enable_starttls_auto => true,
      :openssl_verify_mode  => nil,
      :ssl                  => nil,
      :tls                  => nil,
      :open_timeout         => nil,
      :read_timeout         => nil
    }

    def initialize(config)
      settings = DEFAULTS

      if config.has_key?(:url)
        settings = settings.merge(UrlResolver.new(config.delete(:url)).to_hash)
      end
      self.settings = settings.merge(config)
    end

    def deliver!(mail)
      response = start_smtp_session do |smtp|
        Mail::SMTPConnection.new(:connection => smtp, :return_response => true).deliver!(mail)
      end

      settings[:return_response] ? response : self
    end

    private
      def start_smtp_session(&block)
        build_smtp_session.start(settings[:domain], settings[:user_name], settings[:password], settings[:authentication], &block)
      end

      def build_smtp_session
        Net::SMTP.new(settings[:address], settings[:port]).tap do |smtp|
          if settings[:tls] || settings[:ssl]
            if smtp.respond_to?(:enable_tls)
              smtp.enable_tls(ssl_context)
            end
          elsif settings[:enable_starttls]
            if smtp.respond_to?(:enable_starttls)
              smtp.enable_starttls(ssl_context)
            end
          elsif settings[:enable_starttls_auto]
            if smtp.respond_to?(:enable_starttls_auto)
              smtp.enable_starttls_auto(ssl_context)
            end
          end

          smtp.open_timeout = settings[:open_timeout] if settings[:open_timeout]
          smtp.read_timeout = settings[:read_timeout] if settings[:read_timeout]
        end
      end

      # Allow SSL context to be configured via settings, for Ruby >= 1.9
      # Just returns openssl verify mode for Ruby 1.8.x
      def ssl_context
        openssl_verify_mode = settings[:openssl_verify_mode]

        if openssl_verify_mode.kind_of?(String)
          openssl_verify_mode = OpenSSL::SSL.const_get("VERIFY_#{openssl_verify_mode.upcase}")
        end

        context = Net::SMTP.default_ssl_context
        context.verify_mode = openssl_verify_mode if openssl_verify_mode
        context.ca_path = settings[:ca_path] if settings[:ca_path]
        context.ca_file = settings[:ca_file] if settings[:ca_file]
        context
      end
  end
end
