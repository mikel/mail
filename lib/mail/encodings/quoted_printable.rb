# encoding: utf-8
require 'mail/encodings/7bit'

module Mail
  module Encodings
    class QuotedPrintable < SevenBit
      NAME='quoted-printable'
   
      PRIORITY = 2

      def self.can_encode?(str)
        EightBit.can_encode? str
      end

      # Decode the string from Quoted-Printable
      def self.decode(str)
        str.unpack("M*").first
      end

      def self.encode(str)
        l = []
        str.each_line{|line| l << qp_encode_line(line)}
        l.join("\r\n")
      end

      def self.cost(str)
        # These bytes probably do not need encoding
        c = str.count("\x9\xA\xD\x20-\x3C\x3E-\x7E")
        # Everything else turns into =XX where XX is a 
        # two digit hex number (taking 3 bytes)
        total = (str.bytesize - c)*3 + c
        total.to_f/str.bytesize
      end
        
      private
      def self.qp_encode_line(str)
        str.chomp.gsub( /[^a-z ]/i ) { quoted_printable_encode($&) }
      end

      # Convert the given character to quoted printable format, taking into
      # account multi-byte characters (if executing with $KCODE="u", for instance)
      def self.quoted_printable_encode(character)
        result = ""
        character.each_byte { |b| result << "=%02X" % b }
        result
      end

      Encodings.register(NAME, self)
    end
  end
end
