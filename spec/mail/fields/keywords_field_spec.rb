# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::KeywordsField do

  it "should initialize" do
    doing { Mail::KeywordsField.new("this, is, email") }.should_not raise_error
  end

end
