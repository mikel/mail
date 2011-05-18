# encoding: utf-8
require 'spec_helper'
# 
#    The "In-Reply-To:" field will contain the contents of the "Message-
#    ID:" field of the message to which this one is a reply (the "parent
#    message").  If there is more than one parent message, then the "In-
#    Reply-To:" field will contain the contents of all of the parents'
#    "Message-ID:" fields.  If there is no "Message-ID:" field in any of
#    the parent messages, then the new message will have no "In-Reply-To:"
#    field.

describe Mail::InReplyToField do

  describe "initialization" do
    it "should initialize" do
      doing { Mail::InReplyToField.new("<1234@test.lindsaar.net>") }.should_not raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::InReplyToField.new('In-Reply-To: <1234@test.lindsaar.net>')
      t.name.should == 'In-Reply-To'
      t.value.should == '<1234@test.lindsaar.net>'
      t.message_id.should == '1234@test.lindsaar.net'
    end

    it "should accept a string without the field name" do
      t = Mail::InReplyToField.new('<1234@test.lindsaar.net>')
      t.name.should == 'In-Reply-To'
      t.value.should == '<1234@test.lindsaar.net>'
      t.message_id.should == '1234@test.lindsaar.net'
    end
    
    it "should provide encoded" do
      t = Mail::InReplyToField.new('<1234@test.lindsaar.net>')
      t.encoded.should == "In-Reply-To: <1234@test.lindsaar.net>\r\n"
    end
    
    it "should handle many encoded message IDs" do
      t = Mail::InReplyToField.new('<1234@test.lindsaar.net> <4567@test.lindsaar.net>')
      t.encoded.should == "In-Reply-To: <1234@test.lindsaar.net> <4567@test.lindsaar.net>\r\n"
    end

    it "should provide decoded" do
      t = Mail::InReplyToField.new('<1234@test.lindsaar.net>')
      t.decoded.should == "<1234@test.lindsaar.net>"
    end
    
    it "should handle many decoded message IDs" do
      t = Mail::InReplyToField.new('<1234@test.lindsaar.net> <4567@test.lindsaar.net>')
      t.decoded.should == '<1234@test.lindsaar.net> <4567@test.lindsaar.net>'
    end
    
    it "should handle an empty value" do
      t = Mail::InReplyToField.new('')
      t.name.should == 'In-Reply-To'
      t.decoded.should == nil
    end
    
  end

  describe "handlign multiple message ids" do
    it "should handle many message IDs" do
      t = Mail::InReplyToField.new('<1234@test.lindsaar.net> <4567@test.lindsaar.net>')
      t.name.should == 'In-Reply-To'
      t.message_ids.should == ['1234@test.lindsaar.net', '4567@test.lindsaar.net']
    end
  end
end
