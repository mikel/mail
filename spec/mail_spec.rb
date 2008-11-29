require File.dirname(__FILE__) + "/spec_helper"

require 'mail'

describe "mail" do
  
  it "should be able to be instantiated" do
    doing { Mail }.should_not raise_error
  end
  
  it "should be able to make a new email" do
    Mail.message.class.should == Mail::Message
  end
  
  it "should accept simple headers" do
    message = Mail.message do
      from    'mikel@me.com'
      to      'mikel@you.com'
      subject 'Hello there Mikel'
      body    'This is a body of text'
    end
    message.from.should    == 'mikel@me.com'
    message.to.should      == 'mikel@you.com'
    message.subject.should == 'Hello there Mikel'
    message.body.to_s.should    == 'This is a body of text'
  end

  it "should be able to arbitrarily set a header" do
    message = Mail::Message.new
    message['foo'] = '1234'
    message['foo'].should == '1234'
  end
  
end