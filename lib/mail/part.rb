# encoding: utf-8
module Mail
  class Part < Message
    
    def initialize(*args, &block)
      if args.flatten[0].is_a?(Hash)
        options_hash = args.flatten[0]
        super('') # Make an empty message, we are dealing with an attachment
        @attachment = Mail::Attachment.new(options_hash)
        self.content_type = "#{attachment.mime_type}; filename=\"#{attachment.filename}\""
        self.content_transfer_encoding = "Base64"
        self.content_disposition = "attachment; filename=\"#{attachment.filename}\""
        self.body = attachment.encoded
      else
        super
        if filename = attachment?
          encoding = content_transfer_encoding.encoding if content_transfer_encoding
          @attachment = Mail::Attachment.new(:filename => filename,
                                             :data => body.to_s,
                                             :encoding => encoding)
        end
      end
    end
    
    # Creates a new empty Content-ID field and inserts it in the correct order
    # into the Header.  The ContentIdField object will automatically generate
    # a unique content ID if you try and encode it or output it to_s without
    # specifying a content id.
    # 
    # It will preserve the content ID you specify if you do.
    def add_content_id(content_id_val = '')
      header['content-id'] = content_id_val
    end
    
    # Returns true if this part is an attachment
    def attachment?
      find_attachment
    end
    
    # Returns the attachment data if there is any
    def attachment
      @attachment
    end
    
    # Returns the filename of the attachment
    def filename
      if attachment?
        attachment.filename
      else
        nil
      end
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

    # Returns the filename of the attachment (if it exists) or returns nil
    def find_attachment
      case
      when content_type && content_type.filename
        filename = content_type.filename
      when content_disposition && content_disposition.filename
        filename = content_disposition.filename
      when content_location && content_location.location
        filename = content_location.location
      else
        filename = nil
      end
      filename
    end

  end
  
end