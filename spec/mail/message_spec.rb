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

    it "should set the raw source instance variable to '' if no message is passed in" do
      mail = Mail::Message.new
      mail.raw_source.should == ""
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

    it "should give the header the part before the line without spaces and the body the part without" do
      Mail::Header.should_receive(:new).with("To: mikel")
      Mail::Body.should_receive(:new).with("G'Day!")
      mail = Mail::Message.new("To: mikel\r\n\r\nG'Day!")
    end
  
    it "should give allow for whitespace on the gap line between header and body" do
      Mail::Header.should_receive(:new).with("To: mikel")
      Mail::Body.should_receive(:new).with("G'Day!")
      mail = Mail::Message.new("To: mikel\r\n   		  \r\nG'Day!")
    end

  end

  describe "stripping of the envelope string" do
    it "should strip off the envelope from field if present" do
      message = Mail::Message.new(File.read(fixture('emails/raw_email')))
      message.raw_envelope.should == "jamis_buck@byu.edu Mon May  2 16:07:05 2005"
      message.from.should == "Jamis Buck <jamis@37signals.com>"
    end

    it "should not cause any problems if there is no envelope from present" do
      message = Mail::Message.new(File.read(fixture('emails/basic_email')))
      message.from.should == "Mikel Lindsaar <test@lindsaar.net>"
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
        @mail['foo'].value.should == '1234'
      end
      
      it "should instantiate a new Header" do
        @mail['foo'] = 1234
        @mail.header_fields.first.class.should == Mail::Field
      end
    end
    
    describe "setting headers in block form" do
      it "should accept all standard headers" do
        message = Mail.message do
          bcc           'mikel@bcc.lindsaar.net'
          cc            'mikel@cc.lindsaar.net'
          comments      'this is a comment'
          date          '12 Aug 2009 00:00:01 GMT'
          from          'mikel@from.lindsaar.net'
          in_reply_to   '<1234@in_reply_to.lindsaar.net>'
          keywords      'test, "of the new mail", system'
          message_id    '<1234@message_id.lindsaar.net>'
          received      '12 Aug 2009 00:00:02 GMT'
          references    '<1234@references.lindsaar.net>'
          reply_to      'mikel@reply-to.lindsaar.net'
          resent_bcc    'mikel@resent-bcc.lindsaar.net'
          resent_cc     'mikel@resent-cc.lindsaar.net'
          resent_date   '12 Aug 2009 00:00:03 GMT'
          resent_from   'mikel@resent-from.lindsaar.net'
          resent_message_id '<1234@resent_message_id.lindsaar.net>'
          resent_sender 'mikel@resent-sender.lindsaar.net'
          resent_to     'mikel@resent-to.lindsaar.net'
          sender        'mikel@sender.lindsaar.net'
          subject       'Hello there Mikel'
          to            'mikel@to.lindsaar.net'
          body          'This is a body of text'
        end
        message.bcc.should           == 'mikel@bcc.lindsaar.net'
        message.cc.should            == 'mikel@cc.lindsaar.net'
        message.comments.should      == 'this is a comment'
        message.date.should          == '12 Aug 2009 00:00:01 GMT'
        message.from.should          == 'mikel@from.lindsaar.net'
        message.in_reply_to.should   == '<1234@in_reply_to.lindsaar.net>'
        message.keywords.should      == 'test, "of the new mail", system'
        message.message_id.should    == '<1234@message_id.lindsaar.net>'
        message.received.should      == '12 Aug 2009 00:00:02 GMT'
        message.references.should    == '<1234@references.lindsaar.net>'
        message.reply_to.should      == 'mikel@reply-to.lindsaar.net'
        message.resent_bcc.should    == 'mikel@resent-bcc.lindsaar.net'
        message.resent_cc.should     == 'mikel@resent-cc.lindsaar.net'
        message.resent_date.should   == '12 Aug 2009 00:00:03 GMT'
        message.resent_from.should   == 'mikel@resent-from.lindsaar.net'
        message.resent_message_id.should == '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender.should == 'mikel@resent-sender.lindsaar.net'
        message.resent_to.should     == 'mikel@resent-to.lindsaar.net'
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == 'mikel@to.lindsaar.net'
        message.body.to_s.should     == 'This is a body of text'
      end
    end
    
  end

end
