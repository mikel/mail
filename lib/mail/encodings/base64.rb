# encoding: utf-8
module Mail
  module Encodings
    class Base64
      
      # Decode the string from Base64
      def self.decode(str)
        RubyVer.decode_base64( str )
      end
    
      # Encode the string to Base64
      def self.encode(str)
        RubyVer.encode_base64( str )
      end
      
    end
  end
end