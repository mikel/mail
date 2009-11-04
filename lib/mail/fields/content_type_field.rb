# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTypeField < StructuredField
    
    FIELD_NAME = 'content-type'
    CAPITALIZED_FIELD = 'Content-Type'
    
    def initialize(*args)
      if args.last.class == Array
        @main_type = args.last[0]
        @sub_type = args.last[1]
        @parameters = ParameterHash.new.merge!(args.last.last)
        super(CAPITALIZED_FIELD, args.last)
      else
        @main_type = nil
        @sub_type = nil
        @parameters = nil
        super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, args.last))
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
      params.map { |k,v| "#{k}=#{Encodings.param_encode(v)}" }.join("; ")
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
    
    # TODO: Fix this up
    def encoded
      "#{CAPITALIZED_FIELD}: #{content_type};\r\n\t#{parameters.encoded};\r\n"
    end
    
    def decoded
      value
    end

    private
    
    def method_missing(name, *args, &block)
      if name.to_s =~ /([\w_]+)=/
        self.parameters[$1] = args.first
        @value = "#{content_type}; #{stringify(parameters)}"
      else
        super
      end
    end

  end
end
