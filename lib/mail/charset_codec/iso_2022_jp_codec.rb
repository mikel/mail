require 'mail/charset_codec/base'
module Mail
  module CharsetCodec
    class Iso2022JpCodec < Base
      WAVE_DASH = [0x301c].pack("U")
      FULLWIDTH_TILDE = [0xff5e].pack("U")
      MINUS_SIGN = [0x2212].pack("U")
      FULLWIDTH_HYPHEN_MINUS = [0xff0d].pack("U")
      EM_DASH = [0x2014].pack("U")
      HORIZONTAL_BAR = [0x2015].pack("U")
      DOUBLE_VERTICAL_LINE = [0x2016].pack("U")
      PARALLEL_TO = [0x2225].pack("U") 

      REMAP_MATCH = Regexp.union([WAVE_DASH, MINUS_SIGN, EM_DASH, DOUBLE_VERTICAL_LINE])
      REMAP = {
        WAVE_DASH => FULLWIDTH_TILDE,
        MINUS_SIGN => FULLWIDTH_HYPHEN_MINUS,
        EM_DASH => HORIZONTAL_BAR,
        DOUBLE_VERTICAL_LINE => PARALLEL_TO
      }

      def remap_characters(value)
        # Preprocessor.process goes here
        value.gsub(REMAP_MATCH) { |c| REMAP[c] }
      end

      def set_charset_on(message)
        if message && message.charset.nil?
          message.charset = 'iso-2022-jp'
        end
      end

      def preprocess(value)
        RubyVer.preprocess('iso-2022-jp', value)
      end

      def preprocess_body_raw(value)
        RubyVer.preprocess_body_raw('iso-2022-jp', value)
      end

      def force_regexp_compatibility_on(value)
        value.force_encoding('US-ASCII')
      end

      def encode(value)
        if value.kind_of?(Array)
          value.map { |e| encode(e) }
        else
          RubyVer.encode_with_iso_2022_jp(value)
        end
      end

      def encode_address(value)
        if value.kind_of?(Array)
          value.map { |e| encode_address e }
        elsif md = value.match(/ <[\x00-\x7f]*>\z/)
          RubyVer.encode_with_iso_2022_jp(md.pre_match) + md[0]
        else
          value
        end
      end

      def encode_crlf(value)
        if value.respond_to?(:force_encoding)
          value.force_encoding('ascii-8bit')
        end
        super(value)
      end

      def decode_unstructured_field(value)
        value
      end

      def decode_common_address(address_codec, value)
        value
      end
    end
  end
end
