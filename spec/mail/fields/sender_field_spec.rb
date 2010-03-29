# encoding: utf-8
require 'spec_helper'

describe Mail::SenderField do
  # sender          =       "Sender:" mailbox CRLF
  # 
  
  describe "initialization" do

    it "should initialize" do
      doing { Mail::SenderField.new("Sender", "Mikel") }.should_not raise_error
    end

    it "should mix in the CommonAddress module" do
      Mail::SenderField.included_modules.should include(Mail::CommonAddress) 
    end

    it "should accept a string with the field name" do
      t = Mail::SenderField.new('Sender: Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'Sender'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

    it "should accept a string without the field name" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>')
      t.name.should == 'Sender'
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>, "Bob Smith" <bob@me.com>'
    end

  end
  
  # Actual testing of CommonAddress methods oSenderurs in the address field spec file

  describe "instance methods" do
    it "should return an address" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.formatted.should == ['Mikel Lindsaar <mikel@test.lindsaar.net>']
    end

    it "should return two addresses" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.address.to_s.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end
    
    it "should return the formatted line on to_s" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.value.should == 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end
    
    it "should return the encoded line" do
      t = Mail::SenderField.new('Mikel Lindsaar <mikel@test.lindsaar.net>')
      t.encoded.should == "Sender: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n"
    end
    
  end
  
  
end
