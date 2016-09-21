# frozen_string_literal: true
require 'mail/parsers/mime_version_machine'
require 'mail/utilities'

module Mail::Parsers
  class MimeVersionParser
    MimeVersionStruct = Struct.new(:major, :minor, :error)

    def parse(s)
      if Mail::Utilities.blank?(s)
        return MimeVersionStruct.new("", nil)
      end

      mime_version = MimeVersionStruct.new

      actions, error = MimeVersionMachine.parse(s)
      if error
        raise Mail::Field::ParseError.new(Mail::MimeVersionElement, s, error)
      end

      major_digits_s = minor_digits_s = nil
      actions.each_slice(2) do |action_id, p|
        action = Mail::Parsers::ACTIONS[action_id]
        case action

        # Major Digits
        when :major_digits_s then major_digits_s = p
        when :major_digits_e
          mime_version.major = s[major_digits_s..(p-1)]

        # Minor Digits
        when :minor_digits_s then minor_digits_s = p
        when :minor_digits_e
          mime_version.minor = s[minor_digits_s..(p-1)]

        when :comment_e, :comment_s then nil

        else
          raise Mail::Field::ParseError.new(Mail::MimeVersionElement, s, "Failed to process unknown action: #{action}")
        end
      end
      mime_version
    end
  end
end
