# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::CommentsField do
  it "should initialize" do
    doing { Mail::CommentsField.new("this is a comment") }.should_not raise_error
  end
end
