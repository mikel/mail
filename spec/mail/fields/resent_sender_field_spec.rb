# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

# resent-sender   =       "Resent-Sender:" mailbox CRLF
RSpec.describe Mail::ResentSenderField do
  let :field do
    Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
  end

  describe "initialization" do

    it "should initialize" do
      expect { Mail::ResentSenderField.new("Mikel") }.not_to raise_error
    end

    it "should accept a string without the field name" do
      t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'Resent-Sender'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
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
    expect(field.encoded).to eq "Resent-Sender: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n"
  end
end
