# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::ReferencesField do

  it "should initialize" do
    doing { Mail::ReferencesField.new("<1234@test.lindsaar.net>") }.should_not raise_error
  end

  it "should accept two strings with the field separate" do
    t = Mail::ReferencesField.new('References', '<1234@test.lindsaar.net>')
    t.name.should == 'References'
    t.value.should == '<1234@test.lindsaar.net>'
    t.message_id.should == '1234@test.lindsaar.net'
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

end
