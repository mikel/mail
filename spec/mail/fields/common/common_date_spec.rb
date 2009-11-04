require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mail::CommonAddress do
  
  describe "encoding and decoding fields" do
    
    it "should allow us to encode an date field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      field.encoded.should == "Date: 12 Aug 2009 00:00:02 GMT\r\n"
    end
    
    it "should allow us to encode an resent date field" do
      field = Mail::ResentDateField.new('12 Aug 2009 00:00:02 GMT')
      field.encoded.should == "Resent-Date: 12 Aug 2009 00:00:02 GMT\r\n"
    end

    it "should allow us to decode an address field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      field.decoded.should == "12 Aug 2009 00:00:02 GMT"
    end
    
  end
  
  
end
