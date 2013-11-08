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

  it "should not fail if we do not have a content_type" do
    p = Mail::PartsList.new
    order = ['text/plain', 'text/html']

    no_content_type_part = Mail::Part.new
    plain_text_part      = Mail::Part.new
    html_text_part       = Mail::Part.new

    no_content_type_part.content_type = nil
    html_text_part.content_type       = 'text/html'

    p << no_content_type_part
    p << plain_text_part
    p << html_text_part
    p.sort!(order).should eq [plain_text_part, html_text_part, no_content_type_part]
  end
end