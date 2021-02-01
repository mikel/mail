# frozen_string_literal: true
module Mail
  module Encodings
    class UnixToUnix < TransferEncoding
      NAME = "x-uuencode"

      def self.decode(str)
        ::Mail::Utilities.unpack1( str.sub(/\Abegin \d+ [^\n]*\n/, ''), 'u' )
      end

      def self.encode(str)
        [str].pack("u")
      end

      Encodings.register(NAME, self)
      Encodings.register("uuencode", self)
      Encodings.register("x-uue", self)
    end
  end
end
