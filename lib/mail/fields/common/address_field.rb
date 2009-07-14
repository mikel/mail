module Mail
  module AddressField
    
    module ClassMethods
      
    end
  
    module InstanceMethods
      
      def tree
        @tree ||= AddressList.new(value) 
      end
      
      def addresses
        result = tree.addresses
      end

      def address_strings
        addresses.map { |a| a.address }
      end

      def group_names
        tree.group_names
      end
      
      def groups
        @groups = Hash.new
        tree.group_recipients.each do |group|
          @groups[group.group_name.text_value] = get_group_addresses(group.group_list.addresses)
        end
        @groups
      end

      def get_group_addresses(group_addresses)
        group_addresses.map do |address_tree|
          Mail::Address.new(address_tree)
        end
      end

      

    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end