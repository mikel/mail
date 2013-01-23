# encoding: utf-8
module Mail
  module CommonField # :nodoc:

    def name=(value)
      @name = value
    end

    def name
      @name ||= nil
    end

    def value=(value)
      @length = nil
      @tree = nil
      @element = nil
      @value = value
    end

    def value
      @value
    end

    def to_s
      decoded
    end

    def default
      decoded
    end

    def field_length
      @length ||= "#{name}: #{encode(decoded)}".length
    end

    def responsible_for?( val )
      name.to_s.casecmp(val.to_s) == 0
    end

    private

    def strip_field(field_name, value)
      if value.is_a?(Array)
        value
      else
        value.to_s.gsub(/#{field_name}:\s+/i, '')
      end
    end

    WORD_CHAR_WITHOUT_QUOTE = '[\w[^"]]'
    WORD_WITHOUT_QUOTE = "#{WORD_CHAR_WITHOUT_QUOTE}+?"
    WORD_WITHOUT_QUOTE_FOLLOWED_BY_WSP = "#{WORD_WITHOUT_QUOTE}\\s+?"
    PARAM_ENDING = '(\r|\z)'
    FILENAME_RE = /\s((filename|name)=((#{WORD_WITHOUT_QUOTE_FOLLOWED_BY_WSP})+?(#{WORD_CHAR_WITHOUT_QUOTE})*?))#{PARAM_ENDING}/

    def ensure_filename_quoted(value)
      if value && !value.is_a?(Array) && matches = value.match(FILENAME_RE)
        value.sub!(matches[1], "#{matches[2]}=\"#{matches[3]}\"")
      end
    end
  end
end
