# encoding: utf-8 
require File.dirname(__FILE__) + "/spec_helper"

require 'mail'

describe "mail" do
  
  it "should be able to be instantiated" do
    doing { Mail }.should_not raise_error
  end
  
  it "should be able to make a new email" do
    Mail.message.class.should == Mail::Message
  end
  
  it "should accept headers and body" do
    # Full test in Message Spec
    message = Mail.message do
      from    'mikel@me.com'
      to      'mikel@you.com'
      subject 'Hello there Mikel'
      resent_message_id '<1234@resent-id.lindsaar.net>'
      body    'This is a body of text'
    end
    message.from.should    == 'mikel@me.com'
    message.to.should      == 'mikel@you.com'
    message.subject.should == 'Hello there Mikel'
    message.body.to_s.should    == 'This is a body of text'
  end

  it "should be able to parse a basic email" do
    doing { Mail::Message.new(File.read(fixture('emails/basic_email'))) }.should_not raise_error
  end

  it "should be able to parse every email example we have without raising an exception" do
    emails = Dir.glob(File.join(File.dirname(__FILE__), 'fixtures/emails/*'))
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
    mail.to.should == "Mikel Lindsaar <raasdnil@gmail.com>"
  end
  
end