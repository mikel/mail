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
    
    #  Header fields are lines composed of a field name, followed by a colon
    #  (":"), followed by a field body, and terminated by CRLF.  A field
    #  name MUST be composed of printable US-ASCII characters (i.e.,
    #  characters that have values between 33 and 126, inclusive), except
    #  colon.
    it "should accept any valid header field name" do
      test_name = ascii.reject { |c| c == ':' }
      doing {Mail::Header.new("#{test_name}: This is a crazy name")}.should_not raise_error
    end

    # A field body may be composed of any US-ASCII characters,
    # except for CR and LF.  However, a field body may contain CRLF when
    # used in header "folding" and  "unfolding" as described in section
    # 2.2.3.
    it "should accept any valid header field value" do
      test_value = ascii.reject { |c| c == ':' }
      test_value << ' '
      test_value << '\r\n'
      doing {Mail::Header.new("header: #{test_value}")}.should_not raise_error
    end
    
    it "should split each field into an name and value" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.fields[0].name.should == "To"
      header.fields[0].value.should == "Mikel"
      header.fields[1].name.should == "From"
      header.fields[1].value.should == "bob"
    end
    
    it "should preserve the order of the fields it is given" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'To: bob@you.com', 'Subject: This is a badly formed email']
      header.fields[0].name.should == 'From'
      header.fields[1].name.should == 'To'
      header.fields[2].name.should == 'Subject'
    end
    
    it "should allow you to reference each field and value by literal string name" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['To'].should == "Mikel"
      header['From'].should == "bob"
    end

    it "should return an array of fields if there is more than one match" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'X-Mail-SPAM: 15', 'X-Mail-SPAM: 23']
      header['X-Mail-SPAM'].should == ['15', '23']
    end

    it "should return nil if no value in the header" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['Subject'].should be_nil
    end
    
    it "should reset the value of a field if it already exists" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['To'] = 'George'
      header['To'].should == "George"
    end
    
    it "should add a new field if the field does not exist" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['Subject'] = "G'Day!"
      header['Subject'].should == "G'Day!"
    end
    
    it "should allow you to pass in an array of raw fields" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'To: bob@you.com']
      header['To'].should == 'bob@you.com'
      header['From'].should == 'mikel@me.com'
    end
    
    it "should allow you to delete a field by setting it to nil" do
      header = Mail::Header.new
      header.fields = ['To: bob@you.com']
      header.fields.length.should == 1
      header['To'] = nil
      header.fields.length.should == 0
    end
    
    it "should delete the first field found if there are multiple options" do
      header = Mail::Header.new
      header.fields = ['X-SPAM: 1000', 'X-SPAM: 20']
      header['X-SPAM'] = nil
      header.fields.length.should == 1
      header['X-SPAM'].should == '20'
    end
    
  end

end