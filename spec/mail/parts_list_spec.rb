# encoding: utf-8

require 'spec_helper'

describe "PartsList" do
  it "should return itself on sort" do
    p = Mail::PartsList.new
    p << 2
    p << 1
    p.sort.class.should == Mail::PartsList
  end
end
