# encoding: utf-8
require 'spec_helper'

describe "Ruby 1.8 Extensions" do
  
  describe "string ascii detection" do
    it "should say it is US-ASCII only if it is" do
      "abc".should be_ascii_only
    end
    
    it "should not say it is US-ASCII only if it isn't" do
      "かきくけこ".should_not be_ascii_only
    end
    
    it "should not say it is US-ASCII only if it is a mix" do
      "abcかきくけこ123".should_not be_ascii_only
    end
    
    it "should handle edge cases" do
      ["\x00", "\x01", "\x40", "\x7f", "\x73"].each do |str|
        str.should be_ascii_only
      end

      ["\x81", "\x99", "\xFF"].each do |str|
        str.should_not be_ascii_only
      end

    end
  end
end


