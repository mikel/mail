# encoding: utf-8
module Mail
  module Encodings
    class EightBit < Binary
      NAME = '8bit'

      PRIORITY = 4

      # 8bit is an identiy encoding, meaning nothing to do
      
      # Decode the string
      def self.decode(str)
        str.to_crlf
      end
    
      # Encode the string
      def self.encode(str)
        str.to_crlf
      end
     
      Encodings.register(NAME, self) 
    end
  end
end
