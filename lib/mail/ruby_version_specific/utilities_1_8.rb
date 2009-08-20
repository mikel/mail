module Mail
  class Ruby18

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

    def Ruby18.dquote( str ) #:nodoc:
      str = $1 if str =~ /^"(.*)?"$/
      # First remove all escaped double quotes:
      str = str.gsub(/\\"/, '"')
      # Then wrap and re-escape all double quotes
      '"' + str.gsub(/["]/n) {|s| '\\' + s } + '"'
    end

  end
end