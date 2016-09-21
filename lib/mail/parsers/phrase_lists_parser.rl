# frozen_string_literal: true
require 'mail/utilities'

%%{
  machine date_time;

  # Phrase
  action phrase_s { phrase_s = p }
  action phrase_e {
    phrase_lists.phrases << data[phrase_s..(p-1)] if phrase_s
    phrase_s = nil
  }

  # No-op actions
  action address_s {}
  action address_e {}
  action angle_addr_s {}
  action ctime_date_s {}
  action ctime_date_e {}
  action comment_e {}
  action comment_s {}
  action domain_e {}
  action domain_s {}
  action local_dot_atom_e {}
  action local_dot_atom_pre_comment_e {}
  action local_dot_atom_pre_comment_s {}
  action local_dot_atom_s {}
  action qstr_e {}
  action qstr_s {}
  action date_s {}
  action date_e {}
  action time_s {}
  action time_e {}
  action local_quoted_string_s {}
  action local_quoted_string_e {}
  action obs_domain_list_s {}
  action obs_domain_list_e {}
  action group_name_s {}
  action group_name_e {}
  action msg_id_s {}
  action msg_id_e {}
  action received_tokens_s {}
  action received_tokens_e {}

  include rfc5322 "rfc5322.rl";
  main := phrase_lists;
}%%

module Mail::Parsers
  class PhraseListsParser
    PhraseListsStruct = Struct.new(:phrases, :error)

    %%write data noprefix;

    def self.parse(data)
      raise Mail::Field::ParseError.new(Mail::PhraseList, data, 'nil is invalid') if data.nil?

      # Parser state
      phrase_lists = PhraseListsStruct.new([])
      phrase_s = nil

      # 5.1 Variables Used by Ragel
      p = 0
      eof = pe = data.length
      stack = []

      %%write init;
      %%write exec;

      if p != eof || cs < %%{ write first_final; }%%
        raise Mail::Field::ParseError.new(Mail::PhraseListsElement, data, "Only able to parse up to #{data[0..p]}")
      end

      phrase_lists
    end
  end
end
