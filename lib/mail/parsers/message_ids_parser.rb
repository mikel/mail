# frozen_string_literal: true
require 'mail/parsers/message_ids_machine'
require 'mail/utilities'

module Mail::Parsers
  class MessageIdsParser
    MessageIdsStruct = Struct.new(:message_ids, :error)

    def parse(s)
      if Mail::Utilities.blank?(s)
        return MessageIdsStruct.new
      end

      message_ids = MessageIdsStruct.new([])

      actions, error = MessageIdsMachine.parse(s)
      if error
        raise Mail::Field::ParseError.new(Mail::MessageIdsElement, s, error)
      end

      msg_id_s = nil
      actions.each_slice(2) do |action_id, p|
        action = Mail::Parsers::ACTIONS[action_id]
        case action

        # Message Ids
        when :msg_id_s then msg_id_s = p
        when :msg_id_e
          message_ids.message_ids << s[msg_id_s..(p-1)].rstrip

        when :domain_e, :domain_s, :local_dot_atom_e,
          :local_dot_atom_pre_comment_e,
          :local_dot_atom_pre_comment_s,
          :local_dot_atom_s

          # ignored actions

        else
          raise Mail::Field::ParseError.new(Mail::MessageIdsElement, s, "Failed to process unknown action: #{action}")
        end
      end
      message_ids
    end
  end
end
