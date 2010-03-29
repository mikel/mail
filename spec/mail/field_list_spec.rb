require 'spec_helper'

describe Mail::FieldList do
  it "should be able to add new fields" do
    fl = Mail::FieldList.new
    fl << Mail::Field.new("To: mikel@me.com")
    fl << Mail::Field.new("From: mikel@me.com")
    fl.length.should == 2
  end
  
  it "should be able to add new fields in the right order" do
    fl = Mail::FieldList.new
    fl << Mail::Field.new("To: mikel@me.com")
    fl << Mail::Field.new("From: mikel@me.com")
    fl << Mail::Field.new("Received: from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500")
    fl << Mail::Field.new("Return-Path: mikel@me.com")
    fl[0].field.class.should == Mail::ReturnPathField
    fl[1].field.class.should == Mail::ReceivedField
    fl[2].field.class.should == Mail::FromField
    fl[3].field.class.should == Mail::ToField
  end
  
  it "should add new Received items after the existing ones" do
    fl = Mail::FieldList.new
    fl << Mail::Field.new("To: mikel@me.com")
    fl << Mail::Field.new("From: mikel@me.com")
    fl << Mail::Field.new("Received: from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500")
    fl << Mail::Field.new("Return-Path: mikel@me.com")
    fl << Mail::Field.new("Received: from 123.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500")
    fl[2].field.value.should == 'from 123.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500'
  end
  
end
