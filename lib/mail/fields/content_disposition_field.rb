# encoding: utf-8
# 
# 
# 
module Mail
  class ContentDispositionField < StructuredField
    
    FIELD_NAME = 'content-disposition'
    CAPITALIZED_FIELD = 'Content-Disposition'
    
    def initialize(*args)
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
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
    
    def parameters
      @parameters = ParameterHash.new
      element.parameters.each { |p| @parameters.merge!(p) }
      @parameters
    end

    def filename
      case
      when !parameters['filename'].blank?
        @filename = parameters['filename']
      when !parameters['name'].blank?
        @filename = parameters['name']
      else 
        @filename = nil
      end
      @filename
    end

    # TODO: Fix this up
    def encoded
      "#{CAPITALIZED_FIELD}: #{value}\r\n"
    end
    
    def decoded
      value
    end

  end
end
