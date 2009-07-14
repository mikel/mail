require File.dirname(__FILE__) + '/../../spec_helper'


describe Mail::BccField do
  it "should initialize" do
    doing { Mail::BccField.new("Bcc", "Mikel") }.should_not raise_error
  end
  
  
  it "should mix in the AddressField module" do
    Mail::BccField.included_modules.should include(Mail::AddressField::InstanceMethods) 
  end
  
  # Actual testing of AddressField methods occurs in the address field spec file

end
