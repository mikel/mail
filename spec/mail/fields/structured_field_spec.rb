# encoding: utf-8
require 'spec_helper'

describe Mail::StructuredField do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::StructuredField.new("From", "bob@me.com")}.should_not raise_error
    end
    
  end

  describe "manipulation" do
    
    before(:each) do
      @field = Mail::StructuredField.new("From", "bob@me.com")
    end
    
    it "should allow us to set a text value at initialization" do
      doing{Mail::StructuredField.new("From", "bob@me.com")}.should_not raise_error
    end
    
    it "should provide access to the text of the field once set" do
      @field.value.should == "bob@me.com"
    end
    
    it "should provide a means to change the value" do
      @field.value = "bob@you.com"
      @field.value.should == "bob@you.com"
    end
  end

  describe "displaying encoded field and decoded value" do
    
    before(:each) do
      @field = Mail::FromField.new("bob@me.com")
    end
    
    it "should provide a to_s function that returns the decoded string" do
      @field.to_s.should == "bob@me.com"
    end
    
    it "should return '' on to_s if there is no value" do
      @field.value = nil
      @field.encoded.should == ''
    end
    
    it "should give an encoded value ready to insert into an email" do
      @field.encoded.should == "From: bob@me.com\r\n"
    end
    
    it "should return an empty string on encoded if it has no value" do
      @field.value = nil
      @field.encoded.should == ''
    end
    
    it "should return the field name and value in proper format when called to_s" do
      @field.encoded.should == "From: bob@me.com\r\n"
    end
    
  end
  
  describe "structured field template methods" do
    it "should raise an error if attempting to call :encoded or :decoded on the parent StructuredField class" do
      field = Mail::StructuredField.new
      doing { field.encoded }.should raise_error(NoMethodError)
      doing { field.decoded }.should raise_error(NoMethodError)
    end
  end

end