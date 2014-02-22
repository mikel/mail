require 'spec_helper'

describe Mail::CommonAddress do
  
  describe "encoding and decoding fields" do
    
    it "should allow us to encode an date field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      expect(field.encoded).to eq "Date: Wed, 12 Aug 2009 00:00:02 +0000\r\n"
    end
    
    it "should allow us to encode an resent date field" do
      field = Mail::ResentDateField.new('12 Aug 2009 00:00:02 GMT')
      expect(field.encoded).to eq "Resent-Date: Wed, 12 Aug 2009 00:00:02 +0000\r\n"
    end

    it "should allow us to decode an address field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      expect(field.decoded).to eq "Wed, 12 Aug 2009 00:00:02 +0000"
    end
    
  end
  
  
end
