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
      result = "Subject: testing testing\r\n\t=?UTF8?Q?=D6=A4?=\r\n"
      @field.encoded.gsub("UTF-8", "UTF8").should == result
      @field.decoded.should == "testing testing \326\244"
    end

    it "should do encoded-words encoding correctly without extra equal sign" do
      @field = Mail::SubjectField.new("testing testing æøå")
      result = "Subject: testing testing\r\n\t=?UTF8?Q?=C3=A6=C3=B8=C3=A5?=\r\n"
      @field.encoded.gsub("UTF-8", "UTF8").should == result
      @field.decoded.should == "testing testing æøå"
    end
    
    it "should not put two encoded-words on the same line" do
      @field = Mail::SubjectField.new("Her er æ ø å")
      result = "Subject: =?UTF8?Q?Her_er_=C3=A6?=\r\n\t=?UTF8?Q?=C3=B8_=C3=A5?=\r\n"
      @field.encoded.gsub("UTF-8", "UTF8").should == result
      @field.decoded.should == "Her er æ ø å"
    end
  end

  describe "folding" do

    it "should not fold itself if it is 78 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is _exactly_ 78 characters....")
      @field.encoded.should == "Subject: This is a subject header message that is _exactly_ 78 characters....\r\n"
    end
    
    it "should fold itself if it is 79 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is _exactly_ 79 characters long")
      result = "Subject: This is a subject header message that is _exactly_ 79 characters\r\n\tlong\r\n"
      @field.encoded.should == result
    end

    it "should fold itself if it is 997 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. And this makes it 997....")
      lines = @field.encoded.split("\r\n\t")
      lines.each { |line| line.length.should < 78 }
    end
    
    it "should fold itself if it is 998 characters long" do
      value = "This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. And this makes it 998 long"
      @field = Mail::UnstructuredField.new("Subject", value)
      lines = @field.encoded.split("\r\n\t")
      lines.each { |line| line.length.should < 78 }
    end
    
    it "should fold itself if it is 999 characters long" do
      value = "This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. And this makes it 999 long."
      @field = Mail::UnstructuredField.new("Subject", value)
      lines = @field.encoded.split("\r\n\t")
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
      result = "Subject: =?UTF8?Q?This_is_=E3=81=82?= really long string\r\n\t=?UTF8?Q?This_is_=E3=81=82?= really long string\r\n\t=?UTF8?Q?This_is_=E3=81=82?= really long string\r\n\t=?UTF8?Q?This_is_=E3=81=82?= really long string\r\n\t=?UTF8?Q?This_is_=E3=81=82?= really long string\r\n"
      @field.encoded.gsub("UTF-8", "UTF8").should == result
      @field.decoded.should == string
      $KCODE = @original if RUBY_VERSION < '1.9'
    end

    it "should fold properly with my actual complicated header" do
      @original = $KCODE if RUBY_VERSION < '1.9'
      string = %|{"unique_args": {"mailing_id":147,"account_id":2}, "to": ["larspind@gmail.com"], "category": "mailing", "filters": {"domainkeys": {"settings": {"domain":1,"enable":1}}}, "sub": {"{{open_image_url}}": ["http://betaling.larspind.local/O/token/147/Mailing::FakeRecipient"], "{{name}}": ["[FIRST NAME]"], "{{signup_reminder}}": ["(her kommer til at stå hvornår folk har skrevet sig op ...)"], "{{unsubscribe_url}}": ["http://betaling.larspind.local/U/token/147/Mailing::FakeRecipient"], "{{email}}": ["larspind@gmail.com"], "{{link:308}}": ["http://betaling.larspind.local/L/308/0/Mailing::FakeRecipient"], "{{confirm_url}}": [""], "{{ref}}": ["[REF]"]}}|
      @field = Mail::UnstructuredField.new("X-SMTPAPI", string)
      if string.respond_to?(:force_encoding)
        string = string.force_encoding('UTF-8')
      else
        $KCODE = 'u'
      end
      result = %|X-SMTPAPI: {"unique_args": {"mailing_id":147,"account_id":2}, "to":\r\n\t["larspind@gmail.com"], "category": "mailing", "filters": {"domainkeys":\r\n\t{"settings": {"domain":1,"enable":1}}}, "sub": {"{{open_image_url}}":\r\n\t["http://betaling.larspind.local/O/token/147/Mailing::FakeRecipient"],\r\n\t"{{name}}": ["[FIRST NAME]"], "{{signup_reminder}}": ["(her kommer til\r\n\t=?UTF8?Q?at_st=C3=A5?=\r\n\t=?UTF8?Q?hvorn=C3=A5r?= folk har skrevet sig op ...)"],\r\n\t"{{unsubscribe_url}}":\r\n\t["http://betaling.larspind.local/U/token/147/Mailing::FakeRecipient"],\r\n\t"{{email}}": ["larspind@gmail.com"], "{{link:308}}":\r\n\t["http://betaling.larspind.local/L/308/0/Mailing::FakeRecipient"],\r\n\t"{{confirm_url}}": [""], "{{ref}}": ["[REF]"]}}\r\n|
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
