# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::MessageIdField do

  describe "initialization" do

    it "should initialize" do
      doing { Mail::MessageIdField.new("<1234@test.lindsaar.net>") }.should_not raise_error
    end

    it "should accept two strings with the field separate" do
      t = Mail::MessageIdField.new('Message-ID', '<1234@test.lindsaar.net>')
      t.name.should == 'Message-ID'
      t.value.should == '<1234@test.lindsaar.net>'
      t.message_id.should == '1234@test.lindsaar.net'
    end

    it "should accept a string with the field name" do
      t = Mail::MessageIdField.new('Message-ID: <1234@test.lindsaar.net>')
      t.name.should == 'Message-ID'
      t.value.should == '<1234@test.lindsaar.net>'
      t.message_id.should == '1234@test.lindsaar.net'
    end

    it "should accept a string without the field name" do
      t = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      t.name.should == 'Message-ID'
      t.value.should == '<1234@test.lindsaar.net>'
      t.message_id.should == '1234@test.lindsaar.net'
    end
  end

  describe "instance methods" do
    it "should provide to_s" do
      t = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      t.to_s.should == '<1234@test.lindsaar.net>'
      t.message_id.to_s.should == '1234@test.lindsaar.net'
    end

    it "should provide encoded" do
      t = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      t.encoded.should == "Message-ID: <1234@test.lindsaar.net>\r\n"
    end
  end

  
end
