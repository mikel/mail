# encoding: utf-8
require 'spec_helper'

describe Mail::UnstructuredField do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::UnstructuredField.new("Name", "Value")}.should_not raise_error
    end
    
  end

  describe "manipulation" do
    
    before(:each) do
      @field = Mail::UnstructuredField.new("Subject", "Hello Frank")
    end
    
    it "should allow us to set a text value at initialization" do
      doing{Mail::UnstructuredField.new("Subject", "Value")}.should_not raise_error
    end
    
    it "should provide access to the text of the field once set" do
      @field.value.should == "Hello Frank"
    end
    
    it "should provide a means to change the value" do
      @field.value = "Goodbye Frank"
      @field.value.should == "Goodbye Frank"
    end
  end

  describe "displaying encoded field and decoded value" do
    
    before(:each) do
      @field = Mail::UnstructuredField.new("Subject", "Hello Frank")
    end
    
    it "should provide a to_s function that returns the field name and value" do
      @field.value.should == "Hello Frank"
    end
    
    it "should return '' on to_s if there is no value" do
      @field.value = nil
      @field.encoded.should == ''
    end
    
    it "should give an encoded value ready to insert into an email" do
      @field.encoded.should == "Subject: Hello Frank\r\n"
    end
    
    it "should return nil on encoded if it has no value" do
      @field.value = nil
      @field.encoded.should == ''
    end
    
    it "should give an decoded value ready to insert into an email" do
      @field.decoded.should == "Hello Frank"
    end
    
    it "should return a nil on decoded if it has no value" do
      @field.value = nil
      @field.decoded.should == nil
    end
    
    it "should just add the CRLF at the end of the line" do
      @field = Mail::SubjectField.new("Subject: =?utf-8?Q?testing_testing_=D6=A4?=")
      result = "Subject: testing testing =?UTF8?Q?_=D6=A4=?=\r\n"
      @field.encoded.gsub("UTF-8", "UTF8").should == result
      @field.decoded.should == "testing testing \326\244"
    end
    
  end

  describe "folding" do

    it "should not fold itself if it is 78 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is _exactly_ 78 characters....")
      @field.encoded.should == "Subject: This is a subject header message that is _exactly_ 78 characters....\r\n"
    end
    
    it "should fold itself if it is 79 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is _exactly_ 79 characters long")
      result = "Subject: This is a subject header message that is _exactly_ 79 characters\r\n\slong\r\n"
      @field.encoded.should == result
    end

    it "should fold itself if it is 997 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. And this makes it 997....")
      lines = @field.encoded.split("\r\n\s")
      lines.each { |line| line.length.should < 78 }
    end
    
    it "should fold itself if it is 998 characters long" do
      value = "This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. And this makes it 998 long"
      @field = Mail::UnstructuredField.new("Subject", value)
      lines = @field.encoded.split("\r\n\s")
      lines.each { |line| line.length.should < 78 }
    end
    
    it "should fold itself if it is 999 characters long" do
      value = "This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. And this makes it 999 long."
      @field = Mail::UnstructuredField.new("Subject", value)
      lines = @field.encoded.split("\r\n\s")
      lines.each { |line| line.length.should < 78 }
    end

    it "should fold itself if it is non us-ascii" do
      @original = $KCODE if RUBY_VERSION < '1.9'
      string = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
      @field = Mail::UnstructuredField.new("Subject", string)
      if string.respond_to?(:force_encoding)
        string = string.force_encoding('UTF-8')
      else
        $KCODE = 'u'
      end
      result = "Subject: This =?UTF8?Q?is_=E3=81=82=?= really long string\r\n\s=?UTF8?Q?This_is_=E3=81=82=?= really long string\r\n\s=?UTF8?Q?This_is_=E3=81=82=?= really long string\r\n\s=?UTF8?Q?This_is_=E3=81=82=?= really long string\r\n\s=?UTF8?Q?This_is_=E3=81=82=?= really long string\r\n"
      @field.encoded.gsub("UTF-8", "UTF8").should == result
      @field.decoded.should == string
      $KCODE = @original if RUBY_VERSION < '1.9'
    end
    
  end
  
  describe "encoding non QP safe chars" do
    it "should encode an ascii string that has carriage returns if asked to" do
      result = "Subject: =0Aasdf=0A\r\n"
      @field = Mail::UnstructuredField.new("Subject", "\nasdf\n")
      @field.encoded.should == "Subject: =0Aasdf=0A\r\n"
    end
  end

end
