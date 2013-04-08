# encoding: utf-8
# 
# subject         =       "Subject:" unstructured CRLF
module Mail
  class SubjectField < UnstructuredField
    
    FIELD_NAME = 'subject'
    CAPITALIZED_FIELD = "Subject"
    
    def initialize(value = nil, charset = 'utf-8')
      if charset.to_s.downcase == 'iso-2022-jp'
        if value.kind_of?(Array)
          value = value.map { |e| RubyVer.encode_with_iso_2022_jp(e) }
        else
          value = RubyVer.encode_with_iso_2022_jp(value)
        end
      end
      self.charset = charset
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, value), charset)
    end
    
    private
    def encode_crlf(value)
      if charset.to_s.downcase == 'iso-2022-jp' && value.respond_to?(:force_encoding)
        value.force_encoding('ascii-8bit')
      end
      super(value)
    end
  end
end
