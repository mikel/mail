require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Header do

  describe "initialization" do
    
    it "should instantiate empty" do
      doing { Mail::Header.new }.should_not raise_error
    end

    it "should instantiate with a string passed in" do
      doing { Mail::Header.new("To: Mikel\r\nFrom: bob\r\n") }.should_not raise_error
    end

  end

  describe "accessor methods" do
    
    it "should save away the raw source of the header that it is passed" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.raw_source.should == "To: Mikel\r\nFrom: bob\r\n"
    end
    
  end

  describe "parsing a header" do
    
    it "should split the header into separate fields" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.fields.length.should == 2
    end
    
    it "should not split a wrapped header in two" do
      header = Mail::Header.new("To: Mikel\r\n\tLindsaar\r\nFrom: bob\r\nSubject: This is\r\n a long\r\n\t \t \t \t    badly formatted             \r\n       \t\t  \t       field")
      header.fields.length.should == 3
    end
    
    it "should split each field into an name and value" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.fields[0].name.should == "To"
      header.fields[0].value.should == "Mikel"
      header.fields[1].name.should == "From"
      header.fields[1].value.should == "bob"
    end
    
  end

end