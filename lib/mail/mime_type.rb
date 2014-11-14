module Mail
  class MimeType 
    MEDIA_TYPE_RE     = %r{([-\w.+]+)/([-\w.+]*)}o
    UNREGISTERED_RE   = %r{[Xx]-}o

    def self.[](content_type)
      if md = MEDIA_TYPE_RE.match(content_type)
        content_type = md.captures.map{|e| e.downcase.gsub(UNREGISTERED_RE, '')}.join('/')
        @type_variants[content_type]
      end
    end

    def self.type_for(filename)
      @extension_index[filename.chomp.downcase[/\.?([^.]*?)$/, 1]]
    end

    def initialize(type)
      @type = type
    end

    def to_s
      @type
    end

    def binary?
      false
    end

    class Binary < self
      def binary?
        true
      end
    end
  end
end

require 'mail/mime_type_cache'

