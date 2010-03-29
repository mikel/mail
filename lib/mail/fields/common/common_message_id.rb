# encoding: utf-8
module Mail
  module CommonMessageId # :nodoc:
    def element
      @element ||= Mail::MessageIdsElement.new(value)
    end

    def parse(val = value)
      unless val.blank?
        @element = Mail::MessageIdsElement.new(val)
      else
        nil
      end
    end
    
    def message_id
      element.message_id
    end
    
    def message_ids
      element.message_ids
    end
    
    def default
      if message_ids.length == 1
        message_ids[0]
      else
        message_ids
      end
    end

    private
    
    def do_encode(field_name)
      %Q{#{field_name}: #{message_ids.map { |m| "<#{m}>" }.join(', ')}\r\n}
    end
    
    def do_decode
      "#{message_ids.map { |m| "<#{m}>" }.join(', ')}"
    end
    
  end
end
