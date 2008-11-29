require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Message do
  
  def basic_email
    "To: mikel\r\nFrom: bob\r\nSubject: Hello!\r\n\r\nemail message\r\n"
  end

  describe "initialization" do
    
    it "should instantiate empty" do
      Mail::Message.new.class.should == Mail::Message
    end
    
    it "should instantiate with a string" do
      Mail::Message.new(basic_email).class.should == Mail::Message
    end
    
    it "should allow us to pass it a block" do
      mail = Mail::Message.new do
        from 'mikel@me.com'
        to 'lindsaar@you.com'
      end
      mail.from.should == 'mikel@me.com'
      mail.to.should == 'lindsaar@you.com'
    end
    
    it "should initialize a body and header class even if called with nothing to begin with" do
      Mail::Header.should_receive(:new)
      Mail::Body.should_receive(:new)
      mail = Mail::Message.new
    end
    
  end
  
  describe "accepting a plain text string email" do

    it "should accept some email text to parse and return an email" do
      mail = Mail::Message.new(basic_email)
      mail.class.should == Mail::Message
    end

    it "should set a raw source instance variable to equal the passed in message" do
      mail = Mail::Message.new(basic_email)
      mail.raw_source.should == basic_email
    end

    it "should set the raw source instance variable to nil if no message is passed in" do
      mail = Mail::Message.new
      mail.raw_source.should == nil
    end
  
    it "should give the header class the header to parse" do
      Mail::Header.should_receive(:new).with("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
      mail = Mail::Message.new(basic_email)
    end

    it "should give the header class the header to parse even if there is no body" do
      Mail::Header.should_receive(:new).with("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
      mail = Mail::Message.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
    end
  
    it "should give the body class the body to parse" do
      Mail::Body.should_receive(:new).with("email message\r\n")
      mail = Mail::Message.new(basic_email)
    end
  
    it "should still ask the body for a new instance even though these is nothing to parse, yet" do
      Mail::Body.should_receive(:new)
      mail = Mail::Message.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
    end
  
  end
  
  describe "directly setting the values of a simple email" do

    before(:each) do
      @mail = Mail::Message.new
    end

    describe "accessing fields directly" do
      it "should allow you to grab field objects if you really want to" do
        @mail.header_fields.class.should == Array
      end
      
      it "should give you back the fields in the header" do
        @mail['bar'] = 'abcd'
        @mail.header_fields.length.should == 1
        @mail['foo'] = '4321'
        @mail.header_fields.length.should == 2
      end
      
      it "should delete a field if it is set to nil" do
        @mail['foo'] = '4321'
        @mail.header_fields.length.should == 1
        @mail['foo'] = nil
        @mail.header_fields.length.should == 0
      end
    end

    describe "with :method=" do
      it "should return the to field" do
        @mail.to = "mikel"
        @mail.to.should == "mikel"
      end

      it "should return the from field" do
        @mail.from = "bob"
        @mail.from.should == "bob"
      end

      it "should return the subject" do
        @mail.subject = "Hello!"
        @mail.subject.should == "Hello!"
      end

      it "should return the body" do
        @mail.body = "email message\r\n"
        @mail.body.to_s.should == "email message\r\n"
      end
    end
    
    describe "with :method(value)" do
      it "should return the to field" do
        @mail.to "mikel"
        @mail.to.should == "mikel"
      end

      it "should return the from field" do
        @mail.from "bob"
        @mail.from.should == "bob"
      end

      it "should return the subject" do
        @mail.subject "Hello!"
        @mail.subject.should == "Hello!"
      end

      it "should return the body" do
        @mail.body "email message\r\n"
        @mail.body.to_s.should == "email message\r\n"
      end
    end
    
    describe "setting arbitrary headers" do
      it "should allow you to set them" do
        doing {@mail['foo'] = 1234}.should_not raise_error
      end
      
      it "should allow you to read arbitrary headers" do
        @mail['foo'] = 1234
        @mail['foo'].should == '1234'
      end
      
      it "should instantiate a new Header" do
        @mail['foo'] = 1234
        @mail.header_fields.first.class.should == Mail::Field
      end
    end
  end

end

