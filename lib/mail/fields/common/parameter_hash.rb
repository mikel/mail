# encoding: utf-8
module Mail

  # ParameterHash is an intelligent Hash that allows you to add
  # parameter values including the MIME extension paramaters that
  # have the name*0="blah", name*1="bleh" keys, and will just return
  # a single key called name="blahbleh" and do any required un-encoding
  # to make that happen
  # Parameters are defined in RFC2045, split keys are in RFC2231

  class ParameterHash < HashWithIndifferentAccess

    include Mail::Utilities

    def [](key_name)
      pairs = select { |k,v| k =~ /^#{key_name}\*/ }
      pairs = pairs.to_a if RUBY_VERSION >= '1.9'
      if pairs.empty? # Just dealing with a single value pair
        super(key_name)
      else # Dealing with a multiple value pair or a single encoded value pair
        string = pairs.sort { |a,b| a.first <=> b.first }.map { |v| v.last }.join('')
        if mt = string.match(/([\w\d\-]+)'(\w\w)'(.*)/)
          string = mt[3]
          encoding = mt[1]
        else
          encoding = nil
        end
        Mail::Encodings.param_decode(string, encoding)
      end
    end

    def encoded
      map.sort { |a,b| a.first <=> b.first }.map do |key_name, value|
        unless value.ascii_only?
          value = Mail::Encodings.param_encode(value)
          key_name = "#{key_name}*"
        end
        %Q{#{key_name}=#{quote_token(value)}}
      end.join(";\r\n\s")
    end

    def decoded
      map.sort { |a,b| a.first <=> b.first }.map do |key_name, value|
        %Q{#{key_name}=#{quote_token(value)}}
      end.join("; ")
    end
  end
end
