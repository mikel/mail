# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

# 
# from            =       "From:" mailbox-list CRLF

describe Mail::FromField do
  
  describe "initialization" do

    it "should initialize" do
      doing { Mail::FromField.new("From", "Mikel") }.should_not raise_error
    end

    it "should mix in the CommonAddress module" do
      Mail::FromField.included_modules.should include(Mail::CommonAddress::InstanceMethods) 
    end

    it "should aFromept two strings with the field separate" do
      t = Mail::FromField.new('From', 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'From'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should aFromept a string with the field name" do
      t = Mail::FromField.new('From: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'From'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should aFromept a string without the field name" do
      t = Mail::FromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'From'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oFromurs in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::FromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.formatted.should == ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::FromField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
      t.formatted.first.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      t.addresses.last.should == 'ada@test.lindsaar.net'
    end

    it "should return one address and a group" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.addresses[0].should == 'sam@me.com'
      t.addresses[1].should == 'mikel@me.com'
      t.addresses[2].should == 'bob@you.com'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.to_s.should == 'sam@me.com, my_group: mikel@me.com, bob@you.com;'
    end
    
    it "should return the encoded line" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.encoded.should == "From: sam@me.com, my_group: mikel@me.com, bob@you.com;\r\n"
    end
    
  end
  
  
end
