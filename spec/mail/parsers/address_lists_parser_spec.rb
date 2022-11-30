# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe "AddressListsParser" do
  it "should parse an address" do
    text = 'Mikel Lindsaar <test@lindsaar.net>, Friends: test2@lindsaar.net, Ada <test3@lindsaar.net>;'
    a = Mail::Parsers::AddressListsParser
    expect(a.parse(text)).not_to be_nil
  end

  it "should parse an address list separated by semicolons" do
    text = 'Mikel Lindsaar <test@lindsaar.net>; Friends: test2@lindsaar.net; Ada <test3@lindsaar.net>;'
    a = Mail::Parsers::AddressListsParser
    expect(a.parse(text)).not_to be_nil
  end

  context "parsing an address with a space at the end" do
    it "only finds a single address" do
      text = 'Mikel Lindsaar <test@lindsaar.net> '
      a = Mail::Parsers::AddressListsParser
      expect(a.parse(text).addresses.size).to eq 1
    end
  end

  context "parsing an address which begins with a comment" do
    it "extracts local string correctly" do
      text = '(xxxx xxxxxx xxxx)ababab@example.com'

      a = Mail::Parsers::AddressListsParser
      expect(a.parse(text).addresses.size).to eq 1
      expect(a.parse(text).addresses.first.local).to eq 'ababab'
    end
  end

  context "RFC6532 UTF-8 headers" do
    it "extracts UTF-8 local string" do
      text = '"🌈" (😁) <💌@👉.com>, 🤠:test@example.com;'

      a = Mail::Parsers::AddressListsParser
      result = a.parse(text)
      expect(result.addresses.size).to eq 2

      address = result.addresses[0]
      expect(address.display_name).to eq '🌈'
      expect(address.local).to eq '💌'
      expect(address.domain).to eq '👉.com'

      address = result.addresses[1]
      expect(address.group).to eq '🤠'
      expect(address.local).to eq 'test'
      expect(address.domain).to eq 'example.com'
    end

    it "should parse an address" do
      text = '"💌" <💌@💌.com>, 🤠: test2@lindsaar.net, Ada <test3@lindsaar.net>;'
      a = Mail::Parsers::AddressListsParser
      expect(a.parse(text)).not_to be_nil
    end
  end
end
