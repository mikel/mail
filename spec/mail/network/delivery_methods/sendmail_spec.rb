# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', '..', 'spec_helper')

describe "sendmail delivery agent" do
  
  before(:each) do
    # Reset all defaults back to original state
    Mail.defaults do
      delivery_method :smtp, { :address              => "localhost",
                               :port                 => 25,
                               :domain               => 'localhost.localdomain',
                               :user_name            => nil,
                               :password             => nil,
                               :authentication       => nil,
                               :enable_starttls_auto => true  }
    end
  end

  it "should send an email using sendmail" do
    Mail.defaults do
      delivery_method :sendmail
    end
    
    mail = Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'invalid RFC2822'
    end
    
    Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail', 
                                              '-i -t', 
                                              'marcel@test.lindsaar.net bob@test.lindsaar.net', 
                                              mail)
    mail.deliver!
  end

  it "should send an email with a return-path using sendmail" do
    Mail.defaults do
      delivery_method :sendmail
    end
    
    mail = Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      return_path 'me@test.lindsaar.net'
      subject 'invalid RFC2822'
    end
    
    Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail', 
                                              '-i -t -f "me@test.lindsaar.net"', 
                                              'marcel@test.lindsaar.net bob@test.lindsaar.net', 
                                              mail)
    mail.deliver!
  end

  it "should still send an email if the settings have been set to nil" do
    Mail.defaults do
      delivery_method :sendmail, :arguments => nil
    end
    
    mail = Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'invalid RFC2822'
    end
    
    Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail', 
                                              '', 
                                              'marcel@test.lindsaar.net bob@test.lindsaar.net', 
                                              mail)
    mail.deliver!
  end
end