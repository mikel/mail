require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::ToField do
  it "should initialize" do
    doing { Mail::ToField.new("To", "Mikel") }.should_not raise_error
  end
  
  it "should give the addresses it is going to" do
    field = Mail::ToField.new("To", "test1@lindsaar.net")
    field.addresses.first.address.should == "test1@lindsaar.net"
  end
  
  it "should split up the address list into individual addresses" do
    field = Mail::ToField.new("To", "test1@lindsaar.net, test2@lindsaar.net")
    field.addresses.map { |a| a.address }.should == ["test1@lindsaar.net", "test2@lindsaar.net"]
  end
  
  it "should give the address strings" do
    field = Mail::ToField.new("To", "test1@lindsaar.net, test2@lindsaar.net")
    field.address_strings.should == ["test1@lindsaar.net", "test2@lindsaar.net"]
  end
  
  it "should handle groups as well" do
    field = Mail::ToField.new("To", "test1@lindsaar.net, group: test2@lindsaar.net, me@lindsaar.net;")
    field.address_strings.should == ["test1@lindsaar.net", "test2@lindsaar.net", "me@lindsaar.net"]
  end

  it "should provide a list of groups" do
    field = Mail::ToField.new("To", "test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
    field.group_names.should == ["My Group"]
  end

end
