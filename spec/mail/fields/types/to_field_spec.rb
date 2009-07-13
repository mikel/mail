require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mail::ToField do
  it "should initialize" do
    doing { Mail::ToField.new("To", "Mikel") }.should_not raise_error
  end
  
  it "should give the addresses it is going to" do
    field = Mail::ToField.new("To", "test1@lindsaar.net")
    field.addresses.should == ["test1@lindsaar.net"]
  end
  
  it "should split up the address list into individual addresses" do
    field = Mail::ToField.new("To", "test1@lindsaar.net, test2@lindsaar.net")
    field.addresses.should == ["test1@lindsaar.net", "test2@lindsaar.net"]
  end

end
