# encoding: utf-8
# frozen_string_literal: true
#
# Thanks to Nicolas Fouché for this wrapper
#
require 'singleton'

require 'yaml'

module Mail
  # The Configuration class is a Singleton used to hold the default
  # configuration for all Mail objects.
  #
  # Each new mail object gets a copy of these values at initialization
  # which can be overwritten on a per mail object basis.
  class Configuration
    include Singleton

    def initialize
      @delivery_method  = nil
      @retriever_method = nil
      super
    end

    def delivery_method(method = nil, settings = {})
      return @delivery_method if @delivery_method && method.nil?
      @delivery_method = lookup_delivery_method(method).new(settings)
    end
    
    def load!(path, environment = nil)
      environment = environment || env_name
      settings = symbolize_keys(YAML.load_file(path))[environment.to_sym]
      delivery_method = settings[:delivery][:method].to_sym
      retriever_method = settings[:retriever][:method].to_sym
      authentication = settings[:delivery][:authentication]
      if authentication != nil
        authentication = authentication.to_sym
      end
      delivery_method delivery_method, settings[:delivery]
      retriever_method retriever_method, settings[:retriever]
    end

    def lookup_delivery_method(method)
      case method.is_a?(String) ? method.to_sym : method
      when nil
        Mail::SMTP
      when :smtp
        Mail::SMTP
      when :sendmail
        Mail::Sendmail
      when :exim
        Mail::Exim
      when :file
        Mail::FileDelivery
      when :smtp_connection
        Mail::SMTPConnection
      when :test
        Mail::TestMailer
      else
        method
      end
    end

    def retriever_method(method = nil, settings = {})
      return @retriever_method if @retriever_method && method.nil?
      @retriever_method = lookup_retriever_method(method).new(settings)
    end

    def lookup_retriever_method(method)
      case method
      when nil
        Mail::POP3
      when :pop3
        Mail::POP3
      when :imap
        Mail::IMAP
      when :test
        Mail::TestRetriever
      else
        method
      end
    end

    def param_encode_language(value = nil)
      value ? @encode_language = value : @encode_language ||= 'en'
    end

    private

    def symbolize_keys(hash)
      s2s = lambda do |h|
        if h.is_a? Hash
          Hash[h.map{ |k, v| [k.to_sym, s2s[v]] }]
        else
          h
        end
      end
      s2s[hash]
    end

    def env_name
      return Rails.env if defined?(Rails)
      return Sinatra::Base.environment.to_s if defined?(Sinatra)
      ENV['RACK_ENV'] || ENV['MAIL_ENV']
    end

  end

end
