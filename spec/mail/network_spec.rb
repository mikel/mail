# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe "Mail" do

  it "should accept a default POP3/SMTP configuration" do
    config = Mail.defaults do
      smtp 'smtp.myhost.com'
      pop3 'pop.myhost.com'
      user 'roger'
      pass 'moore'
      
      smtp.should == ['smtp.myhost.com', 25]
      pop3.should == ['pop.myhost.com', 110]
      user.should == 'roger'
      pass.should == 'moore'
      tls?.should == false
      
      enable_tls
      
      tls?.should == true
    end
    
    config.smtp.should == ['smtp.myhost.com', 25]
    config.pop3.should == ['pop.myhost.com', 110]
    config.user.should == 'roger'
    config.pass.should == 'moore'
    config.tls?.should == true
  end
  
  it "should send emails with SMTP" do
    config = Mail.defaults do
      smtp 'smtp.mockup.com', 587
      enable_tls
    end
    
    config.smtp.should == ['smtp.mockup.com', 587]
    config.tls?.should == true
    
    message = Mail.send do
      from 'roger@moore.com'
      to 'marcel@amont.com'
      subject 'Re: No way!'
      body 'Yeah sure'
      # add_file 'New Header Image', '/somefile.png'
    end
    
    MockSMTP.deliveries[0][0].should == message.encoded
    MockSMTP.deliveries[0][1].should == "roger@moore.com"
    MockSMTP.deliveries[0][2].should == ["marcel@amont.com"]
  end
  
end
