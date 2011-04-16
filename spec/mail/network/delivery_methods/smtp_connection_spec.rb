# encoding: utf-8
require 'spec_helper'

describe "SMTP Delivery Method" do

  before(:each) do
    Mail.defaults do
      smtp = Net::SMTP.start('127.0.0.1', 25)
      delivery_method :smtp_connection, :connection => smtp
    end
  end
  
  after(:each) do
    Mail.delivery_method.smtp.finish
  end

  it "should send an email using open SMTP connection" do
    mail = Mail.deliver do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'invalid RFC2822'
    end

    MockSMTP.deliveries[0][0].should == mail.encoded
    MockSMTP.deliveries[0][1].should == mail.from[0]
    MockSMTP.deliveries[0][2].should == mail.destinations    
  end
  
  it "should be able to return actual SMTP protocol response" do
    Mail.defaults do
      smtp = Net::SMTP.start('127.0.0.1', 25)
      delivery_method :smtp_connection, :connection => smtp, :port => 587, :return_response => true
    end
    
    mail = Mail.deliver do
      from    'roger@moore.com'
      to      'marcel@amont.com'
      subject 'invalid RFC2822'
    end
    
    response = mail.deliver!
    response.should eql 'OK'
    
  end
  
  
end
