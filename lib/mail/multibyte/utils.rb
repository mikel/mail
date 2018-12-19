# encoding: utf-8
# frozen_string_literal: true

module Mail #:nodoc:
  module Multibyte #:nodoc:
    if RUBY_VERSION >= "1.9"
      # Returns a regular expression that matches valid characters in the current encoding
      def self.valid_character
        VALID_CHARACTER[Encoding.default_external.to_s]
      end

      # Returns true if string has valid utf-8 encoding
      def self.is_utf8?(string)
        case string.encoding
        when Encoding::UTF_8
          verify(string)
        when Encoding::ASCII_8BIT, Encoding::US_ASCII
          verify(to_utf8(string))
        else
          false
        end
      end
    else
      def self.valid_character
        case $KCODE
        when 'UTF8'
          VALID_CHARACTER['UTF-8']
        when 'SJIS'
          VALID_CHARACTER['Shift_JIS']
        end
      end

      def self.is_utf8?(string)
        case $KCODE
        when 'UTF8'
          verify(string)
        else
          false
        end
      end
    end

    if 'string'.respond_to?(:valid_encoding?)
      # Verifies the encoding of a string
      def self.verify(string)
        string.valid_encoding?
      end
    else
      def self.verify(string)
        if expression = valid_character
          # Splits the string on character boundaries, which are determined based on $KCODE.
          string.split(//).all? { |c| expression =~ c }
        else
          true
        end
      end
    end

    # Verifies the encoding of the string and raises an exception when it's not valid
    def self.verify!(string)
      raise EncodingError.new("Found characters with invalid encoding") unless verify(string)
    end

    if 'string'.respond_to?(:force_encoding)
      # Removes all invalid characters from the string.
      #
      # Note: this method is a no-op in Ruby 1.9
      def self.clean(string)
        string
      end

      def self.to_utf8(string)
        string.dup.force_encoding(Encoding::UTF_8)
      end
    else
      def self.clean(string)
        if expression = valid_character
          # Splits the string on character boundaries, which are determined based on $KCODE.
          string.split(//).grep(expression).join
        else
          string
        end
      end

      def self.to_utf8(string)
        string
      end
    end
  end
end
