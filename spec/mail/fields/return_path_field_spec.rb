require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

describe Mail::ReturnPathField do
  it "should allow you to specify a field" do
    rp = Mail::ReturnPathField.new('Return-Path: mikel@test.lindsaar.net')
    rp.address.should == 'mikel@test.lindsaar.net'
  end
end
