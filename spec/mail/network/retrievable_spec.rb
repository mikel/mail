# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe "Retrievable" do
  
  before(:each) do
    @retrievable = Class.new do
      include Mail::Retrievable
      
      attr_reader :raw_data
      def initialize(raw_data)
        @raw_data = raw_data
      end
    end
    
    config = Mail.defaults do
      pop3 'pop3.mockup.com', 587
      enable_tls
    end
  end
  
  it "should get emails with a given block" do
    MockPOP3.should_not be_started
    
    messages = []
    @retrievable.pop3_get_all_mail do |message|
      messages << message
    end
    
    MockPOP3.popmails.collect {|p| p.pop}.sort.should == messages.collect {|m| m.raw_data}.sort
    MockPOP3.should_not be_started
  end

  it "should get emails without a given block" do
    MockPOP3.should_not be_started
    
    messages = @retrievable.pop3_get_all_mail
    
    MockPOP3.popmails.collect {|p| p.pop}.sort.should == messages.collect {|m| m.raw_data}.sort
    MockPOP3.should_not be_started
  end

  it "should finish the POP3 connection is an exception is raised" do
    MockPOP3.should_not be_started
    
    doing do
      @retrievable.pop3_get_all_mail { |m| raise ArgumentError.new }
    end.should raise_error
    
    MockPOP3.should_not be_started
  end
  
  it "should raise if the POP3 configuration is not set" do
    config = Mail.defaults do
      pop3 ''
    end
    
    doing { @retrievable.pop3_get_all_mail }.should raise_error
  end
  
end
