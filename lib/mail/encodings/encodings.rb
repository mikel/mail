# encoding: utf-8
module Mail
  module Encodings
    
    include Mail::Patterns
    
    # Is the encoding we want defined?
    # 
    # Example:
    # 
    #  Encodings.defined?(:base64) #=> true
    def Encodings.defined?( str )
      string = str.to_s.split(/[_-]/).map { |v| v.capitalize }.join('')
      RubyVer.has_constant?(Mail::Encodings, string)
    end
    
    # Gets a defined encoding type, QuotedPrintable or Base64 for now.
    # 
    # Each encoding needs to be defined as a Mail::Encodings::ClassName for 
    # this to work, allows us to add other encodings in the future.
    # 
    # Example:
    # 
    #  Encodings.get_encoding(:base64) #=> Mail::Encodings::Base64
    def Encodings.get_encoding( str )
      string = str.to_s.split(/[_-]/).map { |v| v.capitalize }.join('')
      RubyVer.get_constant(Mail::Encodings, string)
    end

    # Encodes a parameter value using URI Escaping, note the language field 'en' can
    # be set using Mail::Configuration, like so:
    # 
    #  Mail.defaults.do
    #    param_encode_language 'jp'
    #  end
    #
    # The character set used for encoding will either be the value of $KCODE for 
    # Ruby < 1.9 or the encoding on the string passed in.
    # 
    # Example:
    # 
    #  Mail::Encodings.param_encode("This is fun") #=> "us-ascii'en'This%20is%20fun"
    def Encodings.param_encode(str)
      case
      when str.ascii_only? && str =~ TOKEN_UNSAFE
        %Q{"#{str}"}
      when str.ascii_only?
        str
      else
        RubyVer.param_encode(str)
      end
    end

    # Decodes a parameter value using URI Escaping.
    # 
    # Example:
    # 
    #  Mail::Encodings.param_decode("This%20is%20fun", 'us-ascii') #=> "This is fun"
    #
    #  str = Mail::Encodings.param_decode("This%20is%20fun", 'iso-8559-1')
    #  str.encoding #=> 'ISO-8859-1'      ## Only on Ruby 1.9
    #  str #=> "This is fun"
    def Encodings.param_decode(str, encoding)
      RubyVer.param_decode(str, encoding)
    end
    
    # Decodes or encodes a string as needed for either Base64 or QP encoding types in
    # the =?<encoding>?[QB]?<string>?=" format.
    # 
    # The output type needs to be :decode to decode the input string or :encode to
    # encode the input string.  The character set used for encoding will either be
    # the value of $KCODE for Ruby < 1.9 or the encoding on the string passed in.
    # 
    # On encoding, will only send out Base64 encoded strings.
    def Encodings.decode_encode(str, output_type)
      case
      when output_type == :decode
        Encodings.value_decode(str)
      else
        if str.ascii_only?
          str
        else
          Encodings.b_value_encode(str, find_encoding(str))
        end
      end
    end
    
    # Decodes a given string as Base64 or Quoted Printable, depending on what
    # type it is.
    # 
    # String has to be of the format =?<encoding>?[QB]?<string>?=
    def Encodings.value_decode(str)
      str.gsub!(/\?=(\s*)=\?/, '?==?') # Remove whitespaces between 'encoded-word's
      str.gsub(/(.*?)(=\?.*?\?.\?.*?\?=)|$/m) do
        before = $1.to_s
        text = $2.to_s
        
        case
        when text =~ /=\?.+\?[Bb]\?/m
          before + b_value_decode(text)
        when text =~ /=\?.+\?[Qq]\?/m
          before + q_value_decode(text)
        else
          before + text
        end
      end
    end
    
    # Takes an encoded string of the format =?<encoding>?[QB]?<string>?=
    def Encodings.unquote_and_convert_to(str, to_encoding)
      original_encoding, string = split_encoding_from_string( str )

      output = value_decode( str ).to_s

      if original_encoding.to_s.downcase.gsub("-", "") == to_encoding.to_s.downcase.gsub("-", "")
        output
      elsif original_encoding && to_encoding
        begin
          require 'iconv'
          Iconv.iconv(to_encoding, original_encoding, output).first
        rescue Iconv::IllegalSequence, Iconv::InvalidEncoding, Errno::EINVAL
          # the 'from' parameter specifies a charset other than what the text
          # actually is...not much we can do in this case but just return the
          # unconverted text.
          #
          # Ditto if either parameter represents an unknown charset, like
          # X-UNKNOWN.
          output
        end
      else
        output
      end
    end
    
    # Encode a string with Base64 Encoding and returns it ready to be inserted
    # as a value for a field, that is, in the =?<charset>?B?<string>?= format
    #
    # Example:
    # 
    #  Encodings.b_value_encode('This is あ string', 'UTF-8') 
    #  #=> "=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?="
    def Encodings.b_value_encode(str, encoding = nil)
      string, encoding = RubyVer.b_value_encode(str, encoding)
      string.split("\n").map do |str|
        "=?#{encoding}?B?#{str.chomp}?="
      end.join(" ")
    end
    
    # Encode a string with Quoted-Printable Encoding and returns it ready to be inserted
    # as a value for a field, that is, in the =?<charset>?Q?<string>?= format
    #
    # Example:
    # 
    #  Encodings.q_value_encode('This is あ string', 'UTF-8') 
    #  #=> "=?UTF-8?Q?This_is_=E3=81=82_string?="
    def Encodings.q_value_encode(str, encoding = nil)
      string, encoding = RubyVer.q_value_encode(str, encoding)
      "=?#{encoding}?Q?#{string.chomp.gsub(/ /, '_')}?="
    end
    
    private
    
    # Decodes a Base64 string from the "=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?=" format
    # 
    # Example:
    # 
    #  Encodings.b_value_encode("=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?=") 
    #  #=> 'This is あ string'
    def Encodings.b_value_decode(str)
      RubyVer.b_value_decode(str)
    end
    
    # Decodes a Quoted-Printable string from the "=?UTF-8?Q?This_is_=E3=81=82_string?=" format
    # 
    # Example:
    # 
    #  Encodings.b_value_encode("=?UTF-8?Q?This_is_=E3=81=82_string?=") 
    #  #=> 'This is あ string'
    def Encodings.q_value_decode(str)
      RubyVer.q_value_decode(str).gsub(/_/, ' ')
    end
    
    def Encodings.split_encoding_from_string( str )
      match = str.match(/\=\?(.+)?\?[QB]\?(.+)?\?\=/mi)
      if match
        [match[1], match[2]]
      else
        nil
      end
    end
    
    def Encodings.find_encoding(str)
      RUBY_VERSION >= '1.9' ? str.encoding : $KCODE
    end
    
  end
end
