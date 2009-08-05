# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::CommentsField do
  
  it "should initialize" do
    doing { Mail::CommentsField.new("this is a comment") }.should_not raise_error
  end
  
  it "should accept two strings with the field separate" do
    t = Mail::CommentsField.new('Comments', 'this is a comment')
    t.name.should == 'Comments'
    t.value.should == 'this is a comment'
  end

  it "should accept a string with the field name" do
    t = Mail::CommentsField.new('Comments: this is a comment')
    t.name.should == 'Comments'
    t.value.should == 'this is a comment'
  end

  it "should accept a string with the field name" do
    t = Mail::CommentsField.new('this is a comment')
    t.name.should == 'Comments'
    t.value.should == 'this is a comment'
  end
  
  
end
