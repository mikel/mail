module Mail
  module Encodings
    class UnixToUnix
      NAMES = ["uuencode", "x-uuencode"]

      def self.decode(str)
        str.sub(/\Abegin \d+ [^\n]*\n/, '').unpack('u').first
      end

      def self.encode(str)
        [str].pack("u")
      end

      NAMES.each do |used_name|
        Encodings.register(used_name, self)
      end
    end
  end
end
