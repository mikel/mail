# encoding: utf-8
require 'spec_helper'

describe Mail::SenderField do
  # sender          =       "Sender:" mailbox CRLF
  #

  describe "initialization" do

    it "should initialize" do
      expect { Mail::SenderField.new("Sender: Mikel") }.not_to raise_error
    end

    it "should mix in the CommonAddress module" do
      expect(Mail::SenderField.included_modules).to include(Mail::CommonAddress)
    end

    it "should accept a string with the field name" do
      t = Mail::SenderField.new('Sender: Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.name).to eq 'Sender'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should accept a string without the field name" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.name).to eq 'Sender'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should reject headers with multiple mailboxes" do
      pending 'Sender accepts an address list now, but should only accept a single address'
      expect { Mail::SenderField.new('Sender: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>') }.to raise_error
    end
  end

  # Actual testing of CommonAddress methods oSenderurs in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.formatted).to eq ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.address.to_s).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should return the formatted line on to_s" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should return the encoded line" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.encoded).to eq "Sender: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n"
    end

  end


end
