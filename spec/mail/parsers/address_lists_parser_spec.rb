# encoding: utf-8
require 'spec_helper'

describe "AddressListsParser" do
  it "should parse an address" do
    text = 'Mikel Lindsaar <test@lindsaar.net>, Friends: test2@lindsaar.net, Ada <test3@lindsaar.net>;'
    a = Mail::AddressListsParser.new
    a.parse(text).should_not be_nil
  end
  it "should parse an address list separated by semicolons" do
    text = 'Mikel Lindsaar <test@lindsaar.net>; Friends: test2@lindsaar.net; Ada <test3@lindsaar.net>;'
    a = Mail::AddressListsParser.new
    a.parse(text).should_not be_nil
  end
end
