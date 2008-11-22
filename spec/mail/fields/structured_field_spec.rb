require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe Mail::StructuredField do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::StructuredField.new("name")}.should_not raise_error
    end
    
  end

end