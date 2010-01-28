module Mail
  class AttachmentsList < Array
    
    def initialize(parts_list)
      @parts_list = parts_list
      parts_list.map { |p|
        if p.parts.empty?
          p if p.attachment?
        else
          p.attachments
        end
      }.flatten.compact.each { |a| self << a }
      self
    end
    
    # Returns the attachment by filename or at index.
    # 
    # mail.attachments['test.png'] = File.read('test.png')
    # mail.attachments['test.jpg'] = File.read('test.jpg')
    # 
    # mail.attachments['test.png'].filename #=> 'test.png'
    # mail.attachments[1].filename          #=> 'test.jpg'
    def [](index_value)
      if index_value.is_a?(Fixnum)
        self.fetch(index_value)
      else
        self.select { |a| a.filename == index_value }.first
      end
    end

    def []=(name, value)
      default_values = { :content_type => "#{set_mime_type(name)}; filename=\"#{name}\"",
                         :content_transfer_encoding => 'Base64',
                         :content_disposition => "attachment; filename=\"#{name}\"" }

      if value.is_a?(Hash)

        default_values[:body] = value.delete(:content) if value[:content]

        default_values[:body] = value.delete(:data) if value[:data]

        # Only force encode base64 if the user has not specified an encoding
        if value[:transfer_encoding]
          default_values[:content_transfer_encoding] = value.delete(:transfer_encoding)
        elsif value[:encoding]
          default_values[:content_transfer_encoding] = value.delete(:encoding)
        else
          default_values[:body] = Mail::Encodings::Base64.encode(default_values[:body])
        end

        if value[:mime_type]
          default_values[:content_type] = value.delete(:mime_type)
        end

        hash = default_values.merge(value)
      else
        default_values[:body] = Mail::Encodings::Base64.encode(value)
        hash = default_values
      end

      @parts_list << Part.new(hash)
    end
    
    def set_mime_type(filename)
      # Have to do this because MIME::Types is not Ruby 1.9 safe yet
      if RUBY_VERSION >= '1.9'
        new_file = String.new(filename).force_encoding(Encoding::BINARY)
        ext = new_file.split('.'.force_encoding(Encoding::BINARY)).last
        filename = "file.#{ext}".force_encoding('US-ASCII')
      end
      @mime_type = MIME::Types.type_for(filename).first
    end
    
  end
end

