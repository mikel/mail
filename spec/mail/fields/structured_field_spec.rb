require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe Mail::StructuredField do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::StructuredField.new("From: bob@me.com", "From", "bob@me.com")}.should_not raise_error
    end
    
  end

  describe "manipulation" do
    
    before(:each) do
      @field = Mail::StructuredField.new("From: bob@me.com", "From", "bob@me.com")
    end
    
    it "should allow us to set a text value at initialization" do
      doing{Mail::StructuredField.new("From: bob@me.com", "From", "bob@me.com")}.should_not raise_error
    end
    
    it "should provide access to the text of the field once set" do
      @field.value.should == "bob@me.com"
    end
    
    it "should provide a means to change the value" do
      @field.value = "bob@you.com"
      @field.value.should == "bob@you.com"
    end
  end

  describe "displaying" do
    
    before(:each) do
      @field = Mail::StructuredField.new("From: bob@me.com", "From", "bob@me.com")
    end
    
    it "should provide a to_s function that returns the field name and value" do
      @field.to_s.should == "From: bob@me.com"
    end
    
    it "should return '' on to_s if there is no value" do
      @field.value = nil
      @field.to_s.should == ''
    end
    
    it "should give an encoded value ready to insert into an email" do
      @field.encoded.should == "From: bob@me.com"
    end
    
    it "should return nil on encoded if it has no value" do
      @field.value = nil
      @field.encoded.should == nil
    end
    
  end

end