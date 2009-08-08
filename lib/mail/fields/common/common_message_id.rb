# encoding: utf-8
module Mail
  module CommonMessageId
    
    module ClassMethods
      
    end
    
    module InstanceMethods
      
      def tree
        @element ||= Mail::MessageIdsElement.new(value)
        @tree ||= @element.tree
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
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end