require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe Mail::UnstructuredField do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::UnstructuredField.new('subject')}.should_not raise_error
    end
    
    it "should accept a field name" do
      field = Mail::UnstructuredField.new('subject')
      field.name.should == 'subject'
    end
    
    it "should allow a x- type of field" do
      field = Mail::UnstructuredField.new('x-mail-dump')
      field.name.should == 'x-mail-dump'
    end
    
  end

  describe "validation" do
    
    it "should be valid with a name specified" do
      field = Mail::UnstructuredField.new('subject', 'Hello there')
      field.should be_valid
    end
    
    it "should not be valid with nil as a name" do
      field = Mail::UnstructuredField.new(nil)
      field.should_not be_valid
    end

    it "should not be valid with an empty string as a name" do
      field = Mail::UnstructuredField.new('')
      field.should_not be_valid
    end
  end

  describe "manipulation" do
    
    before(:each) do
      @field = Mail::UnstructuredField.new('subject', "Hello Frank")
    end
    
    it "should allow us to set a text value at initialization" do
      doing{Mail::UnstructuredField.new('subject', "Hello Frank")}.should_not raise_error
    end
    
    it "should provide access to the text of the field once set" do
      @field.value.should == "Hello Frank"
    end
    
    it "should provide a means to change the value" do
      @field.value = "Goodbye Frank"
      @field.value.should == "Goodbye Frank"
    end
  end

  describe "displaying" do
    
    before(:each) do
      @field = Mail::UnstructuredField.new('subject', "Hello Frank")
    end
    
    it "should provide a to_s function that returns the field name and value" do
      @field.to_s.should == "subject: Hello Frank"
    end
    
    it "should return '' on to_s if there is no value" do
      @field.value = nil
      @field.to_s.should == ''
    end
    
    it "should give an encoded value ready to insert into an email" do
      @field.encoded.should == "subject: Hello Frank"
    end
    
    it "should return nil on encoded if it has no value" do
      @field.value = nil
      @field.encoded.should == nil
    end
    
  end
end