# encoding: utf-8
module Mail
  module Encodings
    
    def Encodings.defined?( str )
      string = str.to_s.split(/[_-]/).map { |v| v.capitalize }.join('')
      RubyVer.has_constant?(Mail::Encodings, string)
    end
    
    def Encodings.get_encoding( str )
      string = str.to_s.split(/[_-]/).map { |v| v.capitalize }.join('')
      RubyVer.get_constant(Mail::Encodings, string)
    end
    
    def Encodings.b_encode(str, encoding = nil)
      RubyVer.b_encode(str, encoding)
    end
    
    def Encodings.q_encode(str, encoding = nil)
      RubyVer.q_encode(str, encoding)
    end
    
  end
end