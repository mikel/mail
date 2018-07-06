# encoding: utf-8
# frozen_string_literal: true
require 'mail/encodings/7bit'

module Mail
  module Encodings
    class QuotedPrintable < SevenBit
      NAME='quoted-printable'

      PRIORITY = 2

      def self.can_encode?(enc)
        EightBit.can_encode? enc
      end

      # Decode the string from Quoted-Printable.
      def self.decode(str)
        str.unpack("M").first
      end

      def self.encode(str)
        if RUBY_VERSION < '1.9'
          [str].pack("M").gsub(/(=0D=?\n)/) do |match|
            case match
            when "=0D\n"
              "=0D=0A=\r\n"
            when "=0D=\n"
              "=0D=\r\n"
            end
          end.gsub(/([^=\r])\n/, "\\1=0A=\r\n").gsub(/^\n/, "=0A=\r\n")
        else
          [str].pack("M").gsub(/(=0D=?\n|(?<!=)\n)/) do |match|
            case match
            when "=0D\n"
              "=0D=0A=\r\n"
            when "=0D=\n"
              "=0D=\r\n"
            when "\n"
              "=0A=\r\n"
            end
          end
        end
      end

      def self.cost(str)
        # These bytes probably do not need encoding
        c = str.count("\x9\xA\xD\x20-\x3C\x3E-\x7E")
        # Everything else turns into =XX where XX is a
        # two digit hex number (taking 3 bytes)
        total = (str.bytesize - c)*3 + c
        total.to_f/str.bytesize
      end

      # QP inserts newlines automatically and cannot violate the SMTP spec.
      def self.compatible_input?(str)
        true
      end

      private

      Encodings.register(NAME, self)
    end
  end
end
