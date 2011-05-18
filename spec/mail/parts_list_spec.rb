# encoding: utf-8

require 'spec_helper'

describe "PartsList" do
  it "should return itself on sort" do
    p = Mail::PartsList.new
    p << 2
    p << 1
    p.sort.class.should == Mail::PartsList
  end

  it "should not fail if we do not have a content_type" do
    p = Mail::PartsList.new
    order = ['text/plain']
    p << 'text/plain'
    p << 'text/html'
    p.sort!(order)
  end
end
