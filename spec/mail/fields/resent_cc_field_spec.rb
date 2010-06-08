# encoding: utf-8
require 'spec_helper'
# 
# resent-cc       =       "Resent-Cc:" address-list CRLF

describe Mail::ResentCcField do
  
  describe "initialization" do

    it "should initialize" do
      doing { Mail::ResentCcField.new("ResentCc", "Mikel") }.should_not raise_error
    end

    it "should mix in the CommonAddress module" do
      Mail::ResentCcField.included_modules.should include(Mail::CommonAddress) 
    end

    it "should accept a string with the field name" do
      t = Mail::ResentCcField.new('Resent-Cc: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'Resent-Cc'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
      t = Mail::ResentCcField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'Resent-Cc'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oResentCcurs in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::ResentCcField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.formatted.should == ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::ResentCcField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, Ada Lindsaar <ada@test.lindsaar.net>')
      t.formatted.first.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
      t.addresses.last.should == 'ada@test.lindsaar.net'
    end

    it "should return one address and a group" do
      t = Mail::ResentCcField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.addresses[0].should == 'sam@me.com'
      t.addresses[1].should == 'mikel@me.com'
      t.addresses[2].should == 'bob@you.com'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::ResentCcField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.value.should == 'sam@me.com, my_group: mikel@me.com, bob@you.com;'
    end
    
    it "should return the encoded line" do
      t = Mail::ResentCcField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.encoded.should == "Resent-Cc: sam@me.com, \r\n\smy_group: mikel@me.com, \r\n\sbob@you.com;\r\n"
    end
    
  end
  
  
end
