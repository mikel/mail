# encoding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe "PartsList" do
  it "should return itself on sort" do
    p = Mail::PartsList.new
    p << 2
    p << 1
    expect(p.sort.class).to eq Mail::PartsList
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
    expect(p.sort!(order)).to eq [plain_text_part, html_text_part, no_content_type_part]
  end

  it "should sort attachments to end" do
    p = Mail::PartsList.new
    order = ['text/plain', 'text/html']

    attachment_part = Mail::Part.new
    html_text_part  = Mail::Part.new
    plain_text_part = Mail::Part.new

    attachment_part.content_type = 'text/plain; filename="foo.txt"'
    attachment_part.content_disposition = 'attachment; filename="foo.txt"'

    html_text_part.content_type = 'text/html'

    p << attachment_part
    p << html_text_part
    p << plain_text_part
    p.sort!(order).should eq [plain_text_part, html_text_part, attachment_part]
  end

  it "should have a parts reader" do
    p = Mail::PartsList.new([1, 2])
    expect(p.parts).to eq([1, 2])
  end

  it "should behave like an array" do
    p = Mail::PartsList.new([1, 2])
    expect(p.first).to eq(1)
  end

  it "is equal to itself" do
    p = Mail::PartsList.new([1, 2])
    expect(p).to eq(p)
  end

  it "is equal to its parts array" do
    p = Mail::PartsList.new
    p << "foo"
    p << "bar"
    expect(p).to eq(["foo", "bar"])
  end

  it "can be mixed with an array" do
    p = Mail::PartsList.new([3, 4])
    expect([1, 2] + p).to eq [1, 2, 3, 4]
  end

  it "should respond to Array methods" do
    p = Mail::PartsList.new
    expect(p).to respond_to(:reduce)
  end

  it "should have a round-tripping YAML serialization" do
    p = Mail::PartsList.new([1, 2])
    expect(YAML.load(YAML.dump(p))).to eq(p)
  end
end
