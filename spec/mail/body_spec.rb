# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Body do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Body.new}.should_not raise_error
    end
    
    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      body.to_s.should == 'this is some text'
    end
    
  end

end