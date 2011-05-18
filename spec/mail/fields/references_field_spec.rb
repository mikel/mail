# encoding: utf-8
require 'spec_helper'
# 
#    The "References:" field will contain the contents of the parent's
#    "References:" field (if any) followed by the contents of the parent's
#    "Message-ID:" field (if any).  If the parent message does not contain
#    a "References:" field but does have an "In-Reply-To:" field
#    containing a single message identifier, then the "References:" field
#    will contain the contents of the parent's "In-Reply-To:" field
#    followed by the contents of the parent's "Message-ID:" field (if
#    any).  If the parent has none of the "References:", "In-Reply-To:",
#    or "Message-ID:" fields, then the new message will have no
#    "References:" field.

describe Mail::ReferencesField do

  it "should initialize" do
    doing { Mail::ReferencesField.new("<1234@test.lindsaar.net>") }.should_not raise_error
  end

  it "should accept a string with the field name" do
    t = Mail::ReferencesField.new('References: <1234@test.lindsaar.net>')
    t.name.should == 'References'
    t.value.should == '<1234@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
  end
  
  it "should accept a string without the field name" do
    t = Mail::ReferencesField.new('<1234@test.lindsaar.net>')
    t.name.should == 'References'
    t.value.should == '<1234@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
  end

  it "should accept multiple message ids" do
    t = Mail::ReferencesField.new('<1234@test.lindsaar.net> <5678@test.lindsaar.net>')
    t.name.should == 'References'
    t.value.should == '<1234@test.lindsaar.net> <5678@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
    t.message_ids.should == ['1234@test.lindsaar.net', '5678@test.lindsaar.net']
    t.to_s.should == '<1234@test.lindsaar.net> <5678@test.lindsaar.net>'
  end

  it "should accept no message ids" do
    t = Mail::ReferencesField.new('')
    t.name.should == 'References'
    t.decoded.should == nil
  end

end
