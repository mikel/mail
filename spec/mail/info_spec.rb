require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Info do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Info.new}.should_not raise_error
    end
    
  end

end