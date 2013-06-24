module Mail
  module CharsetCodec
    @codecs = Hash.new { |h, k| h[k] = Base.new }

    def self.find(name)
      @codecs[downcase_if_responds(name)]
    end

    def self.register(name, codec)
      @codecs[downcase_if_responds(name)] = codec
    end

    def self.find_by_encoding_of(value)
      if(value.respond_to?(:encoding))
        find(value.encoding.to_s.downcase)
      else
        find(nil)
      end
    end

    def self.force_regexp_compatibility_if_needed(value)
      find_by_encoding_of(value).force_regexp_compatibility_on(value)
    end
  private
    def self.downcase_if_responds(key)
      if key.respond_to?(:downcase)
        key.downcase
      else
        key
      end
    end
  end
end
