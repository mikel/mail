# encoding: utf-8
module Mail
  module Encodings
    class QuotedPrintable
    
      # Decode the string from Quoted-Printable
      def self.decode(str)
        str.unpack("M*").first
      end

      def self.encode(str)
        str.gsub( /[^a-z ]/i ) { quoted_printable_encode($&) }
      end

      private

      # Convert the given character to quoted printable format, taking into
      # account multi-byte characters (if executing with $KCODE="u", for instance)
      def self.quoted_printable_encode(character)
        result = ""
        character.each_byte { |b| result << "=%02X" % b }
        result
      end
    end
  end
end