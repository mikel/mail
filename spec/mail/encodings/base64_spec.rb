require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

describe Mail::Encodings::Base64 do
  
  it "should encode base 64 from text" do
    result = "VGhpcyBpcyBhIHRlc3Q=\n"
    Mail::Encodings::Base64.encode('This is a test').should == result
  end
  
  it "should decode base 64 text" do
    result = 'This is a test'
    Mail::Encodings::Base64.decode("VGhpcyBpcyBhIHRlc3Q=\n").should == result
  end
  
  it "should encode base 64 from binary" do
    result = "AAAAAA==\n"
    Mail::Encodings::Base64.encode("\000\000\000\000").should == result
  end
  
  it "should decode base 64 text" do
    result = "\000\000\000\000"
    Mail::Encodings::Base64.decode("AAAAAA==\n").should == result
  end
  
end
