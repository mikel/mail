# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe "Ruby 1.8 Extensions" do
  
  describe "string ascii detection" do
    it "should say it is US-ASCII only if it is" do
      expect("abc").to be_ascii_only
    end
    
    it "should not say it is US-ASCII only if it isn't" do
      expect("かきくけこ").not_to be_ascii_only
    end
    
    it "should not say it is US-ASCII only if it is a mix" do
      expect("abcかきくけこ123").not_to be_ascii_only
    end
    
    it "should handle edge cases" do
      ["\x00", "\x01", "\x40", "\x7f", "\x73"].each do |str|
        expect(str).to be_ascii_only
      end

      ["\x81", "\x99", "\xFF"].each do |str|
        expect(str).not_to be_ascii_only
      end

    end
  end
end


