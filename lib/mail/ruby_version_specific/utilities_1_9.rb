module Mail
  class Ruby19

    # Escapes any parenthesis in a string that are unescaped this uses
    # a Ruby 1.9.1 regexp feature of negative look behind
    def Ruby19.escape_paren( str )
      re = /(?<!\\)([\(\)])/          # Only match unescaped parens
      str.gsub(re) { |s| '\\' + s }
    end
    
    def Ruby19.dquote( str ) #:nodoc:
      re = /(?<!\\)(")/
      '"' + str.gsub(re) { |s| '\\' + s } + '"'
    end

  end
end