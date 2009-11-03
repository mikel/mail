# encoding: utf-8
module Mail
  module Encodings
    
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

    # Encode a string with Base64 Encoding and returns it ready to be inserted
    # as a value for a field, that is, in the =?<charset>?B?<string>?= format
    #
    # Example:
    # 
    #  Encodings.b_value_encode('This is あ string', 'UTF-8') 
    #  #=> "=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?="
    def Encodings.b_value_encode(str, encoding = nil)
      return str if str.ascii_only?
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
      return str if str.ascii_only?
      string, encoding = RubyVer.q_value_encode(str, encoding)
      "=?#{encoding}?Q?#{string.chomp}?="
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

    # Encodes a parameter value using URI Escaping.
    # 
    # Example:
    # 
    #  Mail::Encodings.param_encode("This is fun") #=> "This%20is%20fun"
    def Encodings.param_encode(str)
      URI.escape(str)
    end
    
  end
end