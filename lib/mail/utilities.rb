module Mail
  module Utilities
    module ClassMethods
    
    end
  
    module InstanceMethods

    end
  
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end