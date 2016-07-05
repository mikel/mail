# encoding: utf-8
require 'spec_helper'

describe "MessageIdsParser" do
  it "should not fail to parse a message id with comments" do
    text = '<8167EB1E991646B3@mx.smtp.test.de> (added by postmaster@test.com)'
    expect {
      Mail::Parsers::MessageIdsParser.new.parse(text)
    }.to_not raise_error
  end
end
