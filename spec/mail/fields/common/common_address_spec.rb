# encoding: utf-8
require 'spec_helper'

describe "Mail::CommonAddress" do
  
  describe "address handling" do
  
    it "should give the addresses it is going to" do
      field = Mail::ToField.new("To: test1@lindsaar.net")
      field.addresses.first.should eql "test1@lindsaar.net"
    end
  
    it "should split up the address list into individual addresses" do
      field = Mail::ToField.new("To: test1@lindsaar.net, test2@lindsaar.net")
      field.addresses.should eql ["test1@lindsaar.net", "test2@lindsaar.net"]
    end

    it "should give the formatted addresses" do
      field = Mail::ToField.new("To: Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.formatted.should eql ["Mikel <test1@lindsaar.net>", "Bob <test2@lindsaar.net>"]
    end

    it "should give the display names" do
      field = Mail::ToField.new("To: Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.display_names.should eql ["Mikel", "Bob"]
    end

    it "should give the actual address objects" do
      field = Mail::ToField.new("To: Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.addrs.each do |addr|
        addr.class.should eql Mail::Address
      end
    end

    it "should handle groups as well" do
      field = Mail::ToField.new("To: test1@lindsaar.net, group: test2@lindsaar.net, me@lindsaar.net;")
      field.addresses.should eql ["test1@lindsaar.net", "test2@lindsaar.net", "me@lindsaar.net"]
    end

    it "should provide a list of groups" do
      field = Mail::ToField.new("To: test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.group_names.should eql ["My Group"]
    end

    it "should provide a list of addresses per group" do
      field = Mail::ToField.new("To: test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.groups["My Group"].length.should eql 2
      field.groups["My Group"].first.to_s.should eql 'test2@lindsaar.net'
      field.groups["My Group"].last.to_s.should eql 'me@lindsaar.net'
    end

    it "should provide a list of addresses that are just in the groups" do
      field = Mail::ToField.new("To: test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.group_addresses.should eql ['test2@lindsaar.net', 'me@lindsaar.net']
    end

    it "should handle initializing as an empty string" do
      field = Mail::ToField.new("")
      field.addresses.should eql []
      field.value = 'mikel@test.lindsaar.net'
      field.addresses.should eql ['mikel@test.lindsaar.net']
    end

    it "should encode to an empty string if it has no addresses or groups" do
      field = Mail::ToField.new("")
      field.encoded.should eql ''
      field.value = 'mikel@test.lindsaar.net'
      field.encoded.should eql "To: mikel@test.lindsaar.net\r\n"
    end

    it "should allow you to append an address" do
      field = Mail::ToField.new("")
      field << 'mikel@test.lindsaar.net'
      field.addresses.should eql ["mikel@test.lindsaar.net"]
    end

    it "should preserve the display name" do
      field = Mail::ToField.new('"Mikel Lindsaar" <mikel@test.lindsaar.net>')
      field.display_names.should eql ["Mikel Lindsaar"]
    end

    it "should handle multiple addresses" do
      field = Mail::ToField.new(['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>'])
      field.addresses.should eql ['test1@lindsaar.net', 'test2@lindsaar.net']
    end

  end
  
  describe "encoding and decoding fields" do
    
    it "should allow us to encode an address field" do
      field = Mail::ToField.new("test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.encoded.should eql "To: test1@lindsaar.net, \r\n\sMy Group: test2@lindsaar.net, \r\n\sme@lindsaar.net;\r\n"
    end
    
    it "should allow us to encode a simple address field" do
      field = Mail::ToField.new("test1@lindsaar.net")
      field.encoded.should eql "To: test1@lindsaar.net\r\n"
    end
    
    it "should allow us to encode an address field" do
      field = Mail::CcField.new("test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.encoded.should eql "Cc: test1@lindsaar.net, \r\n\sMy Group: test2@lindsaar.net, \r\n\sme@lindsaar.net;\r\n"
    end

    it "should allow us to decode an address field" do
      field = Mail::ToField.new("test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.decoded.should eql "test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;"
    end
    
    it "should allow us to decode a non ascii address field" do
      field = Mail::ToField.new("=?UTF-8?B?44G/44GR44KL?= <raasdnil@text.lindsaar.net>")
      field.decoded.should eql '"みける" <raasdnil@text.lindsaar.net>'
    end
    
    it "should allow us to decode a non ascii address field" do
      field = Mail::ToField.new("=?UTF-8?B?44G/44GR44KL?= <raasdnil@text.lindsaar.net>, =?UTF-8?B?44G/44GR44KL?= <mikel@text.lindsaar.net>")
      field.decoded.should eql '"みける" <raasdnil@text.lindsaar.net>, "みける" <mikel@text.lindsaar.net>'
    end

  end
  
  it "should yield each address object in turn" do
    field = Mail::ToField.new("test1@lindsaar.net, test2@lindsaar.net, me@lindsaar.net")
    addresses = []
    field.each do |address|
      addresses << address.address
    end
    addresses.should eql ["test1@lindsaar.net", "test2@lindsaar.net", "me@lindsaar.net"]
  end

end
