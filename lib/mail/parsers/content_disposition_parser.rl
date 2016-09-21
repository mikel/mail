# frozen_string_literal: true
require 'mail/utilities'

%%{
  machine content_disposition;

  # Disposition Type
  action disp_type_s { disp_type_s = p }
  action disp_type_e { content_disposition.disposition_type = data[disp_type_s..(p-1)].downcase }

  # Parameter Attribute
  action param_attr_s { param_attr_s = p }
  action param_attr_e { param_attr = data[param_attr_s..(p-1)] }

  # Quoted String
  action qstr_s { qstr_s = p }
  action qstr_e { qstr = data[qstr_s..(p-1)] }

  # Parameter Value
  action param_val_s { param_val_s = p }
  action param_val_e {
    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  }

  # No-op actions
  action comment_e { }
  action comment_s { }
  action phrase_e { }
  action phrase_s { }
  action main_type_e { }
  action main_type_s { }
  action sub_type_e { }
  action sub_type_s { }

  include rfc2183_content_disposition "rfc2183_content_disposition.rl";
  main := disposition;
}%%

module Mail::Parsers
  module ContentDispositionParser
    ContentDispositionStruct = Struct.new(:disposition_type, :parameters, :error)

    %%write data noprefix;

    def self.parse(data)
      content_disposition = ContentDispositionStruct.new('', [])
      return content_disposition if Mail::Utilities.blank?(data)

      # Parser state
      disp_type_s = param_attr_s = param_attr = qstr_s = qstr = param_val_s = nil

      # 5.1 Variables Used by Ragel
      p = 0
      eof = pe = data.length
      stack = []

      %%write init;
      %%write exec;

      if p != eof || cs < %%{ write first_final; }%%
        raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "Only able to parse up to #{data[0..p]}")
      end

      content_disposition
    end
  end
end
