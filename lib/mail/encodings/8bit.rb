# encoding: utf-8
# frozen_string_literal: true
require 'mail/encodings/binary'

module Mail
  module Encodings
    class EightBit < Binary
      NAME = '8bit'
      PRIORITY = 4
      Encodings.register(NAME, self)

      # Per RFC 2821 4.5.3.1, SMTP lines may not be longer than 1000 octets including the <CRLF>.
      #
      # Transfer encoding is negotiated several times per message, so where
      # String#byteindex exists this walks the newlines instead of splitting the
      # body into an array of lines. Invalid encodings and custom input record
      # separators retain String#lines semantics.
      if String.method_defined?(:byteindex)
        def self.compatible_input?(str)
          if $/ != "\n" || !str.encoding.ascii_compatible? || !str.valid_encoding?
            return !str.lines.find { |line| line.bytesize > 998 }
          end

          start = 0
          while (newline = str.byteindex("\n", start))
            return false if newline - start + 1 > 998
            start = newline + 1
          end
          str.bytesize - start <= 998
        end
      else
        def self.compatible_input?(str)
          !str.lines.find { |line| line.bytesize > 998 }
        end
      end
    end
  end
end
