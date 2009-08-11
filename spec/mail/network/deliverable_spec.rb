# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe "Deliverable" do
  
  before(:each) do
    @deliverable = Class.new do
      include Mail::Deliverable
      attr_accessor :from, :to, :encoded
    end
    
    config = Mail.defaults do
      smtp 'smtp.mockup.com', 587
      enable_tls
    end
  end
  
  it "should send emails from given settings" do
    from = 'roger@moore.com'
    to = 'marcel@amont.com'
    rfc8222 = 'invalid RFC8222'
    
    @deliverable.new.deliver(from, to, rfc8222)
    
    MockSMTP.deliveries[0][0].should == rfc8222
    MockSMTP.deliveries[0][1].should == from
    MockSMTP.deliveries[0][2].should == to
  end
  
  it "should send emails and get from/to/rfc8222 for the includer object" do
    deliverable = @deliverable.new
    deliverable.from = Mail::FromField.new('marcel@amont.com')
    deliverable.to = Mail::ToField.new('marcel@amont.com')
    deliverable.encoded = 'really invalide RFC8222'
    
    deliverable.deliver
    
    MockSMTP.deliveries[0][0].should == deliverable.encoded
    MockSMTP.deliveries[0][1].should == deliverable.from.addresses.first
    MockSMTP.deliveries[0][2].should == deliverable.to.addresses
  end
  
  it "should raise if the SMTP configuration is not set" do
    config = Mail.defaults do
      smtp ''
    end
    
    doing { @deliverable.new.deliver }.should raise_error
  end
  
end
