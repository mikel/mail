# encoding: utf-8
require 'spec_helper'

# 
# from            =       "From:" mailbox-list CRLF

describe Mail::FromField do
  
  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::FromField.new("From: Mikel") }).not_to raise_error
    end

    it "should mix in the CommonAddress module" do
      expect(Mail::FromField.included_modules).to include(Mail::CommonAddress) 
    end

    it "should accept a string with the field name" do
      t = Mail::FromField.new('From: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'From'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
      t = Mail::FromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      expect(t.name).to eq 'From'
      expect(t.value).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oFromurs in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::FromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      expect(t.formatted).to eq ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::FromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
      expect(t.formatted.first).to eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      expect(t.addresses.last).to eq 'ada@test.lindsaar.net'
    end

    it "should return one address and a group" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.addresses[0]).to eq 'sam@me.com'
      expect(t.addresses[1]).to eq 'mikel@me.com'
      expect(t.addresses[2]).to eq 'bob@you.com'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.value).to eq 'sam@me.com, my_group: mikel@me.com, bob@you.com;'
    end
    
    it "should return the encoded line" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.encoded).to eq "From: sam@me.com, \r\n\smy_group: mikel@me.com, \r\n\sbob@you.com;\r\n"
    end
    
    it "should return the encoded line" do
      t = Mail::FromField.new("bob@me.com")
      expect(t.encoded).to eq "From: bob@me.com\r\n"
    end
    
    it "should return the decoded line" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(t.decoded).to eq "sam@me.com, my_group: mikel@me.com, bob@you.com;"
    end
    
  end
  
  it "should handle non ascii" do
    t = Mail::FromField.new('"Foo áëô îü" <extended@example.net>')
    expect(t.decoded).to eq '"Foo áëô îü" <extended@example.net>'
    expect(t.encoded).to eq "From: =?UTF-8?B?Rm9vIMOhw6vDtCDDrsO8?= <extended@example.net>\r\n"
  end
  
  
  it "should work without quotes" do
    t = Mail::FromField.new('Foo áëô îü <extended@example.net>')
    expect(t.encoded).to eq "From: Foo =?UTF-8?B?w6HDq8O0?= =?UTF-8?B?IMOuw7w=?= <extended@example.net>\r\n"
    expect(t.decoded).to eq '"Foo áëô îü" <extended@example.net>'
  end

end
