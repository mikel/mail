module Mail
  module Encodings
    class QuotedPrintable
    
      # Decode the string from Quoted-Printable
      def self.decode(str)
        str.unpack("M*").first
      end

      # Convert the given text into quoted printable format, with an instruction
      # that the text be eventually interpreted in the given charset.
      def self.encode(text, charset)
        text = text.gsub( /[^a-z ]/i ) { quoted_printable_encode($&) }.
                    gsub( / /, "_" )
        "=?#{charset}?Q?#{text}?="
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