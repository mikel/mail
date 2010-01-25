# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', '..', 'spec_helper')

describe "TestMailer" do
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
    Mail.deliveries.clear
  end

  it "should have no deliveries when first initiated" do
    Mail.defaults do
      delivery_method :test
    end
    Mail.deliveries.should be_empty
  end
  
  it "should deliver an email to the Mail.deliveries array" do
    Mail.defaults do
      delivery_method :test
    end
    mail = Mail.new do
      to 'mikel@me.com'
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
    mail.deliver
    Mail.deliveries.length.should == 1
    Mail.deliveries.first.should == mail
  end
  
  it "should clear the deliveries when told to" do
    Mail.defaults do
      delivery_method :test
    end
    mail = Mail.new do
      to 'mikel@me.com'
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
    mail.deliver
    Mail.deliveries.length.should == 1
    Mail.deliveries.clear
    Mail.deliveries.should be_empty
  end

end
