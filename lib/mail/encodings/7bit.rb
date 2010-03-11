# encoding: utf-8
require '8bit'

module Mail
  module Encodings
    class SevenBit < EightBit
      NAME = '7bit'
    
      PRIORITY = 1

      # 7bit is an identiy encoding, meaning nothing to do
      
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
