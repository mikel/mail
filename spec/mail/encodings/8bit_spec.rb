# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::Encodings::EightBit do
  describe ".compatible_input?" do
    def lines_check(str)
      !str.lines.find { |line| line.bytesize > 998 }
    end

    {
      "empty" => "",
      "997 bytes + LF" => "#{"a" * 997}\n",
      "998 bytes + LF" => "#{"a" * 998}\n",
      "996 bytes + CRLF" => "#{"a" * 996}\r\n",
      "997 bytes + CRLF" => "#{"a" * 997}\r\n",
      "998 bytes, no newline" => "a" * 998,
      "999 bytes, no newline" => "a" * 999,
      "long last line" => "short\n#{"a" * 999}",
      "long middle line" => "short\n#{"a" * 999}\nshort\n",
      "CR-only line breaks" => "#{"a" * 600}\r" * 2,
      "multibyte, 998 bytes" => "ł" * 499,
      "multibyte, 1000 bytes" => "ł" * 500,
      "invalid UTF-8" => ("\xFF" * 999).dup.force_encoding("UTF-8"),
      "invalid UTF-8 after LF" => "\n\x80".dup.force_encoding("UTF-8"),
      "invalid UTF-8 after CRLF" => "\r\n\x80".dup.force_encoding("UTF-8"),
      "invalid UTF-8 before LF" => "\x80\nshort".dup.force_encoding("UTF-8"),
      "long invalid UTF-8 line after LF" => "\n#{"\x80" * 999}".dup.force_encoding("UTF-8"),
      "binary" => ("a" * 999).b,
      "only newlines" => "\n" * 2000,
      "UTF-16LE, 600 characters per line" => "#{"a" * 600}\n#{"a" * 10}".encode("UTF-16LE"),
      "UTF-16LE, 400 characters per line" => "#{"a" * 400}\n#{"a" * 10}".encode("UTF-16LE")
    }.each do |label, input|
      it "matches a per-line byte check for #{label}" do
        expect(Mail::Encodings::EightBit.compatible_input?(input)).to eq lines_check(input)
      end
    end

    [nil, "", "\r"].each do |separator|
      context "with input record separator #{separator.inspect}" do
        around do |example|
          original_separator = $/
          $/ = separator
          example.run
        ensure
          $/ = original_separator
        end

        {
          "LF-separated lines" => "a\n" * 600,
          "CR-separated lines" => "#{"a" * 600}\r" * 2
        }.each do |label, input|
          it "matches a per-line byte check for #{label}" do
            expect(Mail::Encodings::EightBit.compatible_input?(input)).to eq lines_check(input)
          end
        end
      end
    end
  end
end
