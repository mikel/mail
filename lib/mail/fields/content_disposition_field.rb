# encoding: utf-8
require 'mail/fields/common/parameter_hash'
require 'mail/fields/common/common_content'

module Mail
  class ContentDispositionField < StructuredField

    include Mail::CommonContent
    
    FIELD_NAME = 'content-disposition'
    CAPITALIZED_FIELD = 'Content-Disposition'
    
    def initialize(value = nil, charset = 'utf-8')
      self.charset = charset
      ensure_filename_quoted(value)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, value), charset)
      self.parse
      self
    end
    
    def parse(val = value)
      unless val.blank?
        @element = Mail::ContentDispositionElement.new(val)
      end
    end
    
    def element
      @element ||= Mail::ContentDispositionElement.new(value)
    end

    def disposition_type
      element.disposition_type
    end

    private

    def decode_encode_field
      disposition_type
    end
    
  end
end
