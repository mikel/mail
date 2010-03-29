# encoding: utf-8
require 'spec_helper'

describe Mail::CommentsField do
  # 
  # comments        =       "Comments:" unstructured CRLF
  
  it "should initialize" do
    doing { Mail::CommentsField.new("this is a comment") }.should_not raise_error
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
