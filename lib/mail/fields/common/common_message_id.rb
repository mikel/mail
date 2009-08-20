# encoding: utf-8
module Mail
  module CommonMessageId # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
    
    module InstanceMethods # :doc:
      
      def tree
        @tree ||= element.tree
      end
      
      def element
        @element ||= Mail::MessageIdsElement.new(value)
      end
      
      def message_id
        element.message_id
      end
      
      def message_ids
        element.message_ids
      end
      
    end
    
    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end