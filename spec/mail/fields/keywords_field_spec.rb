# encoding: utf-8
require 'spec_helper'

describe Mail::KeywordsField do

  describe "initializing" do
    
    it "should initialize" do
      doing { Mail::KeywordsField.new("this, is, email") }.should_not raise_error
    end
    
    it "should accept a string with the field name" do
      k = Mail::KeywordsField.new('Keywords: these are keywords, so there')
      k.name.should == 'Keywords'
      k.value.should == 'these are keywords, so there'
    end
    
    it "should accept a string with the field name" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      k.name.should == 'Keywords'
      k.value.should == 'these are keywords, so there'
    end
    
  end
  
  describe "giving a list of keywords" do
    it "should return a list of keywords" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      k.keywords.should == ['these are keywords', 'so there']
    end
    
    it "should handle phrases" do
      k = Mail::KeywordsField.new('"these, are keywords", so there')
      k.keywords.should == ['these, are keywords', 'so there']
    end
    
    it "should handle comments" do
      k = Mail::KeywordsField.new('"these, are keywords", so there (This is an irrelevant comment)')
      k.keywords.should == ['these, are keywords', 'so there (This is an irrelevant comment)']
    end
    
    it "should handle comments" do
      k = Mail::KeywordsField.new('"these, are keywords", so there (This is an irrelevant comment)')
      k.keywords.should == ['these, are keywords', 'so there (This is an irrelevant comment)']
    end
    
    it "should handle comments in quotes" do
      k = Mail::KeywordsField.new('"these, are keywords (another comment to be ignored)", so there (This is an irrelevant comment)')
      k.keywords.should == ['these, are keywords (another comment to be ignored)', 'so there (This is an irrelevant comment)']
    end
    
  end
  
  describe "encoding and decoding" do
    it "should encode" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      k.encoded.should == "Keywords: these are keywords, so there\r\n"
    end

    it "should decode" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      k.decoded.should == "these are keywords, so there"
    end
  end
  
end
