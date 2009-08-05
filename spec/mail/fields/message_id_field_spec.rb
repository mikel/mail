# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::MessageIdField do

  it "should initialize" do
    doing { Mail::MessageIdField.new("<1234@test.lindsaar.net>") }.should_not raise_error
  end
  
end
