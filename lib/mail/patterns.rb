module Mail
  module Patterns
    
    CRLF = Regexp.new("\r\n")
    WSP = Regexp.new("[\s\t]")
    FWS = Regexp.new("#{CRLF}#{WSP}")
    
  end
end