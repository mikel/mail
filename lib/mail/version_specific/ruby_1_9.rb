# encoding: utf-8
module Mail
  class Ruby19

    # Escapes any parenthesis in a string that are unescaped this uses
    # a Ruby 1.9.1 regexp feature of negative look behind
    def Ruby19.escape_paren( str )
      re = /(?<!\\)([\(\)])/          # Only match unescaped parens
      str.gsub(re) { |s| '\\' + s }
    end

    def Ruby19.paren( str )
      str = $1 if str =~ /^\((.*)?\)$/
      str = escape_paren( str )
      '(' + str + ')'
    end
    
    def Ruby19.decode_base64(str)
      str.unpack( 'm' ).first.force_encoding(Encoding::BINARY)
    end
    
    def Ruby19.encode_base64(str)
      [str].pack( 'm' )
    end
    
    def Ruby19.has_constant?(klass, string)
      klass.constants.include?( string.to_sym )
    end
    
    def Ruby19.get_constant(klass, string)
      klass.const_get( string.to_sym )
    end
    
    def Ruby19.b_value_encode(str, encoding = nil)
      encoding = str.encoding.to_s
      [Encodings::Base64.encode(str), encoding]
    end
    
    def Ruby19.q_value_encode(str, encoding = nil)
      encoding = str.encoding.to_s
      [Encodings::QuotedPrintable.encode(str), encoding]
    end

    def Ruby19.param_decode(str, encoding)
      string = URI.unescape(str)
      string.force_encoding(encoding) if encoding
      string
    end

  end
end