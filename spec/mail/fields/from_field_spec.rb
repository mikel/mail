# encoding: utf-8
require 'spec_helper'

# 
# from            =       "From:" mailbox-list CRLF

describe Mail::FromField do
  
  describe "initialization" do

    it "should initialize" do
      doing { Mail::FromField.new("From", "Mikel") }.should_not raise_error
    end

    it "should mix in the CommonAddress module" do
      Mail::FromField.included_modules.should include(Mail::CommonAddress) 
    end

    it "should accept a string with the field name" do
      t = Mail::FromField.new('From: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'From'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
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
      t.value.should == 'sam@me.com, my_group: mikel@me.com, bob@you.com;'
    end
    
    it "should return the encoded line" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.encoded.should == "From: sam@me.com, \r\n\smy_group: mikel@me.com, \r\n\sbob@you.com;\r\n"
    end
    
    it "should return the encoded line" do
      t = Mail::FromField.new("bob@me.com")
      t.encoded.should == "From: bob@me.com\r\n"
    end
    
    it "should return the decoded line" do
      t = Mail::FromField.new('sam@me.com, my_group: mikel@me.com, bob@you.com;')
      t.decoded.should == "sam@me.com, my_group: mikel@me.com, bob@you.com;"
    end
    
  end
  
  it "should handle non ascii" do
    t = Mail::FromField.new('"Foo áëô îü" <extended@example.net>')
    t.decoded.should == '"Foo áëô îü" <extended@example.net>'
    t.encoded.should == "From: =?UTF-8?B?Rm9vIMOhw6vDtCDDrsO8?= <extended@example.net>\r\n"
  end
  
  
  it "should work without quotes" do
    t = Mail::FromField.new('Foo áëô îü <extended@example.net>')
    t.encoded.should == "From: Foo =?UTF-8?B?w6HDq8O0?= =?UTF-8?B?IMOuw7w=?= <extended@example.net>\r\n"
    t.decoded.should == '"Foo áëô îü" <extended@example.net>'
  end

end
