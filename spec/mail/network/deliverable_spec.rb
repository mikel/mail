# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe "Deliverable" do

  before(:each) do
    @deliverable = Class.new do
      include Mail::Deliverable
      attr_accessor :from, :to, :encoded
    end
  end
  
  describe "general usage" do

    before(:each) do
      config = Mail.defaults do
        smtp 'smtp.mockup.com', 587
        enable_tls
      end
    end

    it "should send emails from given settings" do
      from = 'roger@moore.com'
      to = 'marcel@amont.com'
      rfc2822 = 'invalid RFC2822'

      @deliverable.new.deliver!(from, to, rfc2822)

      MockSMTP.deliveries[0][0].should == rfc2822
      MockSMTP.deliveries[0][1].should == from
      MockSMTP.deliveries[0][2].should == to
    end

    it "should send emails and get from/to/rfc2822 for the includer object" do
      deliverable = @deliverable.new
      deliverable.from = Mail::FromField.new('marcel@amont.com')
      deliverable.to = Mail::ToField.new('marcel@amont.com')
      deliverable.encoded = 'really invalid RFC2822'

      deliverable.deliver!

      MockSMTP.deliveries[0][0].should == deliverable.encoded
      MockSMTP.deliveries[0][1].should == deliverable.from.addresses.first
      MockSMTP.deliveries[0][2].should == deliverable.to.addresses
    end

    it "should raise if the SMTP configuration is not set" do
      config = Mail.defaults do
        smtp ''
      end

      doing { @deliverable.new.deliver! }.should raise_error
    end
    
  end
    
  describe "enabling tls" do
    
    def redefine_verify_none(new_value)
      OpenSSL::SSL.send(:remove_const, :VERIFY_NONE)
      OpenSSL::SSL.send(:const_set, :VERIFY_NONE, new_value)
    end
    
    it "should use OpenSSL::SSL::VERIFY_NONE if a context" do

      # config can't be setup until redefined
      redefine_verify_none(OpenSSL::SSL::SSLContext.new)
      config = Mail.defaults do
        smtp 'smtp.mockup.com', 587
        enable_tls
      end

      deliverable = @deliverable.new
      deliverable.from = Mail::FromField.new('marcel@amont.com')
      deliverable.to = Mail::ToField.new('marcel@amont.com')
      deliverable.encoded = 'really invalid RFC2822'

      lambda{deliverable.deliver!}.should_not raise_error(TypeError)
    end
    
    it "should ignore OpenSSL::SSL::VERIFY_NONE if it is 0" do

      # config can't be setup until redefined
      redefine_verify_none(0)
      config = Mail.defaults do
        smtp 'smtp.mockup.com', 587
        enable_tls
      end

      deliverable = @deliverable.new
      deliverable.from = Mail::FromField.new('marcel@amont.com')
      deliverable.to = Mail::ToField.new('marcel@amont.com')
      deliverable.encoded = 'really invalid RFC2822'

      lambda{deliverable.deliver!}.should_not raise_error(TypeError)      
    end
    
  end
  
end
