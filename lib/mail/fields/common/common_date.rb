# encoding: utf-8
module Mail
  module CommonDate # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
    
    module InstanceMethods # :doc:
      
      def tree
        @element ||= DateTimeElement.new(value)
        @tree ||= @element.tree
      end
      
      def element
        @element ||= DateTimeElement.new(value)
      end
      
      def date_time
        ::DateTime.parse("#{element.date} #{element.time}")
      end
      
    end
    
    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end