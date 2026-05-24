# frozen_string_literal: true
require "mail/utilities"
require "mail/parser_tools"

begin
  original_verbose, $VERBOSE = $VERBOSE, nil

  module Mail::Parsers
    module MimeVersionParser
      extend Mail::ParserTools

      MimeVersionStruct = Struct.new(:major, :minor, :error)

      class << self
        attr_accessor :_trans_keys
        private :_trans_keys, :_trans_keys=
      end
      self._trans_keys = ::Ragel::Bitmap::Array8.new("\x00\x00\t9\n\n\t \t9(9..(909\n\n\t \x01\xF4\x01\xF4\n\n\t \x00\xF4\x80\xBF\xA0\xBF\x80\xBF\x80\x9F\x90\xBF\x80\xBF\x80\x8F\t9\t(\t(\x00\x00\x00")

      class << self
        attr_accessor :_key_spans
        private :_key_spans, :_key_spans=
      end
      self._key_spans = ::Ragel::Bitmap::Array8.new("\x001\x01\x181\x12\x01\x12\n\x01\x18\xF4\xF4\x01\x18\xF5@ @ 0@\x101  \x00")

      class << self
        attr_accessor :_index_offsets
        private :_index_offsets, :_index_offsets=
      end
      self._index_offsets = ::Ragel::Bitmap::Array16.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x02\x02\x03\x04\x04\x04\x04\x04\x04\x05\x05\x05\x05", "\x00\x0024M\x7F\x92\x94\xA7\xB2\xB4\xCD\xC2\xB7\xB9\xD2\xC8\t*k\x8C\xBD\xFE\x0FAb\x83")

      class << self
        attr_accessor :_indicies
        private :_indicies, :_indicies=
      end
      self._indicies = ::Ragel::Bitmap::Array8.new("\x00\x01\x01\x01\x02\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00\x01\x01\x01\x01\x01\x01\x01\x03\x01\x01\x01\x01\x01\x01\x01\x04\x04\x04\x04\x04\x04\x04\x04\x04\x04\x01\x05\x01\x00\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00\x01\x06\x01\x01\x01\a\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x06\x01\x01\x01\x01\x01\x01\x01\b\x01\x01\x01\x01\x01\x01\x01\t\t\t\t\t\t\t\t\t\t\x01\n\x01\x01\x01\x01\x01\v\x01\f\f\f\f\f\f\f\f\f\f\x01\r\x01\x0E\x01\x01\x01\x01\x01\x01\x01\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x0F\x01\x10\x10\x10\x10\x10\x10\x10\x10\x10\x10\x01\x11\x01\x12\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x12\x01\x13\x13\x13\x13\x13\x13\x13\x13\x13\x01\x13\x13\x14\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x15\x16\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x17\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x13\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x18\x19\x1A\x1A\x1A\x1A\x1A\x1A\x1A\x1A\x1A\x1A\x1A\x1A\e\x1A\x1A\x1C\x1D\x1D\x1D\x1E\x01\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x01\x1F\x1F \x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F!\"\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F#\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%&&&&&&&&&&&&'&&()))*\x01+\x01\x1F\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x1F\x01\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%&&&&&&&&&&&&'&&()))*\x01\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x1F\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\x01$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\x01&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\x01&&&&&&&&&&&&&&&&\x01,\x01\x01\x01-\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01,\x01\x01\x01\x01\x01\x01\x01.\x01\x01\x01\x01\x01\x01\x01//////////\x01\x12\x01\x01\x010\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x12\x01\x01\x01\x01\x01\x01\x011\x012\x01\x01\x013\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x012\x01\x01\x01\x01\x01\x01\x014\x01\x01\x00")

      class << self
        attr_accessor :_trans_targs
        private :_trans_targs, :_trans_targs=
      end
      self._trans_targs = ::Ragel::Bitmap::Array8.new("\x01\x00\x02\x04\x05\x03\x01\x02\x04\x05\x06\a\x05\a\b\x17\x17\n\x18\f\r\f\x1A\x0F\x10\x11\x12\x13\x14\x15\x16\f\r\f\x1A\x0F\x10\x11\x12\x13\x14\x15\x16\x0E\x18\t\x19\x17\t\x19\x18\t\x19")

      class << self
        attr_accessor :_trans_actions
        private :_trans_actions, :_trans_actions=
      end
      self._trans_actions = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x01\x02\x00\x03\x03\x04\x05\x06\a\x00\x03\x01\b\t\x00\x00\n\n\v\f\n\n\n\n\n\n\n\n\x00\x00\x01\r\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0E\x0E\x0F\x00\x00\x01\x03\x03\x04")

      class << self
        attr_accessor :_eof_actions
        private :_eof_actions, :_eof_actions=
      end
      self._eof_actions = ::Ragel::Bitmap::Array8.new("\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0E\x00\x03\x00")

      class << self
        attr_accessor :start
      end
      self.start = 1
      class << self
        attr_accessor :first_final
      end
      self.first_final = 23
      class << self
        attr_accessor :error
      end
      self.error = 0

      class << self
        attr_accessor :en_comment_tail
      end
      self.en_comment_tail = 11
      class << self
        attr_accessor :en_main
      end
      self.en_main = 1

      def self.parse(data)
        data = data.dup.force_encoding(Encoding::ASCII_8BIT) if data.respond_to?(:force_encoding)

        return MimeVersionStruct.new("", nil) if Mail::Utilities.blank?(data)

        # Parser state
        mime_version = MimeVersionStruct.new
        major_digits_s = minor_digits_s = nil

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
                when 2
                  begin
                    major_digits_s = p
                  end
                when 7
                  begin
                    mime_version.major = chars(data, major_digits_s, p - 1)
                  end
                when 8
                  begin
                    minor_digits_s = p
                  end
                when 14
                  begin
                    mime_version.minor = chars(data, minor_digits_s, p - 1)
                  end
                when 10
                  begin
                  end
                when 3
                  begin
                  end
                when 1
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 11
                      _goto_level = _again
                      next
                    end
                  end
                when 13
                  begin
                    begin
                      top -= 1
                      cs = stack[top]
                      _goto_level = _again
                      next
                    end
                  end
                when 6
                  begin
                    mime_version.major = chars(data, major_digits_s, p - 1)
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 11
                      _goto_level = _again
                      next
                    end
                  end
                when 15
                  begin
                    mime_version.minor = chars(data, minor_digits_s, p - 1)
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 11
                      _goto_level = _again
                      next
                    end
                  end
                when 11
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 11
                      _goto_level = _again
                      next
                    end
                  end
                when 12
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
                when 5
                  begin
                  end
                  begin
                    major_digits_s = p
                  end
                when 9
                  begin
                  end
                  begin
                    minor_digits_s = p
                  end
                when 4
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 11
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
                when 14
                  begin
                    mime_version.minor = chars(data, minor_digits_s, p - 1)
                  end
                when 3
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

        if false
          testEof
        end

        if p != eof || cs < 23
          raise Mail::Field::IncompleteParseError.new(Mail::MimeVersionElement, data, p)
        end

        mime_version
      end
    end
  end
ensure
  $VERBOSE = original_verbose
end
