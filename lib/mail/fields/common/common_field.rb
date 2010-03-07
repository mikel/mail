# encoding: utf-8
module Mail
  module CommonField # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
    
    module InstanceMethods # :doc:
      
      def name=(value)
        @name = value
      end
      
      def name
        @name
      end
      
      def value=(value)
        @length = nil
        @tree = nil
        @element = nil
        @value = value
      end
      
      def value
        @value
      end
      
      def to_s
        decoded
      end
      
      def default
        decoded
      end
      
      def field_length
        @length ||= name.length + value.length + ': '.length
      end
      
      def responsible_for?( val )
        name.to_s.downcase == val.to_s.downcase
      end

      private

      def strip_field(field_name, value)
        if value.is_a?(String)
          value.to_s.gsub(/#{field_name}:\s+/i, '')
        else
          value
        end
      end

    end
    
    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end