# frozen_string_literal: true
require "mail/utilities"
require "mail/parser_tools"

begin
  original_verbose, $VERBOSE = $VERBOSE, nil

  module Mail::Parsers
    module ContentTypeParser
      extend Mail::ParserTools

      ContentTypeStruct = Struct.new(:main_type, :sub_type, :parameters, :error)

      class << self
        attr_accessor :_trans_keys
        private :_trans_keys, :_trans_keys=
      end
      self._trans_keys = ::Ragel::Bitmap::Array8.new("\x00\x00!~!~!~\t~\n\n\t !~\t~\t(\n\n\t \x01\xF4\x01\xF4\n\n\t \n\n\t \t~\t~\n\n\t \t~\x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F\t(\n\n\t \t~\x01\xF4\x01\xF4\n\n\t \x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F\t~\t;\t~\t~\t~\t~\t~\x00\x00\x00")

      class << self
        attr_accessor :_key_spans
        private :_key_spans, :_key_spans=
      end
      self._key_spans = ::Ragel::Bitmap::Array8.new("\x00^^^v\x01\x18^v \x01\x18\xF4\xF4\x01\x18\x01\x18vv\x01\x18v\xF5@ @ 0@\x10 \x01\x18v\xF4\xF4\x01\x18\xF5@ @ 0@\x10v3vvvvv\x00")

      class << self
        attr_accessor :_index_offsets
        private :_index_offsets, :_index_offsets=
      end
      self._index_offsets = ::Ragel::Bitmap::Array16.new("\x00\x00\x00\x00\x01\x01\x01\x01\x02\x02\x02\x02\x02\x03\x04\x04\x04\x04\x04\x05\x05\x05\x05\x06\a\a\a\a\b\b\b\b\b\b\b\t\n\v\v\v\f\f\f\f\r\r\r\r\x0E\x0E\x0E\x0F\x0F\x10\x10", "\x00\x00_\xBE\x1D\x94\x96\xAF\x0E\x85\xA6\xA8\xC1\xB6\xAB\xAD\xC6\xC8\xE1X\xCF\xD1\xEAaW\x98\xB9\xFA\eL\x8D\x9E\xBF\xC1\xDAQF;=VL\x8D\xAE\xEF\x10A\x82\x93\n>\xB5,\xA3\x1A\x91")

      class << self
        attr_accessor :_indicies
        private :_indicies, :_indicies=
      end
      self._indicies = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x00\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x02\x02\x02\x02\x02\x02\x01\x01\x02\x02\x02\x02\x02\x03\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x01\x01\x01\x01\x01\x01\x01\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x01\x01\x01\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x02\x01\x04\x04\x04\x04\x04\x04\x04\x01\x01\x04\x04\x04\x04\x04\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x01\x01\x01\x01\x01\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x01\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x05\x01\x01\x01\x06\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x05\a\a\a\a\a\a\a\b\x01\a\a\a\a\a\x01\a\a\a\a\a\a\a\a\a\a\x01\t\x01\x01\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\n\x01\x05\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x05\x01\v\v\v\v\v\v\v\x01\x01\v\v\v\v\v\x01\v\v\v\v\v\v\v\v\v\v\x01\x01\x01\f\x01\x01\x01\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\x01\x01\x01\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\x01\r\x01\x01\x01\x0E\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\r\x0F\x10\x0F\x0F\x0F\x0F\x0F\x11\x01\x0F\x0F\x0F\x0F\x0F\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x01\x01\x0F\x01\x01\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x01\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x12\x01\x01\x01\x13\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x12\x01\x14\x01\x01\x01\x01\x01\x15\x01\x16\x01\x12\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x12\x01\x17\x17\x17\x17\x17\x17\x17\x17\x17\x01\x17\x17\x18\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x19\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x1A\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\e\x1C\x1D\x1D\x1D\x1D\x1D\x1D\x1D\x1D\x1D\x1D\x1D\x1D\x1E\x1D\x1D\x1F   !\x01\"\"\"\"\"\"\"\"\"\x01\"\"#\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"$\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"%\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'(((((((((((()((*+++,\x01-\x01\"\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\"\x01.\x01/\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01/\x010\x01\x01\x011\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x010\a\a\a\a\a\a\a2\x01\a\a\a\a\a\x01\a\a\a\a\a\a\a\a\a\a\x01\t\x01\x01\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x010\x01\x01\x011\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x010\a\a\a\a\a\a\a2\x01\a\a\a\a\a\x01\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\x01\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x013\x010\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x010\x014\x01\x01\x015\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01466666667\x0166666\x016666666666\x01\x01\x01\x01\x01\x01\x0166666666666666666666666666\x01\x01\x01666666666666666666666666666666666\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'(((((((((((()((*+++,\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\x01((((((((((((((((((((((((((((((((((((((((((((((((\x01((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((\x01((((((((((((((((\x018\x01\x01\x019\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x018\x01:\x01\x01\x01\x01\x01;\x01<\x01=\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01=\x01>\x01\x01\x01?\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01>6666666@\x0166666\x016666666666\x01A\x01\x01\x01\x01\x0166666666666666666666666666\x01\x01\x01666666666666666666666666666666666\x01BBBBBBBBB\x01BBCBBBBBBBBBBBBBBBBBBBBBBBBBBDEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBFBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGHIIIIIIIIIIIIJIIKLLLM\x01NNNNNNNNN\x01NNONNNNNNNNNNNNNNNNNNNNNNNNNNPQNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNRNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSTUUUUUUUUUUUUVUUWXXXY\x01Z\x01N\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01N\x01NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSTUUUUUUUUUUUUVUUWXXXY\x01NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN\x01SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS\x01SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS\x01SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS\x01UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU\x01UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU\x01UUUUUUUUUUUUUUUU\x01[\x01\x01\x01\\\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01[]]]]]]]^\x01]]]]]\x01]]]]]]]]]]\x01_\x01\x01\x01\x01\x01]]]]]]]]]]]]]]]]]]]]]]]]]]\x01\x01\x01]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]\x01`\x01\x01\x01a\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01`\x01\x01\x01\x01\x01\x01\x01b\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01c\x01`\x01\x01\x01a\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01`\a\a\a\a\a\a\ab\x01\a\a\a\a\a\x01\a\a\a\a\a\a\a\a\a\a\x01c\x01\x01\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01d\x01\x01\x01e\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01d6666666f\x0166666\x016666666666\x01g\x01\x01\x01\x01\x0166666666666666666666666666\x01\x01\x01666666666666666666666666666666666\x01h\x01\x01\x01i\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01hj\x01jjjjjk\x01jjjjj\x01jjjjjjjjjj\x01c\x01j\x01\x01\x01jjjjjjjjjjjjjjjjjjjjjjjjjj\x01\x01\x01jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj\x01=\x01\x01\x01l\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01=\a\a\a\a\a\a\am\x01\a\a\a\a\a\x01\a\a\a\a\a\a\a\a\a\a\x01\t\x01\x01\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01n\x01\x01\x01o\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01n6666666p\x0166666\x016666666666\x01A\x01\x01\x01\x01\x0166666666666666666666666666\x01\x01\x01666666666666666666666666666666666\x01\x01\x00")

      class << self
        attr_accessor :_trans_targs
        private :_trans_targs, :_trans_targs=
      end
      self._trans_targs = ::Ragel::Bitmap::Array8.new("\x02\x00\x02\x03/\x04\x05\a\"\x12\x06\a\b\t\n3\f\x1F\t\n\f\x1F\v\r\x0E0\x17\x18\x19\x1A\e\x1C\x1D\x1E\r\x0E0\x17\x18\x19\x1A\e\x1C\x1D\x1E\x0F\x111\x13\x14\x16\x15\x13\x14\a\x16\t\n\f\x1F!4\x04\x05\"\x12$%$6'()*+,-.$%$6'()*+,-.&\x04\x05/\"\x121\x102\x121\x102\x124 35 54 5")

      class << self
        attr_accessor :_trans_actions
        private :_trans_actions, :_trans_actions=
      end
      self._trans_actions = ::Ragel::Bitmap::Array8.new("\x01\x00\x00\x02\x03\x00\x00\x04\x05\x00\x00\x00\x06\a\a\a\a\b\x00\x00\x00\x05\x00\t\t\n\t\t\t\t\t\t\t\t\x00\x00\v\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\f\f\r\x0E\f\f\f\x0E\x00\x00\f\f\x0E\f\x0F\x0F\x10\x11\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x00\x00\x05\x12\x00\x00\x00\x00\x00\x00\x00\x00\x00\x13\x13\x00\x14\x13\x15\x15\x16\x15\x17\x17\x18\x17\x15\x15\x00\x19\x00\x05\f\f\x0E")

      class << self
        attr_accessor :_eof_actions
        private :_eof_actions, :_eof_actions=
      end
      self._eof_actions = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x13\x15\x15\x17\x15\x00\f\x00")

      class << self
        attr_accessor :start
      end
      self.start = 1
      class << self
        attr_accessor :first_final
      end
      self.first_final = 47
      class << self
        attr_accessor :error
      end
      self.error = 0

      class << self
        attr_accessor :en_comment_tail
      end
      self.en_comment_tail = 35
      class << self
        attr_accessor :en_main
      end
      self.en_main = 1

      def self.parse(data)
        data = data.dup.force_encoding(Encoding::ASCII_8BIT) if data.respond_to?(:force_encoding)

        return ContentTypeStruct.new("text", "plain", []) if Mail::Utilities.blank?(data)
        content_type = ContentTypeStruct.new(nil, nil, [])

        # Parser state
        main_type_s = sub_type_s = param_attr_s = param_attr = nil
        qstr_s = qstr = param_val_s = nil

        # 5.1 Variables Used by Ragel
        p = 0
        eof = pe = data.length
        stack = []

        begin
          p ||= 0
          pe ||= data.length
          cs = start
          top = 0
        end

        begin
          testEof = false
          _slen, _trans, _keys, _inds, _acts, _nacts = nil
          _goto_level = 0
          _resume = 10
          _eof_trans = 15
          _again = 20
          _test_eof = 30
          _out = 40
          while true
            if _goto_level <= 0
              if p == pe
                _goto_level = _test_eof
                next
              end
              if cs == 0
                _goto_level = _out
                next
              end
            end
            if _goto_level <= _resume
              _keys = cs << 1
              _inds = _index_offsets[cs]
              _slen = _key_spans[cs]
              _wide = data[p].ord
              _trans = if (_slen > 0 &&
                           _trans_keys[_keys] <= _wide &&
                           _wide <= _trans_keys[_keys + 1])
                  _indicies[_inds + _wide - _trans_keys[_keys]]
                else
                  _indicies[_inds + _slen]
                end
              cs = _trans_targs[_trans]
              if _trans_actions[_trans] != 0
                case _trans_actions[_trans]
                when 1
                  begin
                    main_type_s = p
                  end
                when 2
                  begin
                    content_type.main_type = chars(data, main_type_s, p - 1).downcase
                  end
                when 3
                  begin
                    sub_type_s = p
                  end
                when 19
                  begin
                    content_type.sub_type = chars(data, sub_type_s, p - 1).downcase
                  end
                when 4
                  begin
                    param_attr_s = p
                  end
                when 6
                  begin
                    param_attr = chars(data, param_attr_s, p - 1)
                  end
                when 9
                  begin
                    qstr_s = p
                  end
                when 11
                  begin
                    qstr = chars(data, qstr_s, p - 1)
                  end
                when 7
                  begin
                    param_val_s = p
                  end
                when 21
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 12
                  begin
                  end
                when 15
                  begin
                  end
                when 5
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 18
                  begin
                    begin
                      top -= 1
                      cs = stack[top]
                      _goto_level = _again
                      next
                    end
                  end
                when 20
                  begin
                    content_type.sub_type = chars(data, sub_type_s, p - 1).downcase
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 10
                  begin
                    qstr_s = p
                  end
                  begin
                    qstr = chars(data, qstr_s, p - 1)
                  end
                when 8
                  begin
                    param_val_s = p
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 25
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 13
                  begin
                  end
                  begin
                    param_attr_s = p
                  end
                when 23
                  begin
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 14
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 16
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 17
                  begin
                  end
                  begin
                    begin
                      top -= 1
                      cs = stack[top]
                      _goto_level = _again
                      next
                    end
                  end
                when 22
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 24
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                end
              end
            end
            if _goto_level <= _again
              if cs == 0
                _goto_level = _out
                next
              end
              p += 1
              if p != pe
                _goto_level = _resume
                next
              end
            end
            if _goto_level <= _test_eof
              if p == eof
                case _eof_actions[cs]
                when 19
                  begin
                    content_type.sub_type = chars(data, sub_type_s, p - 1).downcase
                  end
                when 21
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 12
                  begin
                  end
                when 23
                  begin
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                end
              end
            end
            if _goto_level <= _out
              break
            end
          end
        end

        if false
          testEof
        end

        if p != eof || cs < 47
          raise Mail::Field::IncompleteParseError.new(Mail::ContentTypeElement, data, p)
        end

        content_type
      end
    end
  end
ensure
  $VERBOSE = original_verbose
end
