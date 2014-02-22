# encoding: utf-8
require 'spec_helper'
# 
# resent-sender   =       "Resent-Sender:" mailbox CRLF

describe Mail::ResentSenderField do
  
  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ResentSenderField.new("Resent-Sender: Mikel") }).not_to raise_error
    end

    it "should mix in the CommonAddress module" do
      expect(Mail::ResentSenderField.included_modules).to include(Mail::CommonAddress) 
    end

    it "should accept a string with the field name" do
      t = Mail::ResentSenderField.new('Resent-Sender: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'Resent-Sender'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
      t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'Resent-Sender'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oResentSenderurs in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.formatted).to eq ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.address.to_s).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end
    
    it "should return the encoded line" do
      t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.encoded).to eq "Resent-Sender: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n"
    end
    
  end
  
  
end
