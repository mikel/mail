require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Body do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Body.new}.should_not raise_error
    end
    
  end

end