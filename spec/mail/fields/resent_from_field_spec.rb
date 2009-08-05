# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::ResentFromField do
  it "should initialize" do
    doing { Mail::ResentFromField.new("Resent-From", "Mikel") }.should_not raise_error
  end
  
  it "should mix in the CommonAddress module" do
    Mail::ResentFromField.included_modules.should include(Mail::CommonAddress::InstanceMethods) 
  end

  it "should accept two strings with the field separate" do
    t = Mail::ResentFromField.new('Resent-From', 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
    t.name.should == 'Resent-From'
    t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
  end

  it "should accept a string with the field name" do
    t = Mail::ResentFromField.new('Resent-From: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
    t.name.should == 'Resent-From'
    t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
  end
  
  it "should accept a string without the field name" do
    t = Mail::ResentFromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
    t.name.should == 'Resent-From'
    t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
  end
  
  # Actual testing of CommonAddress methods occurs in the address field spec file
  
  it "should return an address" do
    t = Mail::ResentFromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
    t.addresses.first.to_s.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
  end
  
  it "should return two addresses" do
    t = Mail::ResentFromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
    t.addresses.first.to_s.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    t.addresses.last.to_s.should == 'Ada Lindsaar <ada@test.lindsaar.net>'
  end
  
  it "should return one address and a group" do
    t = Mail::ResentFromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
    t.addresses[0].to_s.should == 'sam@me.com'
    t.addresses[1].to_s.should == 'mikel@me.com'
    t.addresses[2].to_s.should == 'bob@you.com'
  end
  
end
