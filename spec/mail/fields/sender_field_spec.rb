# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

# sender          =       "Sender:" mailbox CRLF
RSpec.describe Mail::SenderField do
  let :field do
    Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
  end

  describe "initialization" do
    it "should initialize" do
      expect { Mail::SenderField.new("Mikel") }.not_to raise_error
    end

    it "should accept a string without the field name" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.name).to eq 'Sender'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should reject headers with multiple mailboxes" do
      pending 'Sender accepts an address list now, but should only accept a single address'
      expect {
        Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      }.to raise_error(Mail::Field::ParseError)
    end
  end

  it "formats the sender" do
    expect(field.formatted).to eq ['Mikel Lindsaar <mikel@test.lindsaar.net>']
  end

  it "parses a single sender address" do
    expect(field.address).to eq 'mikel@test.lindsaar.net'
  end

  it "returns the field value" do
    expect(field.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end

  it "encodes a header line" do
    expect(field.encoded).to eq "Sender: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n"
  end
end
