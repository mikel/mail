# encoding: utf-8
require 'spec_helper'

describe Mail::AddressList do

  describe "parsing" do
    it "should parse an address list" do
      parse_text  = 'test@lindsaar.net'
      doing { Mail::AddressList.new(parse_text) }.should_not raise_error
    end

    it "should raise an error if the input is useless" do
      parse_text = '@@@@@@'
      doing { Mail::AddressList.new(parse_text) }.should raise_error
    end
    
    it "should not raise an error if the input is just blank" do
      parse_text = nil
      doing { Mail::AddressList.new(parse_text) }.should_not raise_error
    end

    it "should raise an error if the input is useless" do
      parse_text = "This ( is an invalid address!"
      doing { Mail::AddressList.new(parse_text) }.should raise_error
    end

    it "should give the address passed in" do
      parse_text  = 'test@lindsaar.net'
      result      = 'test@lindsaar.net'
      a = Mail::AddressList.new(parse_text)
      a.addresses.first.to_s.should eql result
    end

    it "should give the addresses passed in" do
      parse_text  = 'test@lindsaar.net, test2@lindsaar.net'
      result      = ['test@lindsaar.net', 'test2@lindsaar.net']
      a = Mail::AddressList.new(parse_text)
      a.addresses.map {|addr| addr.to_s }.should eql result
    end

    it "should preserve the display name" do
      parse_text  = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
      result      = 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      a = Mail::AddressList.new(parse_text)
      a.addresses.first.format.should eql result
      a.addresses.first.display_name.should eql 'Mikel Lindsaar'
    end

    it "should handle and ignore nil addresses" do
      parse_text  = ' , user-example@aol.com, e-s-a-s-2200@app.ar.com'
      result      = ['user-example@aol.com', 'e-s-a-s-2200@app.ar.com']
      a = Mail::AddressList.new(parse_text)
      a.addresses.map {|addr| addr.to_s }.should eql result
    end

    it "should handle truly horrific combinations of commas, spaces, and addresses" do
      parse_text = '  ,, foo@example.com,  ,    ,,, bar@example.com  ,,'
      result = ['foo@example.com', 'bar@example.com']
      a = Mail::AddressList.new(parse_text)
      a.addresses.map {|addr| addr.to_s }.should eql result
    end

    it "should handle folding whitespace" do
      parse_text = "foo@example.com,\r\n\tbar@example.com"
      result = ['foo@example.com', 'bar@example.com']
      a = Mail::AddressList.new(parse_text)
      a.addresses.map {|addr| addr.to_s }.should eql result
    end

    it "should handle malformed folding whitespace" do
      pending
      parse_text = "leads@sg.dc.com,\n\t sag@leads.gs.ry.com,\n\t sn@example-hotmail.com,\n\t e-s-a-g-8718@app.ar.com,\n\t jp@t-exmaple.com,\n\t\n\t cc@c-l-example.com"
      result = %w(leads@sg.dc.com sag@leads.gs.ry.com sn@example-hotmail.com e-s-a-g-8718@app.ar.com jp@t-exmaple.com cc@c-l-example.com)
      a = Mail::AddressList.new(parse_text)
      a.addresses.map {|addr| addr.to_s }.should eql result
    end

  end
  
  describe "functionality" do
    it "should give back a list of address nodes" do
      list = Mail::AddressList.new('mikel@me.com, bob@you.com')
      list.address_nodes.length.should eql 2
    end

    it "should have each nood a class of SyntaxNode" do
      list = Mail::AddressList.new('mikel@me.com, bob@you.com')
      list.address_nodes.each { |n| n.class.should eql Treetop::Runtime::SyntaxNode }
    end

    it "should give a block of address nodes with groups" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.address_nodes.length.should eql 2
    end

    it "should give all the recipients when asked" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.individual_recipients.length.should eql 1
    end

    it "should give all the groups when asked" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.group_recipients.length.should eql 1
    end

    it "should ask the group for all it's addresses" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.group_recipients.first.group_list.addresses.length.should eql 2
    end

    it "should give all the addresses when asked" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.addresses.length.should eql 3
    end
    
    it "should handle a really nasty obsolete address list" do
      pending
      psycho_obsolete = "Mary Smith <@machine.tld:mary@example.net>, , jdoe@test   . example"
      list = Mail::AddressList.new(psycho_obsolete)
      list.addresses.length.should eql 2
    end
    

    it "should create an address instance for each address returned" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.addresses.each do |address|
        address.class.should eql Mail::Address
      end
    end

    it "should provide a list of group names" do
      list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      list.group_names.should eql ["my_group"]
    end
    
  end
  
end
