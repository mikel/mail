# encoding: utf-8
# 
# keywords        =       "Keywords:" phrase *("," phrase) CRLF
module Mail
  class KeywordsField < StructuredField
    
    FIELD_NAME = 'keywords'
    
    def initialize(*args)
      super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
    end
    
    def phrase_list
      @phrase_list ||= PhraseList.new(value)
    end
      
    def keywords
      phrase_list.phrases
    end

  end
end
