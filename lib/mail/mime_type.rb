module Mail
  # Each MimeType instance just stores the content type related to it.  There are
  # two MimeType classes used, MimeType and MimeType::Binary.  MimeType is used for
  # storing text/7bit content types, while MimeType::Binary is used for storing binary
  # content types.
  class MimeType 
    MEDIA_TYPE_RE     = %r{([-\w.+]+)/([-\w.+]*)}o
    UNREGISTERED_RE   = %r{[Xx]-}o

    # Return the MimeType instance for the matching content type, or nil if there
    # is no MimeType for that content type.
    def self.[](content_type)
      if md = MEDIA_TYPE_RE.match(content_type)
        content_type = md.captures.map{|e| e.downcase.gsub(UNREGISTERED_RE, '')}.join('/')
        @type_variants[content_type]
      end
    end

    # Return the MimeType instance based on the filename, using the file's extension....
    # If there is no MimeType for that file extension, return nil.
    def self.type_for(filename)
      @extension_index[filename.chomp.downcase[/\.?([^.]*?)$/, 1]]
    end

    # Store the content type.
    def initialize(type)
      @type = type
    end

    # Return the content type for this MimeType as a string.
    def to_s
      @type
    end

    # Return false, since all instances of MimeType have a text/7bit content type.
    def binary?
      false
    end

    # Subclass of MimeType used for binary content types.
    class Binary < self
      # Return true, since all instances of MimeType::Binary have a binary content type.
      def binary?
        true
      end
    end
  end
end

require 'mail/mime_type/cache'
