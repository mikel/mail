# encoding: utf-8
# frozen_string_literal: true
require 'mail/constants'
require 'socket'

module Mail
  module Utilities
    extend self

    # Returns true if the string supplied is free from characters not allowed as an ATOM
    def atom_safe?( str )
      not Constants::ATOM_UNSAFE === str
    end

    # If the string supplied has ATOM unsafe characters in it, will return the string quoted
    # in double quotes, otherwise returns the string unmodified
    def quote_atom( str )
      atom_safe?( str ) ? str : dquote(str)
    end

    # If the string supplied has PHRASE unsafe characters in it, will return the string quoted
    # in double quotes, otherwise returns the string unmodified
    def quote_phrase( str )
      if str.respond_to?(:force_encoding)
        original_encoding = str.encoding
        ascii_str = str.to_s.dup.force_encoding('ASCII-8BIT')
        if Constants::PHRASE_UNSAFE === ascii_str
          dquote(ascii_str).force_encoding(original_encoding)
        else
          str
        end
      else
        Constants::PHRASE_UNSAFE === str ? dquote(str) : str
      end
    end

    # Returns true if the string supplied is free from characters not allowed as a TOKEN
    def token_safe?( str )
      not Constants::TOKEN_UNSAFE === str
    end

    # If the string supplied has TOKEN unsafe characters in it, will return the string quoted
    # in double quotes, otherwise returns the string unmodified
    def quote_token( str )
      if str.respond_to?(:force_encoding)
        original_encoding = str.encoding
        ascii_str = str.to_s.dup.force_encoding('ASCII-8BIT')
        if token_safe?( ascii_str )
          str
        else
          dquote(ascii_str).force_encoding(original_encoding)
        end
      else
        token_safe?( str ) ? str : dquote(str)
      end
    end

    # Wraps supplied string in double quotes and applies \-escaping as necessary,
    # unless it is already wrapped.
    #
    # Example:
    #
    #  string = 'This is a string'
    #  dquote(string) #=> '"This is a string"'
    #
    #  string = 'This is "a string"'
    #  dquote(string #=> '"This is \"a string\"'
    def dquote( str )
      '"' + unquote(str).gsub(/[\\"]/n) {|s| '\\' + s } + '"'
    end

    # Unwraps supplied string from inside double quotes and
    # removes any \-escaping.
    #
    # Example:
    #
    #  string = '"This is a string"'
    #  unquote(string) #=> 'This is a string'
    #
    #  string = '"This is \"a string\""'
    #  unqoute(string) #=> 'This is "a string"'
    def unquote( str )
      if str =~ /^"(.*?)"$/
        unescape($1)
      else
        str
      end
    end

    # Removes any \-escaping.
    #
    # Example:
    #
    #  string = 'This is \"a string\"'
    #  unescape(string) #=> 'This is "a string"'
    #
    #  string = '"This is \"a string\""'
    #  unescape(string) #=> '"This is "a string""'
    def unescape( str )
      str.gsub(/\\(.)/, '\1')
    end

    # Wraps a string in parenthesis and escapes any that are in the string itself.
    #
    # Example:
    #
    #  paren( 'This is a string' ) #=> '(This is a string)'
    def paren( str )
      RubyVer.paren( str )
    end

    # Unwraps a string from being wrapped in parenthesis
    #
    # Example:
    #
    #  str = '(This is a string)'
    #  unparen( str ) #=> 'This is a string'
    def unparen( str )
      if str.start_with?('(') && str.end_with?(')')
        str.slice(1..-2)
      else
        str
      end
    end

    # Wraps a string in angle brackets and escapes any that are in the string itself
    #
    # Example:
    #
    #  bracket( 'This is a string' ) #=> '<This is a string>'
    def bracket( str )
      RubyVer.bracket( str )
    end

    # Unwraps a string from being wrapped in parenthesis
    #
    # Example:
    #
    #  str = '<This is a string>'
    #  unbracket( str ) #=> 'This is a string'
    def unbracket( str )
      if str.start_with?('<') && str.end_with?('>')
        str.slice(1..-2)
      else
        str
      end
    end

    # Escape parenthesies in a string
    #
    # Example:
    #
    #  str = 'This is (a) string'
    #  escape_paren( str ) #=> 'This is \(a\) string'
    def escape_paren( str )
      RubyVer.escape_paren( str )
    end

    def uri_escape( str )
      uri_parser.escape(str)
    end

    def uri_unescape( str )
      uri_parser.unescape(str)
    end

    def uri_parser
      @uri_parser ||= URI.const_defined?(:DEFAULT_PARSER) ? URI::DEFAULT_PARSER : URI
    end

    # Matches two objects with their to_s values case insensitively
    #
    # Example:
    #
    #  obj2 = "This_is_An_object"
    #  obj1 = :this_IS_an_object
    #  match_to_s( obj1, obj2 ) #=> true
    def match_to_s( obj1, obj2 )
      obj1.to_s.casecmp(obj2.to_s) == 0
    end

    # Capitalizes a string that is joined by hyphens correctly.
    #
    # Example:
    #
    #  string = 'resent-from-field'
    #  capitalize_field( string ) #=> 'Resent-From-Field'
    def capitalize_field( str )
      str.to_s.split("-").map { |v| v.capitalize }.join("-")
    end

    # Takes an underscored word and turns it into a class name
    #
    # Example:
    #
    #  constantize("hello") #=> "Hello"
    #  constantize("hello-there") #=> "HelloThere"
    #  constantize("hello-there-mate") #=> "HelloThereMate"
    def constantize( str )
      str.to_s.split(/[-_]/).map { |v| v.capitalize }.to_s
    end

    # Swaps out all underscores (_) for hyphens (-) good for stringing from symbols
    # a field name.
    #
    # Example:
    #
    #  string = :resent_from_field
    #  dasherize( string ) #=> 'resent-from-field'
    def dasherize( str )
      str.to_s.tr(Constants::UNDERSCORE, Constants::HYPHEN)
    end

    # Swaps out all hyphens (-) for underscores (_) good for stringing to symbols
    # a field name.
    #
    # Example:
    #
    #  string = :resent_from_field
    #  underscoreize ( string ) #=> 'resent_from_field'
    def underscoreize( str )
      str.to_s.downcase.tr(Constants::HYPHEN, Constants::UNDERSCORE)
    end

    def map_lines( str, &block )
      str.each_line.map(&block)
    end

    def map_with_index( enum, &block )
      enum.each_with_index.map(&block)
    end

    def self.binary_unsafe_to_lf(string) #:nodoc:
      string.gsub(/\r\n|\r/, Constants::LF)
    end

    TO_CRLF_REGEX =
      # This 1.9 only regex can save a reasonable amount of time (~20%)
      # by not matching "\r\n" so the string is returned unchanged in
      # the common case.
      Regexp.new("(?<!\r)\n|\r(?!\n)")

    def self.binary_unsafe_to_crlf(string) #:nodoc:
      string.gsub(TO_CRLF_REGEX, Constants::CRLF)
    end

    def self.safe_for_line_ending_conversion?(string) #:nodoc:
      if string.encoding == Encoding::BINARY
        string.ascii_only?
      else
        string.valid_encoding?
      end
    end

    # Convert line endings to \n unless the string is binary. Used for
    # sendmail delivery and for decoding 8bit Content-Transfer-Encoding.
    def self.to_lf(string)
      string = string.to_s
      if safe_for_line_ending_conversion? string
        binary_unsafe_to_lf string
      else
        string
      end
    end

    # Convert line endings to \r\n unless the string is binary. Used for
    # encoding 8bit and base64 Content-Transfer-Encoding and for convenience
    # when parsing emails with \n line endings instead of the required \r\n.
    def self.to_crlf(string)
      string = string.to_s
      if safe_for_line_ending_conversion? string
        binary_unsafe_to_crlf string
      else
        string
      end
    end

    # Returns true if the object is considered blank.
    # A blank includes things like '', '   ', nil,
    # and arrays and hashes that have nothing in them.
    #
    # This logic is mostly shared with ActiveSupport's blank?
    def blank?(value)
      if value.kind_of?(NilClass)
        true
      elsif value.kind_of?(String)
        value !~ /\S/
      else
        value.respond_to?(:empty?) ? value.empty? : !value
      end
    end

    def generate_message_id
      "<#{Mail.random_tag}@#{::Socket.gethostname}.mail>"
    end
  end
end
