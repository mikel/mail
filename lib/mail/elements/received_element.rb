# encoding: utf-8
module Mail
  class ReceivedElement
    
    include Mail::Utilities
    
    def initialize( string )
      tree = Mail::ReceivedParser.new.parse(string)
      if tree
        @date_time = ::DateTime.parse("#{tree.date_time.date.text_value} #{tree.date_time.time.text_value}")
        @info = tree.name_val_list.text_value
      else
        raise Mail::Field::ParseError, "Can not parse |#{string}|\nReason was: #{parser.failure_reason}\n"
      end
    end
    
    def date_time
      @date_time
    end
    
    def info
      @info
    end
    
    def to_s(*args)
      "#{@info}; #{@date_time.to_s(*args)}"
    end
    
  end
end
