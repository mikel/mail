
# frozen_string_literal: true
require "mail/utilities"
require "mail/parser_tools"

begin
  original_verbose, $VERBOSE = $VERBOSE, nil

  module Mail::Parsers
    module ContentDispositionParser
      extend Mail::ParserTools

      ContentDispositionStruct = Struct.new(:disposition_type, :parameters, :error)

      class << self
        attr_accessor :_trans_keys
        private :_trans_keys, :_trans_keys=
      end
      self._trans_keys = ::Ragel::Bitmap::Array8.new("\x00\x00!~\t~\n\n\t !~\t~\t(\n\n\t \x01\xF4\x01\xF4\n\n\t \n\n\t \x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F\t(\n\n\t \t~\x01\xF4\x01\xF4\n\n\t \x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F!~\t;\t;\t~\t;\t;\x00\x00\x00")

      class << self
        attr_accessor :_key_spans
        private :_key_spans, :_key_spans=
      end
      self._key_spans = ::Ragel::Bitmap::Array8.new("\x00^v\x01\x18^v \x01\x18\xF4\xF4\x01\x18\x01\x18\xF5@ @ 0@\x10 \x01\x18v\xF4\xF4\x01\x18\xF5@ @ 0@\x10^33v33\x00")

      class << self
        attr_accessor :_index_offsets
        private :_index_offsets, :_index_offsets=
      end
      self._index_offsets = ::Ragel::Bitmap::Array16.new("\x00\x00\x00\x00\x00\x00\x01\x01\x01\x01\x02\x02\x03\x03\x04\x04\x04\x05\x05\x05\x05\x05\x06\x06\x06\x06\x06\x06\a\b\b\b\t\n\n\n\n\n\v\v\v\v\v\f\f\f\f", "\x00\x00_\xD6\xD8\xF1P\xC7\xE8\xEA\x03\xF8\xED\xEF\b\n#\x19Z{\xBC\xDD\x0EO`\x81\x83\x9C\x13\b\xFD\xFF\x18\x0EOp\xB1\xD2\x03DU\xB4\xE8\x1C\x93\xC7\xFB")

      class << self
        attr_accessor :_indicies
        private :_indicies, :_indicies=
      end
      self._indicies = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x00\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x01\x01\x01\x03\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x02\x04\x04\x04\x04\x04\x04\x04\x05\x01\x04\x04\x04\x04\x04\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x01\x01\x01\x01\x01\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x01\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x06\x01\x02\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x02\x01\a\a\a\a\a\a\a\x01\x01\a\a\a\a\a\x01\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\b\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\x01\x01\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\a\x01\t\x01\x01\x01\n\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\t\v\f\v\v\v\v\v\r\x01\v\v\v\v\v\x01\v\v\v\v\v\v\v\v\v\v\x01\x01\x01\v\x01\x01\x01\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\x01\x01\x01\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\x01\x0E\x01\x01\x01\x0F\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x0E\x01\x10\x01\x01\x01\x01\x01\x11\x01\x12\x01\x0E\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x0E\x01\x13\x13\x13\x13\x13\x13\x13\x13\x13\x01\x13\x13\x14\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x15\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x16\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x17\x18\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x1A\x19\x19\e\x1C\x1C\x1C\x1D\x01\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x01\x1E\x1E\x1F\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E \x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E!\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\#$$$$$$$$$$$$%$$&'''(\x01)\x01\x1E\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x1E\x01*\x01+\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01+\x01\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\#$$$$$$$$$$$$%$$&'''(\x01\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x1E\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\x01\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\x01$$$$$$$$$$$$$$$$\x01,\x01\x01\x01-\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01,\x01.\x01\x01\x01\x01\x01/\x010\x011\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x011\x012\x01\x01\x013\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01244444445\x0144444\x014444444444\x01\x01\x01\x01\x01\x01\x0144444444444444444444444444\x01\x01\x01444444444444444444444444444444444\x01666666666\x01667666666666666666666666666668966666666666666666666666666666666666666666666666666:66666666666666666666666666666666666\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;<============>==?@@@A\x01BBBBBBBBB\x01BBCBBBBBBBBBBBBBBBBBBBBBBBBBBDEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBFBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGHIIIIIIIIIIIIJIIKLLLM\x01N\x01B\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01B\x01BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGHIIIIIIIIIIIIJIIKLLLM\x01BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB\x01GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\x01GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\x01GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG\x01IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII\x01IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII\x01IIIIIIIIIIIIIIII\x01OOOOOOO\x01\x01OOOOO\x01OOOOOOOOOO\x01P\x01\x01\x01\x01\x01OOOOOOOOOOOOOOOOOOOOOOOOOO\x01\x01\x01OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO\x01Q\x01\x01\x01R\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01Q\x01\x01\x01\x01\x01\x01\x01S\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01T\x01U\x01\x01\x01V\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01U\x01\x01\x01\x01\x01\x01\x01W\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01X\x01Y\x01\x01\x01Z\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01Y[\x01[[[[[\\\x01[[[[[\x01[[[[[[[[[[\x01T\x01[\x01\x01\x01[[[[[[[[[[[[[[[[[[[[[[[[[[\x01\x01\x01[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[\x011\x01\x01\x01]\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x011\x01\x01\x01\x01\x01\x01\x01^\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x02\x01_\x01\x01\x01`\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01_\x01\x01\x01\x01\x01\x01\x01a\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x012\x01\x01\x00")

      class << self
        attr_accessor :_trans_targs
        private :_trans_targs, :_trans_targs=
      end
      self._trans_targs = ::Ragel::Bitmap::Array8.new("(\x00\x02\x03\x05\e\x04\x05\x06\a\b+\n\x18\a\b\n\x18\t\v\f)\x10\x11\x12\x13\x14\x15\x16\x17\v\f)\x10\x11\x12\x13\x14\x15\x16\x17\r\x0F)\a\b\n\x18\x1A,\x02\x03\x05\e\x1D\x1E\x1D. !\"\#$%&'\x1D\x1E\x1D. !\"\#$%&'\x1F(\x02)\x0E*\x02)\x0E*\x02,\x19+-\x19-,\x19-")

      class << self
        attr_accessor :_trans_actions
        private :_trans_actions, :_trans_actions=
      end
      self._trans_actions = ::Ragel::Bitmap::Array8.new("\x01\x00\x00\x00\x02\x03\x00\x00\x04\x05\x05\x05\x05\x06\x00\x00\x00\x03\x00\a\a\b\a\a\a\a\a\a\a\a\x00\x00\t\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\n\n\n\v\x00\x00\n\n\f\v\r\r\x0E\x0F\r\r\r\r\r\r\r\r\x00\x00\x03\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x11\x12\x12\x13\x12\x14\x14\x15\x14\x12\x12\x00\x16\x00\x03\n\n\v")

      class << self
        attr_accessor :_eof_actions
        private :_eof_actions, :_eof_actions=
      end
      self._eof_actions = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x11\x12\x14\x12\x00\n\x00")

      class << self
        attr_accessor :start
      end
      self.start = 1
      class << self
        attr_accessor :first_final
      end
      self.first_final = 40
      class << self
        attr_accessor :error
      end
      self.error = 0

      class << self
        attr_accessor :en_comment_tail
      end
      self.en_comment_tail = 28
      class << self
        attr_accessor :en_main
      end
      self.en_main = 1

      def self.parse(data)
        data = data.dup.force_encoding(Encoding::ASCII_8BIT) if data.respond_to?(:force_encoding)

        content_disposition = ContentDispositionStruct.new("", [])
        return content_disposition if Mail::Utilities.blank?(data)

        # Parser state
        disp_type_s = param_attr_s = param_attr = qstr_s = qstr = param_val_s = nil

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
                    disp_type_s = p
                  end
                when 17
                  begin
                    content_disposition.disposition_type = chars(data, disp_type_s, p - 1).downcase
                  end
                when 2
                  begin
                    param_attr_s = p
                  end
                when 4
                  begin
                    param_attr = chars(data, param_attr_s, p - 1)
                  end
                when 7
                  begin
                    qstr_s = p
                  end
                when 9
                  begin
                    qstr = chars(data, qstr_s, p - 1)
                  end
                when 5
                  begin
                    param_val_s = p
                  end
                when 18
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
                    param_attr = nil
                    qstr = nil
                  end
                when 10
                  begin
                  end
                when 13
                  begin
                  end
                when 3
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                when 16
                  begin
                    begin
                      top -= 1
                      cs = stack[top]
                      _goto_level = _again
                      next
                    end
                  end
                when 8
                  begin
                    qstr_s = p
                  end
                  begin
                    qstr = chars(data, qstr_s, p - 1)
                  end
                when 6
                  begin
                    param_val_s = p
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                when 22
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
                    param_attr = nil
                    qstr = nil
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                when 12
                  begin
                  end
                  begin
                    param_attr_s = p
                  end
                when 20
                  begin
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
                    param_attr = nil
                    qstr = nil
                  end
                when 11
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                when 14
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                when 15
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
                when 19
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
                    param_attr = nil
                    qstr = nil
                  end
                when 21
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 28
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
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
                when 17
                  begin
                    content_disposition.disposition_type = chars(data, disp_type_s, p - 1).downcase
                  end
                when 18
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
                    param_attr = nil
                    qstr = nil
                  end
                when 10
                  begin
                  end
                when 20
                  begin
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
                    end

                    # Use quoted string value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_disposition.parameters << {param_attr => value}
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

        if p != eof || cs < 40
          raise Mail::Field::IncompleteParseError.new(Mail::ContentDispositionElement, data, p)
        end

        content_disposition
      end
    end
  end
ensure
  $VERBOSE = original_verbose
end
