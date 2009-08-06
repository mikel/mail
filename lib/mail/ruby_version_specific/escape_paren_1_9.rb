# Escapes any parenthesis in a string that are unescaped this uses
# a Ruby 1.9.1 regexp feature of negative look behind
def escape_paren( str )
  re = /(?<!\\)([\(\)])/          # Only match unescaped parens
  str.gsub(re) { |s| '\\' + s }
end
