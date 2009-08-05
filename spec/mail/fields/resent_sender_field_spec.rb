# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::ResentSenderField do
  it "should initialize" do
    doing { Mail::ResentSenderField.new("Resent-Sender", "Mikel") }.should_not raise_error
  end
  
  it "should mix in the CommonAddress module" do
    Mail::ResentSenderField.included_modules.should include(Mail::CommonAddress::InstanceMethods) 
  end

  it "should accept two strings with the field separate" do
    t = Mail::ResentSenderField.new('Resent-Sender', 'Mikel Lindsaar <mikel@test.lindsaar.net>')
    t.name.should == 'Resent-Sender'
    t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end

  it "should accept a string with the field name" do
    t = Mail::ResentSenderField.new('Resent-Sender: Mikel Lindsaar <mikel@test.lindsaar.net>')
    t.name.should == 'Resent-Sender'
    t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end
  
  it "should accept a string without the field name" do
    t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
    t.name.should == 'Resent-Sender'
    t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end
  
  # Actual testing of CommonAddress methods occurs in the address field spec file
  
  it "should return an address" do
    t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
    t.addresses.first.to_s.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end
  
  it "should return the first address if one address is passed in (per RFC2822)" do
    t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
    t.addresses.length.should == 1
    t.addresses.first.to_s.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end
  
  it "should return an address (per RFC2822)" do
    t = Mail::ResentSenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
    t.address.to_s.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end
  
end
