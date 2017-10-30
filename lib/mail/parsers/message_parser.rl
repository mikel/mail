# frozen_string_literal: true
require 'mail/utilities'
require 'mail/parser_tools'
%%{
  machine message;
  alphtype int;

  # Junk actions
  action phrase_s { }
  action phrase_e { }
  action qstr_s { }
  action qstr_e { }
  action comment_s { }
  action comment_e { }
  action group_name_s { }
  action group_name_e { }
  action address_s { }
  action address_e { }
  action angle_addr_s { }
  action domain_s { }
  action domain_e { }
  action local_dot_atom_s { }
  action local_dot_atom_e { }
  action local_dot_atom_pre_comment_e { }
  action local_quoted_string_e { }
  action obs_domain_list_s { }
  action obs_domain_list_e { }
  action addr_spec { }
  action ctime_date_e { }
  action ctime_date_s { }
  action date_e { }
  action date_s { }
  action disp_type_e { }
  action disp_type_s { }
  action encoding_e { }
  action encoding_s { }
  action main_type_e { }
  action main_type_s { }
  action major_digits_e { }
  action major_digits_s { }
  action minor_digits_e { }
  action minor_digits_s { }
  action msg_id_e { }
  action msg_id_s { }
  action param_attr_e { }
  action param_attr_s { }
  action param_val_e { }
  action param_val_s { }
  action received_tokens_e { }
  action received_tokens_s { }
  action sub_type_e { }
  action sub_type_s { }
  action time_e { }
  action time_s { }
  action token_string_e { }
  action token_string_s { }

  include rfc5322_message "rfc5322_message.rl";


  action mark {
    raise 'already marked' if defined?(mark) && mark
    mark = p
  }

  action field_name {
    raise 'wtf' unless defined?(mark) && mark
    field_name = chars(data, mark, p-1)
    mark = nil
  }

  action field_value {
    raise 'wtf' unless defined?(mark) && mark
    field_value = chars(data, mark, p-1)
    mark = nil
    fields << [ field_name, field_value ]
  }

  action message_body {
    raise 'wtf' unless defined?(mark) && mark
    body = chars(data, mark, p-1)
    mark = nil
  }

  unparsed_field = field_name >mark %field_name WSP* ":" unstructured >mark %field_value CRLF;
  main := unparsed_field* (CRLF obs_body >mark %message_body)?;
}%%

module Mail::Parsers
  module MessageParser
    extend Mail::ParserTools

    %%write data noprefix;

    def self.parse(data)
      data = data.dup.force_encoding(Encoding::ASCII_8BIT) if data.respond_to?(:force_encoding)

      fields = []
      body = ''

      # 5.1 Variables Used by Ragel
      p = 0
      eof = pe = data.length
      stack = []

      %%write init;
      %%write exec;

      if p != eof || cs < %%{ write first_final; }%%
        raise Mail::Field::IncompleteParseError.new(Mail, data, p)
      end

      [ fields, body ]
    end
  end
end
