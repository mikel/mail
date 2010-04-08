require 'spec_helper'

describe Mail::Encodings::QuotedPrintable do
  
  it "should encode quoted printable from text" do
    result = "This is a test=\r\n"
    Mail::Encodings::QuotedPrintable.encode('This is a test').should == result
  end
  
  it "should decode quoted printable" do
    result = "This is a test"
    Mail::Encodings::QuotedPrintable.decode("This is a test").should == result
  end
  
  it "should encode quoted printable from binary" do
    result = "=00=00=00=00=\r\n"
    Mail::Encodings::QuotedPrintable.encode("\000\000\000\000").should == result
  end
  
  it "should decode quoted printable text" do
    result = "\000\000\000\000"
    Mail::Encodings::QuotedPrintable.decode("=00=00=00=00").should == result
  end
  
  it "should encode an ascii string that has carriage returns if asked to" do
    result = "=0Aasdf=0A"
    Mail::Encodings::QuotedPrintable.encode("\nasdf\n").should == result
  end
  
end
