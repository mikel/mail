# encoding: utf-8
module Mail
  module Encodings
    class Base64 < SevenBit
      NAME = 'base64'
     
      PRIORITY = 3
 
      def self.can_encode?(enc)
        true
      end

      # Decode the string from Base64
      def self.decode(str)
        RubyVer.decode_base64( str )
      end
    
      # Encode the string to Base64
      def self.encode(str)
        RubyVer.encode_base64( str )
      end

      Encodings.register(NAME, self)      
    end
  end
end
