module Mail
  class Ruby18
    require 'base64'

    # Escapes any parenthesis in a string that are unescaped. This can't
    # use the Ruby 1.9.1 regexp feature of negative look behind so we have
    # to do two replacement, first unescape everything, then re-escape it
    def Ruby18.escape_paren( str )
      re = /\\\)/
      str = str.gsub(re) { |s| ')'}
      re = /\\\(/
      str = str.gsub(re) { |s| '('}
      re = /([\(\)])/          # Only match unescaped parens
      str.gsub(re) { |s| '\\' + s }
    end
    
    def Ruby18.paren( str )
      str = $1 if str =~ /^\((.*)?\)$/
      str = escape_paren( str )
      '(' + str + ')'
    end
    
    def Ruby18.decode_base64(str)
      Base64.decode64(str)
    end
    
    def Ruby18.encode_base64(str)
      Base64.encode64(str)
    end
    
    def Ruby18.has_constant?(klass, string)
      klass.constants.include?( string )
    end
    
    def Ruby18.get_constant(klass, string)
      klass.const_get( string )
    end

    def Ruby18.b_encode(str, encoding)
      # Ruby 1.8 requires an encoding to work
      raise ArgumentError, "Must supply an encoding" if encoding.nil?
      return str if str.ascii_only?
      encoding = encoding.to_s.upcase.gsub('_', '-')
      string = Encodings::Base64.encode(str)
      "=?#{encoding}?B?#{string.chomp}?="
    end

    def Ruby18.q_encode(str, encoding)
      # Ruby 1.8 requires an encoding to work
      raise ArgumentError, "Must supply an encoding" if encoding.nil?
      return str if str.ascii_only?
      encoding = encoding.to_s.upcase.gsub('_', '-')
      string = Encodings::QuotedPrintable.encode(str)
      "=?#{encoding}?Q?#{string.chomp}?="
    end

  end
  
  
end