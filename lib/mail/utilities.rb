# encoding: utf-8
module Mail
  module Utilities
    
    module ClassMethods # :nodoc:
    
    end
  
    module InstanceMethods

      include Patterns
      
      # Returns true if the string supplied is free from characters not allowed as an ATOM
      def atom_safe?( str )
        not ATOM_UNSAFE === str
      end

      # If the string supplied has ATOM unsafe characters in it, will return the string quoted 
      # in double quotes, otherwise returns the string unmodified
      def quote_atom( str )
        (ATOM_UNSAFE === str) ? dquote(str) : str
      end

      # If the string supplied has PHRASE unsafe characters in it, will return the string quoted 
      # in double quotes, otherwise returns the string unmodified
      def quote_phrase( str )
        (PHRASE_UNSAFE === str) ? dquote(str) : str
      end

      # Returns true if the string supplied is free from characters not allowed as a TOKEN
      def token_safe?( str )
        not TOKEN_UNSAFE === str
      end

      # If the string supplied has TOKEN unsafe characters in it, will return the string quoted 
      # in double quotes, otherwise returns the string unmodified
      def quote_token( str )
        (TOKEN_UNSAFE === str) ? dquote(str) : str
      end

      # Wraps supplied string in double quotes unless it is already wrapped.
      # 
      # Additionally will escape any double quotation marks in the string with a single
      # backslash in front of the '"' character.
      def dquote( str )
        str = $1 if str =~ /^"(.*)?"$/
        # First remove all escaped double quotes:
        str = str.gsub(/\\"/, '"')
        # Then wrap and re-escape all double quotes
        '"' + str.gsub(/["]/n) {|s| '\\' + s } + '"'
      end
      
      # Unwraps supplied string from inside double quotes.
      # 
      # Example:
      # 
      #  string = '"This is a string"'
      #  unquote(string) #=> 'This is a string'
      def unquote( str )
        str =~ /^"(.*?)"$/ ? $1 : str
      end
      
      # Wraps a string in parenthesis and escapes any that are in the string itself.
      # 
      # Example:
      # 
      #  string
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
        str =~ /^\((.*?)\)$/ ? $1 : str
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
      
      # Matches two objects with their to_s values case insensitively
      # 
      # Example:
      # 
      #  obj2 = "This_is_An_object"
      #  obj1 = :this_IS_an_object
      #  match_to_s( obj1, obj2 ) #=> true
      def match_to_s( obj1, obj2 )
        obj1.to_s.downcase == obj2.to_s.downcase
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

      # Swaps out all hyphens (-) for underscores (_) good for symbolizing
      # a field name.
      # 
      # Example:
      # 
      #  string = 'Resent-From-Field'
      #  underscoreize ( string ) #=> 'resent_from_field'
      def underscoreize( str )
        str.to_s.downcase.gsub('_', '-')
      end
      
      # Decode the string from Base64
      def decode_base64(str)
        Base64.decode64(str)
      end
      
      # Encode the string to Base64
      def encode_base64(str)
        Base64.encode64(str)
      end
      
      # Decode the string from Quoted-Printable
      def decode_quoted_printable(str)
        str.unpack("M*").first
      end

      # Convert the given text into quoted printable format, with an instruction
      # that the text be eventually interpreted in the given charset.
      def encode_quoted_printable(text, charset)
        text = text.gsub( /[^a-z ]/i ) { quoted_printable_encode($&) }.
                    gsub( / /, "_" )
        "=?#{charset}?Q?#{text}?="
      end

      private

      # Convert the given character to quoted printable format, taking into
      # account multi-byte characters (if executing with $KCODE="u", for instance)
      def quoted_printable_encode(character)
        result = ""
        character.each_byte { |b| result << "=%02X" % b }
        result
      end
      
    end
    
    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end