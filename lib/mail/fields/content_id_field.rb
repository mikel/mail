# encoding: utf-8
# 
# 
# 
module Mail
  class ContentIdField < StructuredField
    
    FIELD_NAME = 'content-id'
    
    def initialize(*args)
      @uniq = 1
      if args.last.blank?
        self.name = FIELD_NAME
        self.value = generate_content_id
        self
      else
        super(FIELD_NAME, strip_field(FIELD_NAME, args.last))
      end
    end
    
    def tree
      @element ||= Mail::MessageIdsElement.new(value)
      @tree ||= @element.tree
    end
    
    def element
      @element ||= Mail::MessageIdsElement.new(value)
    end
    
    def name
      'Content-ID'
    end
    
    def content_id
      element.message_id
    end
    
    def to_s
      "<#{content_id}>"
    end
    
    private
    
    def generate_content_id
      fqdn = ::Socket.gethostname
      "<#{random_tag}@#{fqdn}.mail>"
    end
    
    def random_tag
      t = Time.now
      sprintf('%x%x_%x%x%d%x',
              t.to_i, t.tv_usec,
              $$, Thread.current.object_id, Mail.uniq, rand(255))
    end
    
    
  end
end
