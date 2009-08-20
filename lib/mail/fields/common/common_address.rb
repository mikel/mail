# encoding: utf-8
module Mail
  module CommonAddress # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
  
    module InstanceMethods # :doc:
      
      # Allows you to iterate through each address object in the syntax tree
      def each
        tree.addresses.each do |address|
          yield
        end
      end

      # Returns the address string of all the addresses in the address list
      def addresses
        tree.addresses.map { |a| a.address }
      end

      # Returns the formatted string of all the addresses in the address list
      def formatted
        tree.addresses.map { |a| a.format }
      end
      
      # Returns a hash of group name => address strings for the address list
      def groups
        @groups = Hash.new
        tree.group_recipients.each do |group|
          @groups[group.group_name.text_value] = get_group_addresses(group.group_list.addresses)
        end
        @groups
      end

      # Returns the name of all the groups in a string
      def group_names # :nodoc:
        tree.group_names
      end

      private
      
      # Returns the syntax tree of the Addresses
      def tree # :nodoc:
        @tree ||= AddressList.new(value)
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