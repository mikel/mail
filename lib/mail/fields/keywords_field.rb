# encoding: utf-8
# 
# keywords        =       "Keywords:" phrase *("," phrase) CRLF
module Mail
  class KeywordsField < StructuredField
    
    FIELD_NAME = 'keywords'
    CAPITALIZED_FIELD = 'Keywords'
    
    def initialize(*args)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
      self.parse
      self
    end

    def parse(val = value)
      unless val.blank?
        @phrase_list ||= PhraseList.new(value)
      end
    end
    
    def phrase_list
      @phrase_list ||= PhraseList.new(value)
    end
      
    def keywords
      phrase_list.phrases
    end
    
    def encoded
      "#{CAPITALIZED_FIELD}: #{keywords.join(', ')}\r\n"
    end
    
    def decoded
      keywords.join(', ')
    end

    def default
      keywords
    end
    
  end
end
