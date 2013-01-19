require 'spec_helper'

describe Mail::Encodings::QuotedPrintable do
  
  it "should encode quoted printable from text" do
    result = "This is a test=\r\n"
    Mail::Encodings::QuotedPrintable.encode('This is a test').should eq result
  end
  
  it "should decode quoted printable" do
    result = "This is a test"
    Mail::Encodings::QuotedPrintable.decode("This is a test").should eq result
  end
  
  it "should encode quoted printable from binary" do
    result = "=00=00=00=00=\r\n"
    Mail::Encodings::QuotedPrintable.encode("\000\000\000\000").should eq result
  end
  
  it "should decode quoted printable text" do
    result = "\000\000\000\000"
    Mail::Encodings::QuotedPrintable.decode("=00=00=00=00").should eq result
  end
  
  it "should not double encode line endings" do
    result = "\r\n"
    Mail::Encodings::QuotedPrintable.decode(Mail::Encodings::QuotedPrintable.encode(result)).should eq result
  end
  
end
