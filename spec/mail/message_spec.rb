# encoding: utf-8
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
      mail.from.addresses.should == ['mikel@me.com']
      mail.to.addresses.should == ['lindsaar@you.com']
    end
    
    it "should initialize a body and header class even if called with nothing to begin with" do
      Mail::Header.should_receive(:new)
      Mail::Body.should_receive(:new)
      mail = Mail::Message.new
    end
    
    it "should be able to parse a basic email" do
      doing { Mail::Message.new(File.read(fixture('emails/basic_email'))) }.should_not raise_error
    end

    it "should be able to parse every email example we have without raising an exception" do
      emails = Dir.glob(fixture('emails/*'))
      # Don't want to get noisy about any warnings
      STDERR.stub!(:puts)
      emails.each do |email|
        doing { Mail::Message.new(File.read(email)) }.should_not raise_error
      end
    end

    it "should raise a warning (and keep parsing) on having non US-ASCII characters in the header" do
      STDERR.should_receive(:puts)
      Mail::Message.new(File.read(fixture('emails/raw_email_string_in_date_field')))
    end

    it "should raise a warning (and keep parsing) on having an incorrectly formatted header" do
      STDERR.should_receive(:puts).with("WARNING: Could not parse (and so ignorning) 'quite Delivered-To: xxx@xxx.xxx'")
      Mail::Message.new(File.read(fixture('emails/raw_email_incorrect_header')))
    end

    it "should read in an email message and basically parse it" do
      mail = Mail::Message.new(File.read(fixture('emails/basic_email')))
      mail.to.formatted.should == ["Mikel Lindsaar <raasdnil@gmail.com>"]
    end

  end
  
  describe "envelope handling" do
    it "should respond to 'envelope from'" do
      Mail::Message.new.should respond_to(:envelope_from)
    end
    
    it "should strip off the envelope from field if present" do
      message = Mail::Message.new(File.read(fixture('emails/raw_email')))
      message.envelope_from.should == "jamis_buck@byu.edu"
      message.envelope_date.should == ::DateTime.parse("Mon May  2 16:07:05 2005")
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
      message.from.formatted.should == ["Jamis Buck <jamis@37signals.com>"]
    end

    it "should not cause any problems if there is no envelope from present" do
      message = Mail::Message.new(File.read(fixture('emails/basic_email')))
      message.from.formatted.should == ["Mikel Lindsaar <test@lindsaar.net>"]
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
        @mail.to.addresses.should == ["mikel"]
      end

      it "should return the from field" do
        @mail.from = "bob"
        @mail.from.addresses.should == ["bob"]
      end

      it "should return the subject" do
        @mail.subject = "Hello!"
        @mail.subject.to_s.should == "Hello!"
      end

      it "should return the body" do
        @mail.body = "email message\r\n"
        @mail.body.to_s.should == "email message\r\n"
      end
    end
    
    describe "with :method(value)" do
      it "should return the to field" do
        @mail.to "mikel"
        @mail.to.addresses.should == ["mikel"]
      end

      it "should return the from field" do
        @mail.from "bob"
        @mail.from.addresses.should == ["bob"]
      end

      it "should return the subject" do
        @mail.subject "Hello!"
        @mail.subject.to_s.should == "Hello!"
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
    
    describe "setting headers" do
      
      it "should accept them in block form" do
        message = Mail.new do
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
        
        message.bcc.to_s.should           == 'mikel@bcc.lindsaar.net'
        message.cc.to_s.should            == 'mikel@cc.lindsaar.net'
        message.comments.to_s.should      == 'this is a comment'
        message.date.to_s.should          == '12 Aug 2009 00:00:01 GMT'
        message.from.to_s.should          == 'mikel@from.lindsaar.net'
        message.in_reply_to.to_s.should   == '<1234@in_reply_to.lindsaar.net>'
        message.keywords.to_s.should      == 'test, "of the new mail", system'
        message.message_id.to_s.should    == '<1234@message_id.lindsaar.net>'
        message.received.to_s.should      == '12 Aug 2009 00:00:02 GMT'
        message.references.to_s.should    == '<1234@references.lindsaar.net>'
        message.reply_to.to_s.should      == 'mikel@reply-to.lindsaar.net'
        message.resent_bcc.to_s.should    == 'mikel@resent-bcc.lindsaar.net'
        message.resent_cc.to_s.should     == 'mikel@resent-cc.lindsaar.net'
        message.resent_date.to_s.should   == '12 Aug 2009 00:00:03 GMT'
        message.resent_from.to_s.should   == 'mikel@resent-from.lindsaar.net'
        message.resent_message_id.to_s.should == '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender.to_s.should == 'mikel@resent-sender.lindsaar.net'
        message.resent_to.to_s.should     == 'mikel@resent-to.lindsaar.net'
        message.sender.to_s.should        == 'mikel@sender.lindsaar.net'
        message.subject.to_s.should       == 'Hello there Mikel'
        message.to.to_s.should            == 'mikel@to.lindsaar.net'
        message.body.to_s.should          == 'This is a body of text'
      end

      it "should accept them in assignment form" do
        message = Mail.new
        message.bcc =           'mikel@bcc.lindsaar.net'
        message.cc =            'mikel@cc.lindsaar.net'
        message.comments =      'this is a comment'
        message.date =          '12 Aug 2009 00:00:01 GMT'
        message.from =          'mikel@from.lindsaar.net'
        message.in_reply_to =   '<1234@in_reply_to.lindsaar.net>'
        message.keywords =      'test, "of the new mail", system'
        message.message_id =    '<1234@message_id.lindsaar.net>'
        message.received =      '12 Aug 2009 00:00:02 GMT'
        message.references =    '<1234@references.lindsaar.net>'
        message.reply_to =      'mikel@reply-to.lindsaar.net'
        message.resent_bcc =    'mikel@resent-bcc.lindsaar.net'
        message.resent_cc =     'mikel@resent-cc.lindsaar.net'
        message.resent_date =   '12 Aug 2009 00:00:03 GMT'
        message.resent_from =   'mikel@resent-from.lindsaar.net'
        message.resent_message_id = '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender = 'mikel@resent-sender.lindsaar.net'
        message.resent_to =     'mikel@resent-to.lindsaar.net'
        message.sender =        'mikel@sender.lindsaar.net'
        message.subject =       'Hello there Mikel'
        message.to =            'mikel@to.lindsaar.net'
        message.body =          'This is a body of text'

        message.bcc.to_s.should           == 'mikel@bcc.lindsaar.net'
        message.cc.to_s.should            == 'mikel@cc.lindsaar.net'
        message.comments.to_s.should      == 'this is a comment'
        message.date.to_s.should          == '12 Aug 2009 00:00:01 GMT'
        message.from.to_s.should          == 'mikel@from.lindsaar.net'
        message.in_reply_to.to_s.should   == '<1234@in_reply_to.lindsaar.net>'
        message.keywords.to_s.should      == 'test, "of the new mail", system'
        message.message_id.to_s.should    == '<1234@message_id.lindsaar.net>'
        message.received.to_s.should      == '12 Aug 2009 00:00:02 GMT'
        message.references.to_s.should    == '<1234@references.lindsaar.net>'
        message.reply_to.to_s.should      == 'mikel@reply-to.lindsaar.net'
        message.resent_bcc.to_s.should    == 'mikel@resent-bcc.lindsaar.net'
        message.resent_cc.to_s.should     == 'mikel@resent-cc.lindsaar.net'
        message.resent_date.to_s.should   == '12 Aug 2009 00:00:03 GMT'
        message.resent_from.to_s.should   == 'mikel@resent-from.lindsaar.net'
        message.resent_message_id.to_s.should == '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender.to_s.should == 'mikel@resent-sender.lindsaar.net'
        message.resent_to.to_s.should     == 'mikel@resent-to.lindsaar.net'
        message.sender.to_s.should        == 'mikel@sender.lindsaar.net'
        message.subject.to_s.should       == 'Hello there Mikel'
        message.to.to_s.should            == 'mikel@to.lindsaar.net'
        message.body.to_s.should          == 'This is a body of text'
      end
      
      it "should accept them in key, value form as symbols" do
        message = Mail.new
        message[:bcc] =           'mikel@bcc.lindsaar.net'
        message[:cc] =            'mikel@cc.lindsaar.net'
        message[:comments] =      'this is a comment'
        message[:date] =          '12 Aug 2009 00:00:01 GMT'
        message[:from] =          'mikel@from.lindsaar.net'
        message[:in_reply_to] =   '<1234@in_reply_to.lindsaar.net>'
        message[:keywords] =      'test, "of the new mail", system'
        message[:message_id] =    '<1234@message_id.lindsaar.net>'
        message[:received] =      '12 Aug 2009 00:00:02 GMT'
        message[:references] =    '<1234@references.lindsaar.net>'
        message[:reply_to] =      'mikel@reply-to.lindsaar.net'
        message[:resent_bcc] =    'mikel@resent-bcc.lindsaar.net'
        message[:resent_cc] =     'mikel@resent-cc.lindsaar.net'
        message[:resent_date] =   '12 Aug 2009 00:00:03 GMT'
        message[:resent_from] =   'mikel@resent-from.lindsaar.net'
        message[:resent_message_id] = '<1234@resent_message_id.lindsaar.net>'
        message[:resent_sender] = 'mikel@resent-sender.lindsaar.net'
        message[:resent_to] =     'mikel@resent-to.lindsaar.net'
        message[:sender] =        'mikel@sender.lindsaar.net'
        message[:subject] =       'Hello there Mikel'
        message[:to] =            'mikel@to.lindsaar.net'
        message[:body] =          'This is a body of text'
        
        message.bcc.to_s.should           == 'mikel@bcc.lindsaar.net'
        message.cc.to_s.should            == 'mikel@cc.lindsaar.net'
        message.comments.to_s.should      == 'this is a comment'
        message.date.to_s.should          == '12 Aug 2009 00:00:01 GMT'
        message.from.to_s.should          == 'mikel@from.lindsaar.net'
        message.in_reply_to.to_s.should   == '<1234@in_reply_to.lindsaar.net>'
        message.keywords.to_s.should      == 'test, "of the new mail", system'
        message.message_id.to_s.should    == '<1234@message_id.lindsaar.net>'
        message.received.to_s.should      == '12 Aug 2009 00:00:02 GMT'
        message.references.to_s.should    == '<1234@references.lindsaar.net>'
        message.reply_to.to_s.should      == 'mikel@reply-to.lindsaar.net'
        message.resent_bcc.to_s.should    == 'mikel@resent-bcc.lindsaar.net'
        message.resent_cc.to_s.should     == 'mikel@resent-cc.lindsaar.net'
        message.resent_date.to_s.should   == '12 Aug 2009 00:00:03 GMT'
        message.resent_from.to_s.should   == 'mikel@resent-from.lindsaar.net'
        message.resent_message_id.to_s.should == '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender.to_s.should == 'mikel@resent-sender.lindsaar.net'
        message.resent_to.to_s.should     == 'mikel@resent-to.lindsaar.net'
        message.sender.to_s.should        == 'mikel@sender.lindsaar.net'
        message.subject.to_s.should       == 'Hello there Mikel'
        message.to.to_s.should            == 'mikel@to.lindsaar.net'
        message.body.to_s.should          == 'This is a body of text'
      end
      
      it "should accept them in key, value form as strings" do
        message = Mail.new
        message['bcc'] =           'mikel@bcc.lindsaar.net'
        message['cc'] =            'mikel@cc.lindsaar.net'
        message['comments'] =      'this is a comment'
        message['date'] =          '12 Aug 2009 00:00:01 GMT'
        message['from'] =          'mikel@from.lindsaar.net'
        message['in_reply_to'] =   '<1234@in_reply_to.lindsaar.net>'
        message['keywords'] =      'test, "of the new mail", system'
        message['message_id'] =    '<1234@message_id.lindsaar.net>'
        message['received'] =      '12 Aug 2009 00:00:02 GMT'
        message['references'] =    '<1234@references.lindsaar.net>'
        message['reply_to'] =      'mikel@reply-to.lindsaar.net'
        message['resent_bcc'] =    'mikel@resent-bcc.lindsaar.net'
        message['resent_cc'] =     'mikel@resent-cc.lindsaar.net'
        message['resent_date'] =   '12 Aug 2009 00:00:03 GMT'
        message['resent_from'] =   'mikel@resent-from.lindsaar.net'
        message['resent_message_id'] = '<1234@resent_message_id.lindsaar.net>'
        message['resent_sender'] = 'mikel@resent-sender.lindsaar.net'
        message['resent_to'] =     'mikel@resent-to.lindsaar.net'
        message['sender'] =        'mikel@sender.lindsaar.net'
        message['subject'] =       'Hello there Mikel'
        message['to'] =            'mikel@to.lindsaar.net'
        message['body'] =          'This is a body of text'
        
        message.bcc.to_s.should           == 'mikel@bcc.lindsaar.net'
        message.cc.to_s.should            == 'mikel@cc.lindsaar.net'
        message.comments.to_s.should      == 'this is a comment'
        message.date.to_s.should          == '12 Aug 2009 00:00:01 GMT'
        message.from.to_s.should          == 'mikel@from.lindsaar.net'
        message.in_reply_to.to_s.should   == '<1234@in_reply_to.lindsaar.net>'
        message.keywords.to_s.should      == 'test, "of the new mail", system'
        message.message_id.to_s.should    == '<1234@message_id.lindsaar.net>'
        message.received.to_s.should      == '12 Aug 2009 00:00:02 GMT'
        message.references.to_s.should    == '<1234@references.lindsaar.net>'
        message.reply_to.to_s.should      == 'mikel@reply-to.lindsaar.net'
        message.resent_bcc.to_s.should    == 'mikel@resent-bcc.lindsaar.net'
        message.resent_cc.to_s.should     == 'mikel@resent-cc.lindsaar.net'
        message.resent_date.to_s.should   == '12 Aug 2009 00:00:03 GMT'
        message.resent_from.to_s.should   == 'mikel@resent-from.lindsaar.net'
        message.resent_message_id.to_s.should == '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender.to_s.should == 'mikel@resent-sender.lindsaar.net'
        message.resent_to.to_s.should     == 'mikel@resent-to.lindsaar.net'
        message.sender.to_s.should        == 'mikel@sender.lindsaar.net'
        message.subject.to_s.should       == 'Hello there Mikel'
        message.to.to_s.should            == 'mikel@to.lindsaar.net'
        message.body.to_s.should          == 'This is a body of text'
      end

    end
    
  end

  describe "output" do
    
    it "should make an email and allow you to call :to_s on it to get a string" do
      mail = Mail.new do
           from 'mikel@test.lindsaar.net'
             to 'you@test.lindsaar.net'
        subject 'This is a test email'
           body 'This is a body of the email'
      end
      result =""
      
      mail.to_s.should =~ /From: mikel@test.lindsaar.net\r\n/
      mail.to_s.should =~ /To: you@test.lindsaar.net\r\n/
      mail.to_s.should =~ /Subject: This is a test email\r\n/
      mail.to_s.should =~ /This is a body of the email/

    end
  
  end
  
  describe "handling missing required fields:" do
    
    describe "Message-ID" do
      it "should say if it has a message id" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.should_not be_has_message_id
      end

      it "should preserve any message id that you pass it if add_message_id is called explicitly" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.add_message_id("ThisIsANonUniqueMessageId")
        mail.to_s.should =~ /Message-ID: ThisIsANonUniqueMessageId\r\n/
      end

      it "should generate a random message ID if nothing is passed to add_message_id" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.add_message_id
        fqdn ||= ::Socket.gethostname
        mail.to_s.should =~ /Message-ID: <[\d\w_]+@#{fqdn}.mail>\r\n/
      end

      it "should make an email and inject a message ID if none was set if told to_s" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        (mail.to_s =~ /Message-ID: <.+@.+.mail>/i).should_not be_nil      
      end

      it "should add the message id to the message permanently once sent to_s" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.to_s
        mail.should be_has_message_id
      end
    end

    
    describe "Date" do
      it "should say if it has a date" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.should_not be_has_date
      end

      it "should preserve any date that you pass it if add_date is called explicitly" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.add_date("Mon, 24 Nov 1997 14:22:01 -0800")
        mail.to_s.should =~ /Date: Mon, 24 Nov 1997 14:22:01 -0800/
      end

      it "should generate a current date if nothing is passed to add_date" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.add_date
        mail.to_s.should =~ /Date: \w{3}, [\s\d]\d \w{3} \d{4} \d{2}:\d{2}:\d{2} [-+]?\d{4}\r\n/
      end

      it "should make an email and inject a date if none was set if told to_s" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.to_s.should =~ /Date: \w{3}, [\s\d]\d \w{3} \d{4} \d{2}:\d{2}:\d{2} [-+]?\d{4}\r\n/
      end

      it "should add the message id to the message permanently once sent to_s" do
        mail = Mail.new do
             from 'mikel@test.lindsaar.net'
               to 'you@test.lindsaar.net'
          subject 'This is a test email'
             body 'This is a body of the email'
        end
        mail.to_s
        mail.should be_has_date
      end
    end
    
  end

  describe "RFC2822 Test Emails" do

    # From RFC 2822:
    # This could be called a canonical message.  It has a single author,
    # John Doe, a single recipient, Mary Smith, a subject, the date, a
    # message identifier, and a textual message in the body.
    it "should handle the basic test email" do
      email =<<EMAILEND
From: John Doe <jdoe@machine.example>
To: Mary Smith <mary@example.net>
Subject: Saying Hello
Date: Fri, 21 Nov 1997 09:55:06 -0600
Message-ID: <1234@local.machine.example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.formatted.should == ['John Doe <jdoe@machine.example>']
      mail.to.formatted.should == ['Mary Smith <mary@example.net>']
      mail.message_id.to_s.should == '<1234@local.machine.example>'
      mail.date.date_time.should == ::DateTime.parse('21 Nov 1997 09:55:06 -0600')
      mail.subject.to_s.should == 'Saying Hello'
    end

    # From RFC 2822:
    # If John's secretary Michael actually sent the message, though John
    # was the author and replies to this message should go back to him, the
    # sender field would be used:
    it "should handle the sender test email" do
      email =<<EMAILEND
From: John Doe <jdoe@machine.example>
Sender: Michael Jones <mjones@machine.example>
To: Mary Smith <mary@example.net>
Subject: Saying Hello
Date: Fri, 21 Nov 1997 09:55:06 -0600
Message-ID: <1234@local.machine.example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.formatted.should == ['John Doe <jdoe@machine.example>']
      mail.sender.formatted.should == ['Michael Jones <mjones@machine.example>']
      mail.to.formatted.should == ['Mary Smith <mary@example.net>']
      mail.message_id.to_s.should == '<1234@local.machine.example>'
      mail.date.date_time.should == ::DateTime.parse('21 Nov 1997 09:55:06 -0600')
      mail.subject.to_s.should == 'Saying Hello'
    end

    # From RFC 2822:
    # This message includes multiple addresses in the destination fields
    # and also uses several different forms of addresses.
    #
    # Note that the display names for Joe Q. Public and Giant; "Big" Box
    # needed to be enclosed in double-quotes because the former contains
    # the period and the latter contains both semicolon and double-quote
    # characters (the double-quote characters appearing as quoted-pair
    # construct).  Conversely, the display name for Who? could appear
    # without them because the question mark is legal in an atom.  Notice
    # also that jdoe@example.org and boss@nil.test have no display names
    # associated with them at all, and jdoe@example.org uses the simpler
    # address form without the angle brackets.
    it "should handle multiple recipients test email" do
      email =<<EMAILEND
From: "Joe Q. Public" <john.q.public@example.com>
To: Mary Smith <mary@x.test>, jdoe@example.org, Who? <one@y.test>
Cc: <boss@nil.test>, "Giant; \"Big\" Box" <sysservices@example.net>
Date: Tue, 1 Jul 2003 10:52:37 +0200
Message-ID: <5678.21-Nov-1997@example.com>

Hi everyone.
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.formatted.should == ['"Joe Q. Public" <john.q.public@example.com>']
      mail.to.formatted.should == ['Mary Smith <mary@x.test>', 'jdoe@example.org', 'Who? <one@y.test>']
      mail.cc.formatted.should == ['boss@nil.test', '"Giant; \"Big\" Box" <sysservices@example.net>']
      mail.message_id.to_s.should == '<5678.21-Nov-1997@example.com>'
      mail.date.date_time.should == ::DateTime.parse('1 Jul 2003 10:52:37 +0200')
    end

    # From RFC 2822:
    # A.1.3. Group addresses
    # In this message, the "To:" field has a single group recipient named A
    # Group which contains 3 addresses, and a "Cc:" field with an empty
    # group recipient named Undisclosed recipients.
    it "should handle group address email test" do
      email =<<EMAILEND
From: Pete <pete@silly.example>
To: A Group:Chris Jones <c@a.test>,joe@where.test,John <jdoe@one.test>;
Cc: Undisclosed recipients:;
Date: Thu, 13 Feb 1969 23:32:54 -0330
Message-ID: <testabcd.1234@silly.example>

Testing.
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.formatted.should == ['Pete <pete@silly.example>']
      mail.to.formatted.should == ['Chris Jones <c@a.test>', 'joe@where.test', 'John <jdoe@one.test>']
      mail.cc.group_names.should == ['Undisclosed recipients']
      mail.message_id.to_s.should == '<testabcd.1234@silly.example>'
      mail.date.date_time.should == ::DateTime.parse('Thu, 13 Feb 1969 23:32:54 -0330')
    end


    # From RFC 2822:
    # A.2. Reply messages
    # The following is a series of three messages that make up a
    # conversation thread between John and Mary.  John firsts sends a
    # message to Mary, Mary then replies to John's message, and then John
    # replies to Mary's reply message.
    # 
    # Note especially the "Message-ID:", "References:", and "In-Reply-To:"
    # fields in each message.
    it "should handle reply messages" do
      email =<<EMAILEND
From: John Doe <jdoe@machine.example>
To: Mary Smith <mary@example.net>
Subject: Saying Hello
Date: Fri, 21 Nov 1997 09:55:06 -0600
Message-ID: <1234@local.machine.example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.addresses.should == ['jdoe@machine.example']
      mail.to.addresses.should == ['mary@example.net']
      mail.subject.to_s.should == 'Saying Hello'
      mail.message_id.to_s.should == '<1234@local.machine.example>'
      mail.date.date_time.should == ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
    end

    # From RFC 2822:
    # When sending replies, the Subject field is often retained, though
    # prepended with "Re: " as described in section 3.6.5.
    # Note the "Reply-To:" field in the below message.  When John replies
    # to Mary's message above, the reply should go to the address in the
    # "Reply-To:" field instead of the address in the "From:" field.
    it "should handle reply message 2" do
      email =<<EMAILEND
From: Mary Smith <mary@example.net>
To: John Doe <jdoe@machine.example>
Reply-To: "Mary Smith: Personal Account" <smith@home.example>
Subject: Re: Saying Hello
Date: Fri, 21 Nov 1997 10:01:10 -0600
Message-ID: <3456@example.net>
In-Reply-To: <1234@local.machine.example>
References: <1234@local.machine.example>

This is a reply to your hello.
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.addresses.should == ['mary@example.net']
      mail.to.addresses.should == ['jdoe@machine.example']
      mail.reply_to.addresses.should == ['smith@home.example']
      mail.subject.to_s.should == 'Re: Saying Hello'
      mail.message_id.to_s.should == '<3456@example.net>'
      mail.in_reply_to.message_ids.should == ['1234@local.machine.example']
      mail.references.message_ids.should == ['1234@local.machine.example']
      mail.date.date_time.should == ::DateTime.parse('Fri, 21 Nov 1997 10:01:10 -0600')
    end

    # From RFC 2822:
    # Final reply message
    it "should handle the final reply message" do
      email =<<EMAILEND
To: "Mary Smith: Personal Account" <smith@home.example>
From: John Doe <jdoe@machine.example>
Subject: Re: Saying Hello
Date: Fri, 21 Nov 1997 11:00:00 -0600
Message-ID: <abcd.1234@local.machine.tld>
In-Reply-To: <3456@example.net>
References: <1234@local.machine.example> <3456@example.net>

This is a reply to your reply.
EMAILEND
      mail = Mail::Message.new(email)
      mail.to.addresses.should == ['smith@home.example']
      mail.from.addresses.should == ['jdoe@machine.example']
      mail.subject.to_s.should == 'Re: Saying Hello'
      mail.date.date_time.should == ::DateTime.parse('Fri, 21 Nov 1997 11:00:00 -0600')
      mail.message_id.to_s.should == '<abcd.1234@local.machine.tld>'
      mail.in_reply_to.to_s.should == '<3456@example.net>'
      mail.references.message_ids.should == ['1234@local.machine.example', '3456@example.net']
    end

    # From RFC2822
    # A.3. Resent messages
    # Say that Mary, upon receiving this message, wishes to send a copy of
    # the message to Jane such that (a) the message would appear to have
    # come straight from John; (b) if Jane replies to the message, the
    # reply should go back to John; and (c) all of the original
    # information, like the date the message was originally sent to Mary,
    # the message identifier, and the original addressee, is preserved.  In
    # this case, resent fields are prepended to the message:
    #
    # If Jane, in turn, wished to resend this message to another person,
    # she would prepend her own set of resent header fields to the above
    # and send that.
    it "should handle the rfc resent example email" do
      email =<<EMAILEND
Resent-From: Mary Smith <mary@example.net>
Resent-To: Jane Brown <j-brown@other.example>
Resent-Date: Mon, 24 Nov 1997 14:22:01 -0800
Resent-Message-ID: <78910@example.net>
From: John Doe <jdoe@machine.example>
To: Mary Smith <mary@example.net>
Subject: Saying Hello
Date: Fri, 21 Nov 1997 09:55:06 -0600
Message-ID: <1234@local.machine.example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      mail = Mail::Message.new(email)
      mail.resent_from.addresses.should == ['mary@example.net']
      mail.resent_to.addresses.should == ['j-brown@other.example']
      mail.resent_date.date_time.should == ::DateTime.parse('Mon, 24 Nov 1997 14:22:01 -0800')
      mail.resent_message_id.to_s.should == '<78910@example.net>'
      mail.from.addresses.should == ['jdoe@machine.example']
      mail.to.addresses.should == ['mary@example.net']
      mail.subject.to_s.should == 'Saying Hello'
      mail.date.date_time.should == ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
      mail.message_id.to_s.should == '<1234@local.machine.example>'
    end

    # A.4. Messages with trace fields
    # As messages are sent through the transport system as described in
    # [RFC2821], trace fields are prepended to the message.  The following
    # is an example of what those trace fields might look like.  Note that
    # there is some folding white space in the first one since these lines
    # can be long.
    it "should handle the RFC trace example email" do
      email =<<EMAILEND
Received: from x.y.test
   by example.net
   via TCP
   with ESMTP
   id ABC12345
   for <mary@example.net>;  21 Nov 1997 10:05:43 -0600
Received: from machine.example by x.y.test; 21 Nov 1997 10:01:22 -0600
From: John Doe <jdoe@machine.example>
To: Mary Smith <mary@example.net>
Subject: Saying Hello
Date: Fri, 21 Nov 1997 09:55:06 -0600
Message-ID: <1234@local.machine.example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      mail = Mail::Message.new(email)
      mail.received[0].info.should == 'from x.y.test by example.net via TCP with ESMTP id ABC12345 for <mary@example.net>'
      mail.received[0].date_time.should == ::DateTime.parse('21 Nov 1997 10:05:43 -0600')
      mail.received[1].info.should == 'from machine.example by x.y.test'
      mail.received[1].date_time.should == ::DateTime.parse('21 Nov 1997 10:01:22 -0600')
      mail.from.addresses.should == ['jdoe@machine.example']
      mail.to.addresses.should == ['mary@example.net']
      mail.subject.to_s.should == 'Saying Hello'
      mail.date.date_time.should == ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
      mail.message_id.to_s.should == '<1234@local.machine.example>'
    end

    # A.5. White space, comments, and other oddities
    # White space, including folding white space, and comments can be
    # inserted between many of the tokens of fields.  Taking the example
    # from A.1.3, white space and comments can be inserted into all of the
    # fields.
    #
    # The below example is aesthetically displeasing, but perfectly legal.
    # Note particularly (1) the comments in the "From:" field (including
    # one that has a ")" character appearing as part of a quoted-pair); (2)
    # the white space absent after the ":" in the "To:" field as well as
    # the comment and folding white space after the group name, the special
    # character (".") in the comment in Chris Jones's address, and the
    # folding white space before and after "joe@example.org,"; (3) the
    # multiple and nested comments in the "Cc:" field as well as the
    # comment immediately following the ":" after "Cc"; (4) the folding
    # white space (but no comments except at the end) and the missing
    # seconds in the time of the date field; and (5) the white space before
    # (but not within) the identifier in the "Message-ID:" field.
    it "should handle the rfc whitespace test email" do
      email =<<EMAILEND
From: Pete(A wonderful \\) chap) <pete(his account)@silly.test(his host)>
To:A Group(Some people)
     :Chris Jones <c@(Chris's host.)public.example>,
         joe@example.org,
  John <jdoe@one.test> (my dear friend); (the end of the group)
Cc:(Empty list)(start)Undisclosed recipients  :(nobody(that I know))  ;
Date: Thu,
      13
        Feb
          1969
      23:32
               -0330 (Newfoundland Time)
Message-ID:              <testabcd.1234@silly.test>

Testing.
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.addresses.should == ['pete(his account)@silly.test']
      mail.to.addresses.should == ["c@(Chris's host.)public.example", 'joe@example.org', 'jdoe@one.test']
      mail.cc.group_names.should == ['(Empty list)(start)Undisclosed recipients ']
      mail.date.date_time.should == ::DateTime.parse('Thu, 13 Feb 1969 23:32 -0330')
      mail.message_id.to_s.should == '<testabcd.1234@silly.test>'
    end

    # A.6. Obsoleted forms
    # The following are examples of obsolete (that is, the "MUST NOT
    # generate") syntactic elements described in section 4 of this
    # document.
    # A.6.1. Obsolete addressing
    # Note in the below example the lack of quotes around Joe Q. Public,
    # the route that appears in the address for Mary Smith, the two commas
    # that appear in the "To:" field, and the spaces that appear around the
    # "." in the jdoe address.
    it "should handle the rfc obsolete addressing" do
      pending
      email =<<EMAILEND
From: Joe Q. Public <john.q.public@example.com>
To: Mary Smith <@machine.tld:mary@example.net>, , jdoe@test   . example
Date: Tue, 1 Jul 2003 10:52:37 +0200
Message-ID: <5678.21-Nov-1997@example.com>

Hi everyone.
EMAILEND
      mail = Mail::Message.new(email)
      mail.from.addresses.should == ['john.q.public@example.com']
      mail.from.formatted.should == ['"Joe Q. Public" <john.q.public@example.com>']
      mail.to.addresses.should == ["@machine.tld:mary@example.net", 'jdoe@test.example']
      mail.date.date_time.should == ::DateTime.parse('Tue, 1 Jul 2003 10:52:37 +0200')
      mail.message_id.to_s.should == '<5678.21-Nov-1997@example.com>'
    end

    # A.6.2. Obsolete dates
    # 
    # The following message uses an obsolete date format, including a non-
    # numeric time zone and a two digit year.  Note that although the
    # day-of-week is missing, that is not specific to the obsolete syntax;
    # it is optional in the current syntax as well.
    it "should handle the rfc obsolete dates" do
      pending
      email =<<EMAILEND
From: John Doe <jdoe@machine.example>
To: Mary Smith <mary@example.net>
Subject: Saying Hello
Date: 21 Nov 97 09:55:06 GMT
Message-ID: <1234@local.machine.example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      doing { Mail::Message.new(email) }.should_not raise_error
    end

    # A.6.3. Obsolete white space and comments
    # 
    # White space and comments can appear between many more elements than
    # in the current syntax.  Also, folding lines that are made up entirely
    # of white space are legal.
    # 
    # Note especially the second line of the "To:" field.  It starts with
    # two space characters.  (Note that "__" represent blank spaces.)
    # Therefore, it is considered part of the folding as described in
    # section 4.2.  Also, the comments and white space throughout
    # addresses, dates, and message identifiers are all part of the
    # obsolete syntax.
    it "should handle the rfc obsolete whitespace email" do
      pending
      email =<<EMAILEND
From  : John Doe <jdoe@machine(comment).  example>
To    : Mary Smith
__
          <mary@example.net>
Subject     : Saying Hello
Date  : Fri, 21 Nov 1997 09(comment):   55  :  06 -0600
Message-ID  : <1234   @   local(blah)  .machine .example>

This is a message just to say hello.
So, "Hello".
EMAILEND
      doing { Mail::Message.new(email) }.should_not raise_error
    end

  end

  describe "handling wild emails" do
    
    it "should return an 'encoded' version without raising a SystemStackError" do
      message = Mail::Message.new(File.read(fixture('emails/raw_email_encoded_stack_level_too_deep')))
      doing { message.encoded }.should_not raise_error
    end
    
  end

  describe "MIME Emails" do
    it "should read a mime version from an email" do
      mail = Mail.new("Mime-Version: 1.0")
      mail.mime_version.should == '1.0'
    end
    
    it "should return nil if the email has no mime version" do
      mail = Mail.new("To: bob")
      mail.mime_version.should == nil
    end
    
    it "should read the content-transfer-encoding" do
      mail = Mail.new("Content-Transfer-Encoding: quoted-printable")
      mail.transfer_encoding.should == 'quoted-printable'
    end
    
    it "should read the content-description" do
      mail = Mail.new("Content-Description: This is a description")
      mail.description.should == 'This is a description'
    end
    
    it "should return the content-type" do
      mail = Mail.new("Content-Type: text/plain")
      mail.content_type.should == 'text/plain'
    end
    
    it "should return the main content-type" do
      mail = Mail.new("Content-Type: text/plain")
      mail.main_type.should == 'text'
    end
    
    it "should return the sub content-type" do
      mail = Mail.new("Content-Type: text/plain")
      mail.sub_type.should == 'plain'
    end
    
    it "should return the content-type parameters" do
      mail = Mail.new("Content-Type: text/plain; charset=US-ASCII; format=flowed")
      mail.mime_parameters.should == {'charset' => 'US-ASCII', 'format' => 'flowed'}
    end
    
  end
  
end
