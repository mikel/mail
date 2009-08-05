# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::ResentDateField do
  it "should initialize" do
    doing { Mail::ResentDateField.new("12 Aug 2009 00:00:02 GMT") }.should_not raise_error
  end
end
