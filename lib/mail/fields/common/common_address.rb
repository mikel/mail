# encoding: utf-8
module Mail
  module CommonAddress # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
  
    module InstanceMethods # :doc:
      
      def parse(val = value)
        unless val.blank?
          @tree ||= AddressList.new(value)
        else
          nil
        end
      end
      
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
          @groups[group.group_name.text_value] = get_group_addresses(group.group_list)
        end
        @groups
      end
      
      # Returns the addresses that are part of groups
      def group_addresses
        groups.map { |k,v| v.map { |a| a.format } }.flatten
      end

      # Returns the name of all the groups in a string
      def group_names # :nodoc:
        tree.group_names
      end
      
      def default
        addresses
      end
      
      private
      
      def do_encode(field_name)
        return '' if value.blank?
        address_array = tree.addresses.reject { |a| group_addresses.include?(a.encoded) }.compact.map { |a| a.encoded }
        address_text  = address_array.join(", \r\n\t")
        group_array = groups.map { |k,v| "#{k}: #{v.map { |a| a.encoded }.join(", \r\n\t")};" }
        group_text  = group_array.join(" \r\n\t")
        return_array = [address_text, group_text].reject { |a| a.blank? }
        "#{field_name}: #{return_array.join(", \r\n\t")}\r\n"
      end

      def do_decode
        return nil if value.blank?
        address_array = tree.addresses.reject { |a| group_addresses.include?(a.decoded) }.map { |a| a.decoded }
        address_text  = address_array.join(", ")
        group_array = groups.map { |k,v| "#{k}: #{v.map { |a| a.decoded }.join(", ")};" }
        group_text  = group_array.join(" ")
        return_array = [address_text, group_text].reject { |a| a.blank? }
        return_array.join(", ")
      end

      # Returns the syntax tree of the Addresses
      def tree # :nodoc:
        @tree ||= AddressList.new(value)
      end
      
      def get_group_addresses(group_list)
        if group_list.respond_to?(:addresses)
          group_list.addresses.map do |address_tree|
            Mail::Address.new(address_tree)
          end
        else
          []
        end
      end

    end
    
    def self.included(receiver) # :nodoc:
      receiver.send :include, InstanceMethods
    end
    
  end
end