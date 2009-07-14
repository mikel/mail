module Mail
  class Address
    def initialize(value)
      if value.class == String
        self.tree = Mail::AddressListsParser.new.parse(value).first_addr
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
        "#{display_name} <#{address}>"
      else
        address
      end
    end

    def local
      if tree.respond_to?(:angle_addr)
        tree.angle_addr.addr_spec.local_part.text_value.strip
      else
        tree.local_part.text_value.strip
      end
    end
    
    def domain
      if tree.respond_to?(:angle_addr)
        tree.angle_addr.addr_spec.domain.text_value.strip
      else
        tree.domain.text_value.strip
      end
    end
    
    def address
      "#{local}@#{domain}"
    end
    
    def comments
      
    end
    
    def display_name
      if tree.respond_to?(:display_name)
        tree.display_name.text_value.strip
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