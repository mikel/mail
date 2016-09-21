# frozen_string_literal: true
require 'mail/parsers/content_location_machine'
require 'mail/utilities'

module Mail::Parsers
  class ContentLocationParser
    ContentLocationStruct = Struct.new(:location, :error)

    def parse(s)
      content_location = ContentLocationStruct.new(nil)
      if Mail::Utilities.blank?(s)
        return content_location
      end

      actions, error = ContentLocationMachine.parse(s)
      if error
        raise Mail::Field::ParseError.new(Mail::ContentLocationElement, s, error)
      end

      qstr_s = token_string_s = nil
      actions.each_slice(2) do |action_id, p|
        action = Mail::Parsers::ACTIONS[action_id]
        case action

        # Quoted String.
        when :qstr_s then qstr_s = p
        when :qstr_e then content_location.location = s[qstr_s..(p-1)]

        # Token String
        when :token_string_s then token_string_s = p
        when :token_string_e
          content_location.location = s[token_string_s..(p-1)]

        else
          raise Mail::Field::ParseError.new(Mail::ContentLocationElement, s, "Failed to process unknown action: #{action}")
        end
      end
      content_location
    end
  end
end
