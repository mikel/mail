require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Header do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Header.new}.should_not raise_error
    end
    
  end

  describe "accessor methods" do
    
    before(:each) do
      @header = Mail::Header.new
    end
    
  end

end