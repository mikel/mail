# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe "Sendable" do
  
  before(:each) do
    @sendable = Class.new do
      include Mail::Sendable
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
    
    @sendable.new.deliver(from, to, rfc8222)
    
    MockSMTP.deliveries[0][0].should == rfc8222
    MockSMTP.deliveries[0][1].should == from
    MockSMTP.deliveries[0][2].should == to
  end
  
  it "should send emails and get from/to/rfc8222 for the includer object" do
    sendable = @sendable.new
    sendable.from = Mail::FromField.new('marcel@amont.com')
    sendable.to = Mail::ToField.new('marcel@amont.com')
    sendable.encoded = 'really invalide RFC8222'
    
    sendable.deliver
    
    MockSMTP.deliveries[0][0].should == sendable.encoded
    MockSMTP.deliveries[0][1].should == sendable.from.addresses.first
    MockSMTP.deliveries[0][2].should == sendable.to.addresses
  end
  
end
