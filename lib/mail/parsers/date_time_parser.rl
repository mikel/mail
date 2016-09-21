# frozen_string_literal: true
require 'mail/utilities'

%%{
  machine date_time;

  # Date
  action date_s { date_s = p }
  action date_e { date_time.date_string = data[date_s..(p-1)] }

  # Time
  action time_s { time_s = p }
  action time_e { date_time.time_string = data[time_s..(p-1)] }

  # No-op actions
  action comment_s {}
  action comment_e {}
  action phrase_s {}
  action phrase_e {}
  action qstr_s {}
  action qstr_e {}

  include rfc5322_date_time "rfc5322_date_time.rl";
  main := date_time;
}%%

module Mail::Parsers
  module DateTimeParser
    DateTimeStruct = Struct.new(:date_string, :time_string, :error)

    %%write data noprefix;

    def self.parse(data)
      raise Mail::Field::ParseError.new(Mail::DateTimeElement, data, "nil is an invalid DateTime") if data.nil?

      date_time = DateTimeStruct.new([])

      # Parser state
      date_s = time_s = nil

      # 5.1 Variables Used by Ragel
      p = 0
      eof = pe = data.length
      stack = []

      %%write init;
      %%write exec;

      if p != eof || cs < %%{ write first_final; }%%
        raise Mail::Field::ParseError.new(Mail::DateTimeElement, data, "Only able to parse up to #{data[0..p]}")
      end

      date_time
    end
  end
end
