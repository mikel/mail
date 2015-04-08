# encoding: utf-8
require 'spec_helper'

describe "AddressListsParser" do
  it "should parse an address" do
    text = 'Mikel Lindsaar <test@lindsaar.net>, Friends: test2@lindsaar.net, Ada <test3@lindsaar.net>;'
    a = Mail::Parsers::AddressListsParser.new
    expect(a.parse(text)).not_to be_nil
  end

  it "should parse an address list separated by semicolons" do
    text = 'Mikel Lindsaar <test@lindsaar.net>; Friends: test2@lindsaar.net; Ada <test3@lindsaar.net>;'
    a = Mail::Parsers::AddressListsParser.new
    expect(a.parse(text)).not_to be_nil
  end

  context "parsing an address with a space at the end" do
    it "only finds a single address" do
      text = 'Mikel Lindsaar <test@lindsaar.net> '
      a = Mail::Parsers::AddressListsParser.new
      expect(a.parse(text).addresses.size).to eq 1
    end
  end

  context "parsing an address which begins with a comment" do
    it "extracts local string correctly" do
      text = '(xxxx xxxxxx xxxx)ababab@example.com'

      a = Mail::Parsers::AddressListsParser.new
      expect(a.parse(text).addresses.size).to eq 1
      expect(a.parse(text).addresses.first.local).to eq 'ababab'
    end
  end
end
