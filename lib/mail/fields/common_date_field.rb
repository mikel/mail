require 'mail/utilities'

module Mail
  class CommonDateField < NamedStructuredField #:nodoc:
    class << self
      def singular?
        true
      end

      def normalize_datetime(string)
        if Utilities.blank?(string)
          datetime = ::DateTime.now
        else
          stripped = string.to_s.gsub(/\(.*?\)/, '').squeeze(' ')
          datetime = Utilities.parse_date_time(stripped)
        end

        if datetime
          datetime.strftime('%a, %d %b %Y %H:%M:%S %z')
        else
          string
        end
      end
    end

    def initialize(value = nil, charset = nil)
      super self.class.normalize_datetime(value), charset
    end

    # Returns a date time object of the parsed date
    def date_time
      Utilities.parse_date_time("#{element.date_string} #{element.time_string}")
    end

    def default
      date_time
    end

    def element
      @element ||= Mail::DateTimeElement.new(value)
    end

    private
      def do_encode
        "#{name}: #{value}\r\n"
      end

      def do_decode
        value.to_s
      end
  end
end
