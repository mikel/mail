# encoding: utf-8

require 'spec_helper'

describe "PartsList" do
  it "should return itself on sort" do
    p = Mail::PartsList.new
    p << 2
    p << 1
    p.sort.class.should eq Mail::PartsList
  end

  it "should not fail if we do not have a content_type" do
    p = Mail::PartsList.new
    order = ['text/plain']
    p << 'text/plain'
    p << 'text/html'
    p.sort!(order)
  end

  it "should not raise an error when the part is content_type and Mail::UnstructuredField" do
    part = Mail::Part.new do
      content_type 'unknown/unknown; name="image.gif"'
    end

    Mail::PartsList.new.send(:get_order_value, part, [])
  end

end
