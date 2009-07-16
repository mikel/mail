module Mail
  class Address
    
    include Mail::Utilities
    
    def initialize(value)
      if value.class == String
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
    
    def format
      if display_name
        "#{quote_phrase(display_name)} <#{address}>#{format_comments}"
      else
        "#{address}#{format_comments}"
      end
    end
    
    def format_comments
      if comments
        " (#{comments.map {|c| escape_paren(c) }.join(' ').squeeze(" ")})"
      else
        nil
      end
    end

    def local
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
      if tree.respond_to?(:angle_addr)
        domain_text = tree.angle_addr.addr_spec.domain.text_value.strip
        strip_comments(domain_text)
      elsif tree.respond_to?(:domain)
        domain_text = tree.domain.text_value.strip
        strip_comments(domain_text)
      else
        nil
      end
    end

    def strip_comments(value)
      unless comments.blank?
        comments.each { |comment| value.gsub!("(#{comment})", '') }
      end
      value.strip
    end
    
    def address
      domain ? "#{local}@#{domain}" : local
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
        @comments ||= tree.comments.map { |c| strip_parens(c.text_value) } 
      else
        @comments = []
      end
    end
    
    def strip_parens(text)
      text.gsub(/^\(/, '').gsub(/\)$/, '')
    end
    
    def display_name
      if tree.respond_to?(:display_name)
        name = unquote(tree.display_name.text_value.strip)
        strip_comments(name)
      else
        nil
      end
    end
    
    def name
      if display_name
        display_name
      else
        comments
      end
    end
    
    def to_s
      format
    end
    
  end
end