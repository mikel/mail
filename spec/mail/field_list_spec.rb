require 'spec_helper'

describe Mail::FieldList do
  it "should be able to add new fields" do
    fl = Mail::FieldList.new
    fl << Mail::Field.new("To: mikel@me.com")
    fl << Mail::Field.new("From: mikel@me.com")
    expect(fl.length).to eq 2
  end
  
  it "should be able to add new fields in the right order" do
    fl = Mail::FieldList.new
    fl << Mail::Field.new("To: mikel@me.com")
    fl << Mail::Field.new("From: mikel@me.com")
    fl << Mail::Field.new("Received: from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500")
    fl << Mail::Field.new("Return-Path: mikel@me.com")
    expect(fl[0].field.class).to eq Mail::ReturnPathField
    expect(fl[1].field.class).to eq Mail::ReceivedField
    expect(fl[2].field.class).to eq Mail::FromField
    expect(fl[3].field.class).to eq Mail::ToField
  end
  
  it "should add new Received items after the existing ones" do
    fl = Mail::FieldList.new
    fl << Mail::Field.new("To: mikel@me.com")
    fl << Mail::Field.new("From: mikel@me.com")
    fl << Mail::Field.new("Received: from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500")
    fl << Mail::Field.new("Return-Path: mikel@me.com")
    fl << Mail::Field.new("Received: from 123.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500")
    expect(fl[2].field.value).to eq 'from 123.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500'
  end
  
end
