# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

describe "Retrievable" do
  
  before(:each) do
    config = Mail.defaults do
      pop3 'pop3.mockup.com', 587 do
        enable_tls
      end
    end
  end
  
  it "should get emails with a given block" do
    MockPOP3.should_not be_started
    
    messages = []
    Mail.get_all_mail do |message|
      messages << message
    end
    
    MockPOP3.popmails.length.should == messages.length
    MockPOP3.should_not be_started
  end

  it "should get emails without a given block" do
    MockPOP3.should_not be_started
    
    messages = Mail.get_all_mail
    
    MockPOP3.popmails.length.should == messages.length
    MockPOP3.should_not be_started
  end

  it "should finish the POP3 connection is an exception is raised" do
    MockPOP3.should_not be_started
    
    doing do
      Mail.get_all_mail { |m| raise ArgumentError.new }
    end.should raise_error
    
    MockPOP3.should_not be_started
  end
  
  it "should raise if the POP3 configuration is not set" do
    config = Mail.defaults do
      pop3 ''
    end
    
    doing { Mail.get_all_mail }.should raise_error
  end
  
end
