# encoding: utf-8
module Mail
  module CommonField
    
    module ClassMethods
      
    end
    
    module InstanceMethods
      
      def strip_field(field_name, string)
        string.to_s.gsub(/#{field_name}:\s+/i, '')
      end
      
      def name=(value)
        @name = value.to_s.split("-").map { |v| v.capitalize }.join("-")
      end
      
      def name
        @name
      end
      
      def value=(value)
        @value = value
      end
      
      def value
        @value
      end
      
      def to_s
        value.blank? ? '' : "#{name}: #{value}"
      end
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end