# encoding: utf-8
require 'spec_helper'

describe Mail::KeywordsField do

  describe "initializing" do
    
    it "should initialize" do
      expect(doing { Mail::KeywordsField.new("this, is, email") }).not_to raise_error
    end
    
    it "should accept a string with the field name" do
      k = Mail::KeywordsField.new('Keywords: these are keywords, so there')
      expect(k.name).to eq 'Keywords'
      expect(k.value).to eq 'these are keywords, so there'
    end
    
    it "should accept a string with the field name" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      expect(k.name).to eq 'Keywords'
      expect(k.value).to eq 'these are keywords, so there'
    end
    
  end
  
  describe "giving a list of keywords" do
    it "should return a list of keywords" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      expect(k.keywords).to eq ['these are keywords', 'so there']
    end
    
    it "should handle phrases" do
      k = Mail::KeywordsField.new('"these, are keywords", so there')
      expect(k.keywords).to eq ['these, are keywords', 'so there']
    end
    
    it "should handle comments" do
      k = Mail::KeywordsField.new('"these, are keywords", so there (This is an irrelevant comment)')
      expect(k.keywords).to eq ['these, are keywords', 'so there (This is an irrelevant comment)']
    end
    
    it "should handle comments" do
      k = Mail::KeywordsField.new('"these, are keywords", so there (This is an irrelevant comment)')
      expect(k.keywords).to eq ['these, are keywords', 'so there (This is an irrelevant comment)']
    end
    
    it "should handle comments in quotes" do
      k = Mail::KeywordsField.new('"these, are keywords (another comment to be ignored)", so there (This is an irrelevant comment)')
      expect(k.keywords).to eq ['these, are keywords (another comment to be ignored)', 'so there (This is an irrelevant comment)']
    end
    
  end
  
  describe "encoding and decoding" do
    it "should encode" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      expect(k.encoded).to eq "Keywords: these are keywords,\r\n so there\r\n"
    end

    it "should decode" do
      k = Mail::KeywordsField.new('these are keywords, so there')
      expect(k.decoded).to eq "these are keywords, so there"
    end
  end

  it "should output lines shorter than 998 chars" do
    k = Mail::KeywordsField.new('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat euismod velit nec convallis. Cras bibendum mattis arcu a tincidunt. Nullam ac orci vitae massa elementum ultricies ultricies nec quam. Praesent eleifend viverra semper. Sed id ultricies ipsum. Pellentesque sed nunc mauris, at varius sem. Curabitur pretium pellentesque velit, eget pellentesque dolor interdum eget. Duis ac lectus nec arcu pharetra lobortis. Integer risus felis, convallis ut feugiat quis, imperdiet ut sapien. Nullam imperdiet leo nec lectus imperdiet mollis. Proin nec lectus id erat pellentesque pretium vitae sit amet massa. Proin interdum pellentesque mi, at tristique sem facilisis ut. Donec enim mauris, viverra ut lacinia pharetra, elementum nec mi. Ut at interdum massa. Integer placerat tortor at tellus lobortis a mattis massa ultricies. Vivamus nec dolor at justo fringilla laoreet rhoncus fermentum lectus. Praesent tincidunt congue mauris vitae aliquam. Mauris arcu mauris, faucibus sed turpis duis.')
    lines = k.encoded.split("\r\n\s")
    lines.each { |line| expect(line.length).to be < 998 }
  end

end
