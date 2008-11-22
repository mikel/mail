require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Message do
  
  @basic_email = "To: mikel\nFrom: bob\nSubject: Hello!\n\nemail message\n"
  
  before(:each) do
    @mail = Mail::Message.new
  end
  
  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Message.new}.should_not raise_error
    end
    
    it "should allow us to pass it a block" do
      mail = Mail::Message.new do
        from 'mikel@me.com'
      end
      mail.from.should == 'mikel@me.com'
    end
    
  end
  
  describe "accepting a plain text string email" do

    it "should accept some email text to parse and return an email" do
      mail = Mail::Message.parse(@basic_email)
      mail.class.should == Mail::Message
    end

    it "should set a raw source instance variable to equal the passed in message" do
      mail = Mail::Message.parse(@basic_email)
      mail.raw_source.should == @basic_email
    end

    it "should set the raw source instance variable to nil if no message is passed in" do
      mail = Mail::Message.new
      mail.raw_source.should == nil
    end
  
    it "should parse the from address in the email" do
      
    end
  
  end
  
  describe "directly setting the values of a simple email" do

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
        @mail.body = "email message\n"
        @mail.body.should == "email message\n"
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
        @mail.body "email message\n"
        @mail.body.should == "email message\n"
      end
    end
    
  end
end

