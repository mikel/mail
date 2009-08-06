# Escapes any parenthesis in a string that are unescaped. This can't
# use the Ruby 1.9.1 regexp feature of negative look behind so we have
# to do two replacement, first unescape everything, then re-escape it
def escape_paren( str )
  re = /\\\)/
  str = str.gsub(re) { |s| ')'}
  re = /\\\(/
  str = str.gsub(re) { |s| '('}
  re = /([\(\)])/          # Only match unescaped parens
  str.gsub(re) { |s| '\\' + s }
end
