module Mail
  class Address
    
    include Mail::Utilities
    
    def initialize(value = nil)
      case 
      when nil
        return
      when value.class == String
        self.tree = Mail::AddressList.new(value).address_nodes.first
      else
        self.tree = value
      end
    end
    
    def tree=(value)
      @tree = value
    end
    
    def tree
      @tree
    end
    
    def raw
      tree.text_value
    end
    
    def format
      if display_name
        [quote_phrase(display_name), "<#{address}>", format_comments].compact.join(" ")
      else
        [address, format_comments].compact.join(" ")
      end
    end
    
    def format_comments
      if comments
        comment_text = comments.map {|c| escape_paren(c) }.join(' ').squeeze(" ")
        @format_comments ||= "(#{comment_text})"
      else
        nil
      end
    end

    def local
      get_local
    end
    
    def get_local
      if tree.respond_to?(:local_dot_atom_text)
        tree.local_dot_atom_text.text_value.strip
      elsif tree.respond_to?(:angle_addr)
        tree.angle_addr.addr_spec.local_part.text_value.strip
      elsif tree.respond_to?(:addr_spec)
        tree.addr_spec.local_part.text_value.strip
      else
        tree.local_part.text_value.strip
      end
    end
    
    def domain
      strip_all_comments(get_domain) if get_domain
    end
    
    def get_domain
      if tree.respond_to?(:angle_addr)
        @domain_text ||= tree.angle_addr.addr_spec.domain.text_value.strip
      elsif tree.respond_to?(:domain)
        @domain_text ||= tree.domain.text_value.strip
      elsif tree.respond_to?(:addr_spec)
        tree.addr_spec.domain.text_value.strip
      else
        nil
      end
    end

    def strip_all_comments(string)
      unless comments.blank?
        comments.each do |comment|
          string = string.gsub("(#{comment})", '')
        end
      end
      string.strip
    end

    def strip_domain_comments(value)
      unless comments.blank?
        comments.each do |comment|
          if get_domain && get_domain.include?("(#{comment})")
            value = value.gsub("(#{comment})", '')
          end
        end
      end
      value.to_s.strip
    end
    
    def address
      domain ? "#{local}@#{domain}" : local
    end
    
    def address=(value)
      self.tree = Mail::AddressList.new(value).address_nodes.first
    end
    
    def comments
      if get_comments.empty?
        nil
      else
        get_comments.map { |c| c.squeeze(" ") }
      end
    end
    
    def get_comments
      if tree.respond_to?(:comments)
        @comments ||= tree.comments.map { |c| unparen(c.text_value) } 
      else
        @comments = []
      end
    end
    
    def display_name
      @display_name ||= get_display_name
    end
    
    def display_name=(value)
      @display_name = value
    end
    
    def get_display_name
      if tree.respond_to?(:display_name)
        name = unquote(tree.display_name.text_value.strip)
        str = strip_all_comments(name)
      elsif comments
        if domain
          str = strip_domain_comments(format_comments)
        else
          str = nil
        end
      else
        nil
      end
      
      if str.blank?
        nil
      else
        str
      end
    end
    
    def name
      get_name
    end
    
    def get_name
      if display_name
        str = display_name
      else
        if comments
          comment_text = comments.join(' ').squeeze(" ")
          str = "(#{comment_text})"
        end
      end

      if str.blank?
        nil
      else
        unparen(str)
      end
    end
    
    def to_s
      format
    end
    
    def inspect
      "#<#{self.class}:#{self.object_id} Address: |#{to_s}| >"
    end
    
  end
end