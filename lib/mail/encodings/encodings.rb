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
    
  end
end