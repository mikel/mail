# encoding: utf-8
require 'spec_helper'

describe Mail::ToField do
  # 
  #    The "To:" field contains the address(es) of the primary recipient(s)
  #    of the message.
  
  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ToField.new("Mikel") }).not_to raise_error
    end

    it "should mix in the CommonAddress module" do
      expect(Mail::ToField.included_modules).to include(Mail::CommonAddress) 
    end

    it "should accept a string with the field name" do
      t = Mail::ToField.new('To: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'To'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
      t = Mail::ToField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'To'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oTours in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::ToField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.formatted).to eq ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::ToField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
      expect(t.formatted.first).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      expect(t.addresses.last).to eq 'ada@test.lindsaar.net'
    end

    it "should return one address and a group" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.addresses[0]).to eq 'sam@me.com'
      expect(t.addresses[1]).to eq 'mikel@me.com'
      expect(t.addresses[2]).to eq 'bob@you.com'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.value).to eq 'sam@me.com, my_group: mikel@me.com, bob@you.com;'
    end
    
    it "should return the encoded line" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.encoded).to eq "To: sam@me.com, \r\n\smy_group: mikel@me.com, \r\n\sbob@you.com;\r\n"
    end
    
    it "should return the decoded line" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.decoded).to eq "sam@me.com, my_group: mikel@me.com, bob@you.com;"
    end
    
    it "should get multiple address out from a group list" do
      t = Mail::ToField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.addresses).to eq ["sam@me.com", "mikel@me.com", "bob@you.com"]
    end
    
    it "should handle commas in the address" do
      t = Mail::ToField.new('"Long, stupid email address" <mikel@test.lindsaar.net>')
      expect(t.addresses).to eq ["mikel@test.lindsaar.net"]
    end
    
    it "should handle commas in the address for multiple fields" do
      t = Mail::ToField.new('"Long, stupid email address" <mikel@test.lindsaar.net>, "Another, really, really, long, stupid email address" <bob@test.lindsaar.net>')
      expect(t.addresses).to eq ["mikel@test.lindsaar.net", "bob@test.lindsaar.net"]
    end
    
  end
  
  it "should not crash if it can't understand a name" do
    t = Mail.new('To: <"Undisclosed-Recipient:"@msr19.hinet.net;>')
    expect(doing { t.encoded }).not_to raise_error
    expect(t.encoded).to match(/To\:\s<"Undisclosed\-Recipient\:"@msr19\.hinet\.net;>\r\n/)
  end
  
end
