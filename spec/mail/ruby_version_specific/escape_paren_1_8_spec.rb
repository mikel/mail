require File.dirname(__FILE__) + '/../../spec_helper'

describe "Ruby 1.8 Extensions" do
  
  describe "string" do
    it "should say it is US-ASCII only if it is" do
      "abc".should be_ascii_only
    end
    
    it "should not say it is US-ASCII only if it isn't" do
      "かきくけこ".should_not be_ascii_only
    end
    
    it "should not say it is US-ASCII only if it is a mix" do
      "abcかきくけこ123".should_not be_ascii_only
    end
  end
end
