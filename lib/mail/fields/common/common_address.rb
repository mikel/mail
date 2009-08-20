# encoding: utf-8
module Mail
  module CommonAddress # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
  
    module InstanceMethods # :doc:
      
      def tree
        @tree ||= AddressList.new(value)
      end
      
      def each
        tree.addresses.each do |address|
          yield
        end
      end

      def addresses
        tree.addresses.map { |a| a.address }
      end

      def formatted
        tree.addresses.map { |a| a.format }
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
    
    def self.included(receiver) # :nodoc:
      receiver.send :include, InstanceMethods
    end
    
  end
end