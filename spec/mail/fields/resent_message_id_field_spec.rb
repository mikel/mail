# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

describe Mail::ResentMessageIdField do

  it "should initialize" do
    doing { Mail::ResentMessageIdField.new("<1234@test.lindsaar.net>") }.should_not raise_error
  end

  it "should accept two strings with the field separate" do
    t = Mail::ResentMessageIdField.new('Resent-Message-ID', '<1234@test.lindsaar.net>')
    t.name.should == 'Resent-Message-ID'
    t.value.should == '<1234@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
  end

  it "should accept a string with the field name" do
    t = Mail::ResentMessageIdField.new('Resent-Message-ID: <1234@test.lindsaar.net>')
    t.name.should == 'Resent-Message-ID'
    t.value.should == '<1234@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
  end
  
  it "should accept a string without the field name" do
    t = Mail::ResentMessageIdField.new('<1234@test.lindsaar.net>')
    t.name.should == 'Resent-Message-ID'
    t.value.should == '<1234@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
  end

end
