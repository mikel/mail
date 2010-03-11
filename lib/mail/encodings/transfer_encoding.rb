# encoding: utf-8
module Mail
  module Encodings
    class TransferEncoding
      NAME = ''

      PRIORITY = -1

      def self.can_transport?(enc)
        enc = Encodings.get_name(enc)
        if Encodings.defined? enc
          Encodings.get_encoding(enc).new.is_a? self
        else
          false
        end
      end

      def self.can_encode?(enc)
        can_transport? enc 
      end

      def self.cost(str)
        raise "Unimplemented"
      end
    end
  end
end
