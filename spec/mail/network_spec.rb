# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe "Mail" do
  
  before(:each) do
    # Set the delivery method to test as the default
    MockSMTP.clear_deliveries
  end

  it "should provide a default network configuration without any setup" do
    config = Mail.defaults
    config.smtp.host.should_not be_blank
    config.smtp.port.should_not be_blank
  end
  
  it "should accept a default POP3/SMTP configuration" do
    config = Mail.defaults do
      delivery_method :smtp
      smtp 'smtp.myhost.com' do
        disable_tls
      end
      
      pop3 'pop.myhost.com' do
        user 'roger'
        pass 'moore'
        disable_tls
      end
      
      smtp.host.should == 'smtp.myhost.com'
      smtp.port.should == 25
      smtp.tls?.should == false
      pop3.host.should == 'pop.myhost.com'
      pop3.port.should == 110
      pop3.user.should == 'roger'
      pop3.pass.should == 'moore'
      pop3.tls?.should == false
      
      pop3 do 
        enable_tls
      end
      
      smtp do 
        enable_tls
      end
      
      smtp.host.should == 'smtp.myhost.com'
      smtp.port.should == 25
      smtp.tls?.should == true
      pop3.host.should == 'pop.myhost.com'
      pop3.port.should == 110
      pop3.user.should == 'roger'
      pop3.pass.should == 'moore'
      pop3.tls?.should == true
    end

  end
  
  it "should send emails with SMTP" do
    config = Mail.defaults do
      delivery_method :smtp
      smtp 'smtp.mockup.com', 587 do
        enable_tls
      end
    end
    
    config.smtp.host.should == 'smtp.mockup.com'
    config.smtp.port.should == 587
    config.smtp.tls?.should == true
    
    message = Mail.deliver do
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
  
  it "should retrieve all emails via POP3" do
    config = Mail.defaults do
      pop3 'pop.mockup.com' do
        enable_tls
      end
    end
    
    messages = Mail.get_all_mail
    
    messages.should_not be_empty
    for message in messages
      message.should be_instance_of(Mail::Message)
    end
  end
  
end
