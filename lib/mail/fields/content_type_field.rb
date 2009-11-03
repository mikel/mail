# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTypeField < StructuredField
    
    FIELD_NAME = 'content-type'

    def initialize(*args)
      if args.last.class == Array
        @main_type = args.last[0]
        @sub_type = args.last[1]
        @parameters = args.last.last
        super(FIELD_NAME, args.last)
      else
        @main_type = nil
        @sub_type = nil
        @parameters = nil
        super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
      end
    end
    
    def tree
      @element ||= Mail::ContentTypeElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= Mail::ContentTypeElement.new(value)
    end
    
    def main_type
      @main_type ||= element.main_type
    end

    def sub_type
      @sub_type ||= element.sub_type
    end
    
    def content_type
      "#{main_type}/#{sub_type}"
    end
    
    def parameters
      unless @parameters
        @parameters = ParameterHash.new
        element.parameters.each { |p| @parameters.merge!(p) }
      end
      @parameters
    end

    def ContentTypeField.with_boundary(type)
      new("#{type}; boundary=#{generate_boundary}")
    end
    
    def ContentTypeField.generate_boundary
      "--==_mimepart_#{Mail.random_tag}"
    end

    def value
      if @value.class == Array
        "#{@main_type}/#{@sub_type}; #{stringify(parameters)}"
      else
        @value
      end
    end
    
    def stringify(params)
      params.map { |k,v| "#{k}=#{v}" }.join("; ")
    end

    def filename
      case
      when parameters['filename']
        @filename = parameters['filename']
      when parameters['name']
        @filename = parameters['name']
      else 
        @filename = nil
      end
      @filename
    end

  end
end
