require File.dirname(__FILE__) + '/../../spec_helper'


describe Mail::CcField do
  it "should initialize" do
    doing { Mail::CcField.new("Cc", "Mikel") }.should_not raise_error
  end
  
  it "should mix in the AddressField module" do
    Mail::CcField.included_modules.should include(Mail::AddressField::InstanceMethods) 
  end
  
  # Actual testing of AddressField methods occurs in the address field spec file

end
