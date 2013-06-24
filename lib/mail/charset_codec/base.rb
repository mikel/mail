require 'mail/charset_codec'
module Mail
  module CharsetCodec
    class Base

      def remap_characters(value)
        value
      end

      def set_charset_on(message)
      end

      def preprocess(value)
        value
      end

      def preprocess_body_raw(value)
        value
      end

      def force_regexp_compatibility_on(value)
      end

      def encode(value)
        value
      end

      def encode_address(value)
        value
      end

      def encode_crlf(value)
        value.gsub!("\r", '=0D')
        value.gsub!("\n", '=0A')
        value
      end

      def decode_unstructured_field(value)
        value.blank? ? nil : Encodings.decode_encode(value, :decode)
      end

      def decode_common_address(address_codec, value)
        address_codec.decode(value)
      end

      def encode_common_address(address_codec, value, field_name)
        address_codec.encode(value, field_name)
      end
    end
  end
end
