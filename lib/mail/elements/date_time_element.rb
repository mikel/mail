# encoding: utf-8
module Mail
  class DateTimeElement
    
    include Mail::Utilities
    
    def initialize( string )
      parser = Mail::DateTimeParser.new
      if tree = parser.parse(string)
        @date = tree.date.text_value
        @time = tree.time.text_value
      else
        raise Mail::Field::ParseError, "Can not parse |#{string}|\nReason was: #{parser.failure_reason}\n"
      end
    end
    
    def date
      @date
    end
    
    def time
      @time
    end
    
  end
end
