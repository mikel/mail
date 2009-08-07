# encoding: utf-8
module Mail

  # Field List class provides an enhanced array that keeps a list of 
  # email fields in order.  And allows you to insert new fields without
  # having to worry about the order they will appear in.
  class FieldList < Array
    
    
    def <<( new_field )
      super
      self.sort!
    end
    
  end
end