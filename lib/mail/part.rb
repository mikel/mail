# encoding: utf-8
module Mail
  class Part < Message
    
    # Creates a new empty Content-ID field and inserts it in the correct order
    # into the Header.  The ContentIdField object will automatically generate
    # a unique content ID if you try and encode it or output it to_s without
    # specifying a content id.
    # 
    # It will preserve the content ID you specify if you do.
    def add_content_id(content_id_val = '')
      header['content-id'] = content_id_val
    end
    
    # Returns true if the part has a content ID field, the field may or may
    # not have a value, but the field exists or not.
    def has_content_id?
      header.has_content_id?
    end

    def add_required_fields
      add_content_id unless has_content_id?
      super
    end
    
    def delivery_status_report_part?
      main_type =~ /message/i && sub_type =~ /delivery-status/i
    end
    
    def delivery_status_data
      delivery_status_report_part? ? parse_delivery_status_report : {}
    end
    
    def bounced?
      (action =~ /failed/i)
    end
    
    def action
      delivery_status_data['action'].value
    end
    
    def final_recipient
      delivery_status_data['final-recipient'].value
    end
    
    def error_status
      delivery_status_data['status'].value
    end

    def diagnostic_code
      delivery_status_data['diagnostic-code'].value
    end
    
    def remote_mta
      delivery_status_data['remote-mta'].value
    end
    
    def retryable?
      !(error_status =~ /^5/)
    end

    private
    
    # A part may not have a header.... so, just init a body if no header
    def parse_message
      header_part, body_part = raw_source.split(/#{CRLF}#{WSP}*#{CRLF}/m, 2)
      if header_part =~ HEADER_LINE
        self.header = header_part
        self.body   = body_part
      else
        self.header = "Content-Type: text/plain\r\n"
        self.body   = header_part
      end
    end
    
    def parse_delivery_status_report
      @delivery_status_data ||= Header.new(body.to_s.gsub("\r\n\r\n", "\r\n"))
    end

  end
  
end