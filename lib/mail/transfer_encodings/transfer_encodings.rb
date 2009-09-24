module Mail
  module TransferEncodings
    
    def TransferEncodings.defined?( str )
      string = str.to_s.split(/[_-]/).map { |v| v.capitalize }.join('')
      RubyVer.has_constant?(Mail::TransferEncodings, string)
    end

    def TransferEncodings.get_encoding( str )
      string = str.to_s.split(/[_-]/).map { |v| v.capitalize }.join('')
      RubyVer.get_constant(Mail::TransferEncodings, string)
    end
    
  end
end