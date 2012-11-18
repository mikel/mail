# encoding: utf-8
require 'spec_helper'

describe "Mail::CommonAddress" do

  describe "address handling" do

    it "should give the addresses it is going to" do
      field = Mail::ToField.new("To: test1@lindsaar.net")
      field.addresses.first.should eq "test1@lindsaar.net"
    end

    it "should split up the address list into individual addresses" do
      field = Mail::ToField.new("To: test1@lindsaar.net, test2@lindsaar.net")
      field.addresses.should eq ["test1@lindsaar.net", "test2@lindsaar.net"]
    end

    it "should give the formatted addresses" do
      field = Mail::ToField.new("To: Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.formatted.should eq ["Mikel <test1@lindsaar.net>", "Bob <test2@lindsaar.net>"]
    end

    it "should give the display names" do
      field = Mail::ToField.new("To: Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.display_names.should eq ["Mikel", "Bob"]
    end

    it "should give the actual address objects" do
      field = Mail::ToField.new("To: Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.addrs.each do |addr|
        addr.class.should eq Mail::Address
      end
    end

    it "should handle groups as well" do
      field = Mail::ToField.new("To: test1@lindsaar.net, group: test2@lindsaar.net, me@lindsaar.net;")
      field.addresses.should eq ["test1@lindsaar.net", "test2@lindsaar.net", "me@lindsaar.net"]
    end

    it "should provide a list of groups" do
      field = Mail::ToField.new("To: test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.group_names.should eq ["My Group"]
    end

    it "should provide a list of addresses per group" do
      field = Mail::ToField.new("To: test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.groups["My Group"].length.should eq 2
      field.groups["My Group"].first.to_s.should eq 'test2@lindsaar.net'
      field.groups["My Group"].last.to_s.should eq 'me@lindsaar.net'
    end

    it "should provide a list of addresses that are just in the groups" do
      field = Mail::ToField.new("To: test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.group_addresses.should eq ['test2@lindsaar.net', 'me@lindsaar.net']
    end

    describe ".value=" do
      it "should handle initializing as an empty string" do
        field = Mail::ToField.new("")
        field.addresses.should eq []
        field.value = 'mikel@test.lindsaar.net'
        field.addresses.should eq ['mikel@test.lindsaar.net']
      end

      it "should encode to an empty string if it has no addresses or groups" do
        field = Mail::ToField.new("")
        field.encoded.should eq ''
        field.value = 'mikel@test.lindsaar.net'
        field.encoded.should eq "To: mikel@test.lindsaar.net\r\n"
      end

      context "a unquoted multi-byte address is given" do
        let(:given_value) { 'みける <mikel@test.lindsaar.net>' }

        it "should allow you to set an unquoted, multi-byte address value after initialization" do
          expected_result = "To: =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
          field = Mail::ToField.new("")
          field.value = given_value
          field.encoded.should eq expected_result
        end

        it "should keep the given value" do
          field = Mail::ToField.new("")
          field.value = given_value
          field.value.should eq given_value
        end
      end

      context "a quoted multi-byte address is given" do
        let(:given_value) { '"みける" <mikel@test.lindsaar.net>' }

        it "should allow you to set an quoted, multi-byte address value after initialization" do
          expected_result = "To: =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
          field = Mail::ToField.new("")
          field.value = given_value
          field.encoded.should eq expected_result
        end

        it "should keep the given value" do
          field = Mail::ToField.new("")
          field.value = given_value
          field.value.should eq given_value
        end
      end
    end

    describe ".<<" do
      it "should allow you to append an address" do
        field = Mail::ToField.new("")
        field << 'mikel@test.lindsaar.net'
        field.addresses.should eq ["mikel@test.lindsaar.net"]
      end

      context "a unquoted multi-byte address is given" do
        let(:given_value) { 'みける <mikel@test.lindsaar.net>' }

        context "initialized with an empty string" do
          it "should allow you to append an unquoted, multi-byte address value" do
            expected_result = "To: =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
            field = Mail::ToField.new("")
            field << given_value
            field.encoded.should eq expected_result
          end

          it "should keep the given value" do
            field = Mail::ToField.new("")
            field << given_value
            field.value.should eq given_value
          end
        end

        context "initialized with an us-ascii address" do
          it "should allow you to append a quoted, multi-byte address value" do
            expected_result = "To: Mikel <test1@example.com>, \r\n =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
            field = Mail::ToField.new("Mikel <test1@example.com>")
            field << given_value
            field.encoded.should eq expected_result
          end
        end

        context "initialized with an multi-byte address" do
          it "should allow you to append a quoted, multi-byte address value" do
            expected_result = "To: =?UTF-8?B?44Of44Kx44Or?= <test2@example.com>, \r\n =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
            field = Mail::ToField.new("ミケル <test2@example.com>")
            field << given_value
            field.encoded.should eq expected_result
          end

          it "should keep the given value" do
            field = Mail::ToField.new("ミケル <test2@example.com>")
            field << given_value
            field.value.should eq ["ミケル <test2@example.com>", given_value].join(', ')
          end
        end
      end

      context "a quoted multi-byte address is given" do
        let(:given_value) { '"みける" <mikel@test.lindsaar.net>' }

        context "initialized with an empty string" do
          it "should allow you to append a quoted, multi-byte address value" do
            expected_result = "To: =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
            field = Mail::ToField.new("")
            field << given_value
            field.encoded.should eq expected_result
          end

          it "should keep the given value" do
            field = Mail::ToField.new("")
            field << given_value
            field.value.should eq given_value
          end
        end

        context "initialized with an us-ascii address" do
          it "should allow you to append a quoted, multi-byte address value" do
            expected_result = "To: Mikel <test1@example.com>, \r\n =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
            field = Mail::ToField.new("Mikel <test1@example.com>")
            field << given_value
            field.encoded.should eq expected_result
          end
        end

        context "initialized with an multi-byte address" do
          it "should allow you to append a quoted, multi-byte address value" do
            expected_result = "To: =?UTF-8?B?44Of44Kx44Or?= <test2@example.com>, \r\n =?UTF-8?B?44G/44GR44KL?= <mikel@test.lindsaar.net>\r\n"
            field = Mail::ToField.new("ミケル <test2@example.com>")
            field << given_value
            field.encoded.should eq expected_result
          end

          it "should keep the given value" do
            field = Mail::ToField.new("ミケル <test2@example.com>")
            field << given_value
            field.value.should eq ["ミケル <test2@example.com>", given_value].join(', ')
          end
        end
      end
    end

    it "should preserve the display name" do
      field = Mail::ToField.new('"Mikel Lindsaar" <mikel@test.lindsaar.net>')
      field.display_names.should eq ["Mikel Lindsaar"]
    end

    it "should handle multiple addresses" do
      field = Mail::ToField.new(['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>'])
      field.addresses.should eq ['test1@lindsaar.net', 'test2@lindsaar.net']
    end

  end

  describe "encoding and decoding fields" do

    it "should allow us to encode an address field" do
      field = Mail::ToField.new("test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.encoded.should eq "To: test1@lindsaar.net, \r\n\sMy Group: test2@lindsaar.net, \r\n\sme@lindsaar.net;\r\n"
    end

    it "should allow us to encode a simple address field" do
      field = Mail::ToField.new("test1@lindsaar.net")
      field.encoded.should eq "To: test1@lindsaar.net\r\n"
    end

    it "should allow us to encode an address field" do
      field = Mail::CcField.new("test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.encoded.should eq "Cc: test1@lindsaar.net, \r\n\sMy Group: test2@lindsaar.net, \r\n\sme@lindsaar.net;\r\n"
    end

    it "should allow us to decode an address field" do
      field = Mail::ToField.new("test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.decoded.should eq "test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;"
    end

    it "should allow us to decode a non ascii address field" do
      field = Mail::ToField.new("=?UTF-8?B?44G/44GR44KL?= <raasdnil@text.lindsaar.net>")
      field.decoded.should eq '"みける" <raasdnil@text.lindsaar.net>'
    end

    it "should allow us to decode a non ascii address field" do
      field = Mail::ToField.new("=?UTF-8?B?44G/44GR44KL?= <raasdnil@text.lindsaar.net>, =?UTF-8?B?44G/44GR44KL?= <mikel@text.lindsaar.net>")
      field.decoded.should eq '"みける" <raasdnil@text.lindsaar.net>, "みける" <mikel@text.lindsaar.net>'
    end

  end

  it "should yield each address object in turn" do
    field = Mail::ToField.new("test1@lindsaar.net, test2@lindsaar.net, me@lindsaar.net")
    addresses = []
    field.each do |address|
      addresses << address.address
    end
    addresses.should eq ["test1@lindsaar.net", "test2@lindsaar.net", "me@lindsaar.net"]
  end

end
