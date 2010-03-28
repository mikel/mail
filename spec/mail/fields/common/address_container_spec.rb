# encoding: utf-8
require 'spec_helper'

describe 'AddressContainer' do
  it "should allow you to append an address to an address field result" do
    m = Mail.new("To: mikel@test.lindsaar.net")
    m.to.should == ['mikel@test.lindsaar.net']
    m.to << 'bob@test.lindsaar.net'
    m.to.should == ['mikel@test.lindsaar.net', 'bob@test.lindsaar.net']
  end
  
  it "should handle complex addresses correctly" do
    m = Mail.new("From: mikel@test.lindsaar.net")
    m.from.should == ['mikel@test.lindsaar.net']
    m.from << '"Ada Lindsaar" <ada@test.lindsaar.net>, bob@test.lindsaar.net'
    m.from.should == ['mikel@test.lindsaar.net', 'ada@test.lindsaar.net', 'bob@test.lindsaar.net']
  end
end
