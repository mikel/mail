
# frozen_string_literal: true
require "mail/utilities"
require "mail/parser_tools"

begin
  original_verbose, $VERBOSE = $VERBOSE, nil

  module Mail::Parsers
    module ContentLocationParser
      extend Mail::ParserTools

      ContentLocationStruct = Struct.new(:location, :error)

      class << self
        attr_accessor :_trans_keys
        private :_trans_keys, :_trans_keys=
      end
      self._trans_keys = ::Ragel::Bitmap::Array8.new("\x00\x00\t~\n\n\t \n\n\t \x01\xF4\n\n\t \x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F\n\n\t \t~\x01\xF4\x01\xF4\n\n\t \x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F\t~\t(\t(\x01\xF4\x01\xF4\x01\xF4\x01\xF4\t~\x00\x00\x00")

      class << self
        attr_accessor :_key_spans
        private :_key_spans, :_key_spans=
      end
      self._key_spans = ::Ragel::Bitmap::Array8.new("\x00v\x01\x18\x01\x18\xF4\x01\x18\xF5@ @ 0@\x10\x01\x18v\xF4\xF4\x01\x18\xF5@ @ 0@\x10v  \xF4\xF4\xF4\xF4v\x00")

      class << self
        attr_accessor :_index_offsets
        private :_index_offsets, :_index_offsets=
      end
      self._index_offsets = ::Ragel::Bitmap::Array16.new("\x00\x00\x00\x00\x00\x00\x00\x01\x01\x01\x02\x02\x03\x03\x03\x03\x03\x03\x03\x04\x04\x05\x06\x06\x06\a\a\a\b\b\b\b\b\t\t\t\n\v\f\r\r", "\x00\x00wy\x92\x94\xAD\xA2\xA4\xBD\xB3\xF4\x15Vw\xA8\xE9\xFA\xFC\x15\x8C\x81vx\x91\x87\xC8\xE9*K|\xBD\xCEEf\x87|qf[\xD2")

      class << self
        attr_accessor :_indicies
        private :_indicies, :_indicies=
      end
      self._indicies = ::Ragel::Bitmap::Array8.new("\x00\x01\x01\x01\x02\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00\x03\x04\x03\x03\x03\x03\x03\x05\x01\x03\x03\x03\x03\x03\x01\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x01\x01\x01\x03\x01\x01\x01\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x01\x01\x01\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x03\x01\x06\x01\x00\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00\x01\a\x01\b\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\b\x01\t\t\t\t\t\t\t\t\t\x01\t\t\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\v\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\f\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x0E\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x10\x0F\x0F\x11\x12\x12\x12\x13\x01\x14\x01\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\t\x01\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x0E\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x10\x0F\x0F\x11\x12\x12\x12\x13\x01\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x15\x01\x16\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x16\x01\x17\x01\x01\x01\x18\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x17\x19\x1A\x19\x19\x19\x19\x19\e\x01\x19\x19\x19\x19\x19\x01\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x01\x01\x01\x19\x01\x01\x01\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x01\x01\x01\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x19\x01\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x01\x1C\x1C\x1D\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1E\x1F\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C \x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x1C\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\"###########\#$##%&&&'\x01(((((((((\x01(()((((((((((((((((((((((((((*+((((((((((((((((((((((((((((((((((((((((((((((((((,(((((((((((((((((((((((((((((((((((\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01------------------------------.////////////0//12223\x014\x01(\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01(\x01((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01------------------------------.////////////0//12223\x01((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((\x01--------------------------------\x01----------------------------------------------------------------\x01--------------------------------\x01////////////////////////////////////////////////\x01////////////////////////////////////////////////////////////////\x01////////////////\x015\x01\x01\x016\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01577777778\x0177777\x017777777777\x01\x01\x017\x01\x01\x0177777777777777777777777777\x01\x01\x01777777777777777777777777777777777\x01\b\x01\x01\x019\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\b\x01\x01\x01\x01\x01\x01\x01:\x01;\x01\x01\x01<\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01;\x01\x01\x01\x01\x01\x01\x01=\x01>>>>>>>>?\x01>>@>>>>>>>>>>>>>>>>>>?ABAAAAAC>AAAAA>AAAAAAAAAA>>>A>>>AAAAAAAAAAAAAAAAAAAAAAAAAA>D>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA>\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEFGGGGGGGGGGGGHGGIJJJK\x01\t\t\t\t\t\t\t\t\x16\x01\t\tL\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\x16\t\v\t\t\t\t\tM\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\f\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x0E\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x10\x0F\x0F\x11\x12\x12\x12\x13\x01\t\t\t\t\t\t\t\tN\x01\t\tO\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tN\t\v\t\t\t\t\tP\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\f\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x0E\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x10\x0F\x0F\x11\x12\x12\x12\x13\x01\t\t\t\t\t\t\t\tQ\x01\t\tR\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tQSTSSSSSU\tSSSSS\tSSSSSSSSSS\t\t\tS\t\t\tSSSSSSSSSSSSSSSSSSSSSSSSSS\t\f\tSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\x0E\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x10\x0F\x0F\x11\x12\x12\x12\x13\x015\x01\x01\x016\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x0157777777V\x0177777\x017777777777\x01\x01\x017\x01\x01\x0177777777777777777777777777\x01\x01\x01777777777777777777777777777777777\x01\x01\x00")

      class << self
        attr_accessor :_trans_targs
        private :_trans_targs, :_trans_targs=
      end
      self._trans_targs = ::Ragel::Bitmap::Array8.new("\x01\x00\x02 #\x13\x03\x05!\x06\a!\t\n\v\f\r\x0E\x0F\x10\b\x12$\x01\x02 #\x13\x15\x16\x15(\x18\x19\x1A\e\x1C\x1D\x1E\x1F\x15\x16\x15(\x18\x19\x1A\e\x1C\x1D\x1E\x1F\x17!\x04 \"\x04\"!\x04\"\x06$\x11&'%\t\n\v\f\r\x0E\x0F\x10\x11%$\x11%$\x11&'%\"")

      class << self
        attr_accessor :_trans_actions
        private :_trans_actions, :_trans_actions=
      end
      self._trans_actions = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x01\x01\x02\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x04\x05\x05\x06\a\a\b\t\a\a\a\a\a\a\a\a\x00\x00\x02\n\x00\x00\x00\x00\x00\x00\x00\x00\x00\v\v\x00\f\x00\x02\x04\x04\x06\r\x0E\x0E\r\x0F\x10\r\r\r\r\r\r\r\r\x00\x02\x04\x04\x06\v\v\x00\x03\f\x11")

      class << self
        attr_accessor :_eof_actions
        private :_eof_actions, :_eof_actions=
      end
      self._eof_actions = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\v\x00\x04\v\x00\x04\v\v\x00")

      class << self
        attr_accessor :start
      end
      self.start = 1
      class << self
        attr_accessor :first_final
      end
      self.first_final = 32
      class << self
        attr_accessor :error
      end
      self.error = 0

      class << self
        attr_accessor :en_comment_tail
      end
      self.en_comment_tail = 20
      class << self
        attr_accessor :en_main
      end
      self.en_main = 1

      def self.parse(data)
        data = data.dup.force_encoding(Encoding::ASCII_8BIT) if data.respond_to?(:force_encoding)

        content_location = ContentLocationStruct.new(nil)
        return content_location if Mail::Utilities.blank?(data)

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
                when 13
                  begin
                    qstr_s = p
                  end
                when 3
                  begin
                    content_location.location = chars(data, qstr_s, p - 1)
                  end
                when 1
                  begin
                    token_string_s = p
                  end
                when 11
                  begin
                    content_location.location = chars(data, token_string_s, p - 1)
                  end
                when 4
                  begin
                  end
                when 7
                  begin
                  end
                when 2
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 20
                      _goto_level = _again
                      next
                    end
                  end
                when 10
                  begin
                    begin
                      top -= 1
                      cs = stack[top]
                      _goto_level = _again
                      next
                    end
                  end
                when 15
                  begin
                    qstr_s = p
                  end
                  begin
                    content_location.location = chars(data, qstr_s, p - 1)
                  end
                when 14
                  begin
                    qstr_s = p
                  end
                  begin
                    content_location.location = chars(data, token_string_s, p - 1)
                  end
                when 12
                  begin
                    content_location.location = chars(data, token_string_s, p - 1)
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 20
                      _goto_level = _again
                      next
                    end
                  end
                when 5
                  begin
                  end
                  begin
                    token_string_s = p
                  end
                when 6
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 20
                      _goto_level = _again
                      next
                    end
                  end
                when 8
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 20
                      _goto_level = _again
                      next
                    end
                  end
                when 9
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
                when 17
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 20
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    content_location.location = chars(data, token_string_s, p - 1)
                  end
                when 16
                  begin
                    qstr_s = p
                  end
                  begin
                    content_location.location = chars(data, token_string_s, p - 1)
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 20
                      _goto_level = _again
                      next
                    end
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
                when 11
                  begin
                    content_location.location = chars(data, token_string_s, p - 1)
                  end
                when 4
                  begin
                  end
                end
              end
            end
            if _goto_level <= _out
              break
            end
          end
        end

        if p != eof || cs < 32
          raise Mail::Field::IncompleteParseError.new(Mail::ContentLocationElement, data, p)
        end

        content_location
      end
    end
  end
ensure
  $VERBOSE = original_verbose
end
