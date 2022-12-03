# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::CommentsField do
  # 
  # comments        =       "Comments:" unstructured CRLF

  it "should initialize" do
    expect { Mail::CommentsField.new("this is a comment") }.not_to raise_error
  end

  it "should accept a string with the field name" do
    t = Mail::CommentsField.new('this is a comment')
    expect(t.name).to eq 'Comments'
    expect(t.value).to eq 'this is a comment'
  end


end
