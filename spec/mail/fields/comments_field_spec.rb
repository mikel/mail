# encoding: utf-8
require 'spec_helper'

describe Mail::CommentsField do
  # 
  # comments        =       "Comments:" unstructured CRLF
  
  it "should initialize" do
    expect(doing { Mail::CommentsField.new("this is a comment") }).not_to raise_error
  end

  it "should accept a string with the field name" do
    t = Mail::CommentsField.new('Comments: this is a comment')
    expect(t.name).to eq 'Comments'
    expect(t.value).to eq 'this is a comment'
  end

  it "should accept a string with the field name" do
    t = Mail::CommentsField.new('this is a comment')
    expect(t.name).to eq 'Comments'
    expect(t.value).to eq 'this is a comment'
  end
  
  
end
