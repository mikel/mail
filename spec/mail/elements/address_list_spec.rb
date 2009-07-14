require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::AddressList do
  it "should give back a list of address nodes" do
    list = Mail::AddressList.new('mikel@me.com, bob@you.com')
    list.address_nodes.length.should == 2
  end
  
  it "should have each nood a class of SyntaxNode" do
    list = Mail::AddressList.new('mikel@me.com, bob@you.com')
    list.address_nodes.each { |n| n.class.should == Treetop::Runtime::SyntaxNode }
  end
  
  it "should give a block of address nodes with groups" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.address_nodes.length.should == 2
  end
  
  it "should give all the recipients when asked" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.individual_recipients.length.should == 1
  end
  
  it "should give all the groups when asked" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.group_recipients.length.should == 1
  end
  
  it "should ask the group for all it's addresses" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.group_recipients.first.group_list.addresses.length.should == 2
  end
  
  it "should give all the addresses when asked" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.addresses.length.should == 3
  end
  
  it "should create an address instance for each address returned" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.addresses.each do |address|
      address.class.should == Mail::Address
    end
  end
  
  it "should provide a list of group names" do
    list = Mail::AddressList.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    list.group_names.should == ["my_group"]
  end
  
end
