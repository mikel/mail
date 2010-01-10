# encoding: utf-8
module Mail
  # An attachment is any data you want to attach to a mail message that is
  # not part of the body and can be extracted to a file in it's own right
  # 
  # This includes images, sound files, text files, documents, anything really,
  # the only requisite is that it has a file name and an encoding.
  # 
  # If you do not pass in an encoding when creating a new attachment, then
  # Mail::Attachment will assume that the data you pass in is raw data and
  # encode it with base64.
  # 
  # If you pass in an encoding, Mail::Attachment will assume that the data
  # is encoded data and attempt to decode the data string with the encoding
  # you supply.
  # 
  # So, raw data should be given in with no encoding, pre encoded data should
  # be given with an encoding type.
  # 
  # Attachment will always encode with Base64, it's safe, it works, maybe in
  # the future we will allow you to encode with different types.  If you really
  # want to encode with a different encoder, then pre encode the data and pass
  # it in with an encoding.  Mail::Attachment will happily initialize for you,
  # however, if it doesn't understand the encoding, it will not decode for you
  # and raise an error, but if you can encode it, we assume you know how to
  # decode it, so just get back the encoded source (with #encoded) and then
  # decode at your leisure.
  class Attachment
    
    include Utilities
    
    # Raised when attempting to decode an unknown encoding type
    class UnknownEncodingType < StandardError #:nodoc:
    end
    
    def initialize(options_hash)
      case
      when options_hash[:data]
        if options_hash[:filename].respond_to?(:force_encoding)
          encoding = options_hash[:filename].encoding
          filename = File.basename(options_hash[:filename].force_encoding(Encoding::BINARY))
          @filename = filename.force_encoding(encoding)
        else
          @filename = File.basename(options_hash[:filename])
        end
        
        add_file(options_hash[:data], options_hash[:encoding])
      when options_hash[:filename]
        @filename = File.basename(options_hash[:filename])
        data = File.read(options_hash[:filename])
        add_file(data, options_hash[:encoding])
      end
      set_mime_type(@filename, options_hash[:mime_type])
    end
    
    def filename
      @filename
    end

    alias :original_filename :filename

    def encoded
      @encoded_data
    end
    
    def decoded
      if Mail::Encodings.defined?(@encoding)
        Mail::Encodings.get_encoding(@encoding).decode(@encoded_data)
      else
        raise UnknownEncodingType, "Don't know how to decode #{@encoding}, please call #encoded and decode it yourself."
      end
    end
    
    alias :read :decoded
    
    def mime_type
      @mime_type.to_s
    end
    
    private
    
    def set_mime_type(filename, mime_type)
      unless mime_type
        # Have to do this because MIME::Types is not Ruby 1.9 safe yet
        if RUBY_VERSION >= '1.9'
          new_file = String.new(filename).force_encoding(Encoding::BINARY)
          ext = new_file.split('.'.force_encoding(Encoding::BINARY)).last
          filename = "file.#{ext}".force_encoding('US-ASCII')
        end
        @mime_type = MIME::Types.type_for(filename).first
      else
        @mime_type = mime_type
      end
    end
    
    def add_file(data, encoding)
      if encoding # We are being given encoded data
        @encoded_data = data
        @encoding = encoding.to_s
      else # this is raw data
        @encoded_data = Mail::Encodings::Base64.encode(data)
        @encoding = 'base64'
      end
    end
    
  end
end
