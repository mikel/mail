# encoding: utf-8
require 'spec_helper'

describe Mail::StructuredField do

  describe "initialization" do
    
    it "should be instantiated" do
      expect(doing {Mail::StructuredField.new("From", "bob@me.com")}).not_to raise_error
    end
    
  end

  describe "manipulation" do
    
    before(:each) do
      @field = Mail::StructuredField.new("From", "bob@me.com")
    end
    
    it "should allow us to set a text value at initialization" do
      expect(doing{Mail::StructuredField.new("From", "bob@me.com")}).not_to raise_error
    end
    
    it "should provide access to the text of the field once set" do
      expect(@field.value).to eq "bob@me.com"
    end
    
    it "should provide a means to change the value" do
      @field.value = "bob@you.com"
      expect(@field.value).to eq "bob@you.com"
    end
  end

  describe "displaying encoded field and decoded value" do
    
    before(:each) do
      @field = Mail::FromField.new("bob@me.com")
    end
    
    it "should provide a to_s function that returns the decoded string" do
      expect(@field.to_s).to eq "bob@me.com"
    end
    
    it "should return '' on to_s if there is no value" do
      @field.value = nil
      expect(@field.encoded).to eq ''
    end
    
    it "should give an encoded value ready to insert into an email" do
      expect(@field.encoded).to eq "From: bob@me.com\r\n"
    end
    
    it "should return an empty string on encoded if it has no value" do
      @field.value = nil
      expect(@field.encoded).to eq ''
    end
    
    it "should return the field name and value in proper format when called to_s" do
      expect(@field.encoded).to eq "From: bob@me.com\r\n"
    end
    
  end
  
  describe "structured field template methods" do
    it "should raise an error if attempting to call :encoded or :decoded on the parent StructuredField class" do
      field = Mail::StructuredField.new
      expect(doing { field.encoded }).to raise_error(NoMethodError)
      expect(doing { field.decoded }).to raise_error(NoMethodError)
    end
  end

end
