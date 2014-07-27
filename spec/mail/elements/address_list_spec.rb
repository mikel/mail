# encoding: utf-8
require 'spec_helper'

describe Mail::AddressList do

  describe "parsing" do
    it "should parse an address list" do
      parse_text  = 'test@lindsaar.net'
      expect { Mail::AddressList.new(parse_text) }.not_to raise_error
    end

    it "should raise an error if the input is useless" do
      parse_text = '@@@@@@'
      expect { Mail::AddressList.new(parse_text) }.to raise_error
    end

    it "should not raise an error if the input is just blank" do
      parse_text = nil
      expect { Mail::AddressList.new(parse_text) }.not_to raise_error
    end

    it "should raise an error if the input is useless" do
      parse_text = "This ( is an invalid address!"
      expect { Mail::AddressList.new(parse_text) }.to raise_error
    end

    it "should give the address passed in" do
      parse_text  = 'test@lindsaar.net'
      result      = 'test@lindsaar.net'
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.first.to_s).to eq result
    end

    it "should give the addresses passed in" do
      parse_text  = 'test@lindsaar.net, test2@lindsaar.net'
      result      = ['test@lindsaar.net', 'test2@lindsaar.net']
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.map {|addr| addr.to_s }).to eq result
    end

    it "should preserve the display name" do
      parse_text  = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
      result      = 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.first.format).to eq result
      expect(a.addresses.first.display_name).to eq 'Mikel Lindsaar'
    end

    it "should handle and ignore nil addresses" do
      parse_text  = ' , user-example@aol.com, e-s-a-s-2200@app.ar.com'
      result      = ['user-example@aol.com', 'e-s-a-s-2200@app.ar.com']
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.map {|addr| addr.to_s }).to eq result
    end

    it "should handle truly horrific combinations of commas, spaces, and addresses" do
      parse_text = '  ,, foo@example.com,  ,    ,,, bar@example.com  ,,'
      result = ['foo@example.com', 'bar@example.com']
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.map {|addr| addr.to_s }).to eq result
    end

    it "should handle folding whitespace" do
      parse_text = "foo@example.com,\r\n\tbar@example.com"
      result = ['foo@example.com', 'bar@example.com']
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.map {|addr| addr.to_s }).to eq result
    end

    it "should handle malformed folding whitespace" do
      pending
      parse_text = "leads@sg.dc.com,\n\t sag@leads.gs.ry.com,\n\t sn@example-hotmail.com,\n\t e-s-a-g-8718@app.ar.com,\n\t jp@t-exmaple.com,\n\t\n\t cc@c-l-example.com"
      result = %w(leads@sg.dc.com sag@leads.gs.ry.com sn@example-hotmail.com e-s-a-g-8718@app.ar.com jp@t-exmaple.com cc@c-l-example.com)
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.map {|addr| addr.to_s }).to eq result
    end

    it "should extract comments in addreses which are part of a group" do
      parse_text = "group: jimmy <jimmy@(comment)example.com>;";
      result = ["comment"]
      a = Mail::AddressList.new(parse_text)
      expect(a.addresses.first.comments).to eq result
    end
  end

  describe "functionality" do
    it "should give all the groups when asked" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(list.addresses_grouped_by_group.length).to eq 1
    end

    it "should ask the group for all its addresses" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(list.addresses_grouped_by_group.values.first.length).to eq 2
    end

    it "should give all the addresses when asked" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(list.addresses.length).to eq 3
    end

    it "should handle a really nasty obsolete address list" do
      psycho_obsolete = "Mary Smith <@machine.tld:mary@example.net>, , jdoe@test   . example"
      list = Mail::AddressList.new(psycho_obsolete)
      expect(list.addresses.length).to eq 2
    end


    it "should create an address instance for each address returned" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.addresses.each do |address|
        expect(address.class).to eq Mail::Address
      end
    end

    it "should provide a list of group names" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      expect(list.group_names).to eq ["my_group"]
    end

  end

end
