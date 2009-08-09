# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::MessageIdField do

  describe "initialization" do

    it "should initialize" do
      doing { Mail::MessageIdField.new("<1234@test.lindsaar.net>") }.should_not raise_error
    end

    it "should accept two strings with the field separate" do
      m = Mail::MessageIdField.new('Message-ID', '<1234@test.lindsaar.net>')
      m.name.should == 'Message-ID'
      m.value.should == '<1234@test.lindsaar.net>'
      m.message_id.should == '1234@test.lindsaar.net'
    end

    it "should accept a string with the field name" do
      m = Mail::MessageIdField.new('Message-ID: <1234@test.lindsaar.net>')
      m.name.should == 'Message-ID'
      m.value.should == '<1234@test.lindsaar.net>'
      m.message_id.should == '1234@test.lindsaar.net'
    end

    it "should accept a string without the field name" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      m.name.should == 'Message-ID'
      m.value.should == '<1234@test.lindsaar.net>'
      m.message_id.should == '1234@test.lindsaar.net'
    end
  end

  describe "instance methods" do
    it "should provide to_s" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      m.to_s.should == '<1234@test.lindsaar.net>'
      m.message_id.to_s.should == '1234@test.lindsaar.net'
    end

    it "should provide encoded" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      m.encoded.should == "Message-ID: <1234@test.lindsaar.net>\r\n"
    end
    
    it "should respond to :responsible_for?" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      m.should respond_to(:responsible_for?)
    end
  end

  describe "generating a message id" do
    it "should generate a message ID if it has no value" do
      m = Mail::MessageIdField.new
      m.message_id.should_not be_blank
    end
    
    it "should generate a random message ID" do
      m = Mail::MessageIdField.new
      1.upto(100) do
        m.message_id.should_not == Mail::MessageIdField.new.message_id
      end
    end
  end
end
