# encoding: utf-8
# frozen_string_literal: true
require 'mail/encodings/binary'

module Mail
  module Encodings
    class EightBit < Binary
      NAME = '8bit'
      PRIORITY = 4
      Encodings.register(NAME, self)

      # 8bit, like 7bit, is a textual transfer encoding and must use CRLF line
      # endings on the wire per RFC 5322 2.3. Binary data keeps the identity
      # encoding inherited from Binary.
      def self.encode(str)
        ::Mail::Utilities.binary_unsafe_to_crlf str
      end

      # Per RFC 2821 4.5.3.1, SMTP lines may not be longer than 1000 octets including the <CRLF>.
      def self.compatible_input?(str)
        !str.lines.find { |line| line.bytesize > 998 }
      end
    end
  end
end
