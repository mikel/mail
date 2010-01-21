# encoding: utf-8

require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'spec_helper')

describe "PartsList" do
  it "should return itself on sort" do
    p = Mail::PartsList.new
    p << 2
    p << 1
    p.sort.class.should == Mail::PartsList
  end
end
