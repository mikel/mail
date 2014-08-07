module Mail
  module CommonContent # :nodoc:
    def filename
      parameters['filename'] || parameters['name']
    end

    def encoded
      p = if parameters.length > 0
        ";\r\n\s#{parameters.encoded}\r\n"
      else
        "\r\n"
      end
      "#{self.class::CAPITALIZED_FIELD}: #{decode_encode_field}" + p
    end

    def decoded
      p = if parameters.length > 0
        "; #{parameters.decoded}"
      else
        ""
      end
      "#{decode_encode_field}" + p
    end

    def parameters
      @parameters ||= element.parameters.inject(ParameterHash.new) { |h,p| h.merge!(p) }
    end
  end
end
