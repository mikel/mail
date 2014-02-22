require 'spec_helper'

describe Mail::Encodings::Base64 do
  
  it "should encode base 64 from text" do
    result = "VGhpcyBpcyBhIHRlc3Q=\r\n"
    expect(Mail::Encodings::Base64.encode('This is a test')).to eq result
  end
  
  it "should decode base 64 text" do
    result = 'This is a test'
    expect(Mail::Encodings::Base64.decode("VGhpcyBpcyBhIHRlc3Q=\n")).to eq result
  end
  
  it "should encode base 64 from binary" do
    result = "AAAAAA==\r\n"
    expect(Mail::Encodings::Base64.encode("\000\000\000\000")).to eq result
  end
  
  it "should decode base 64 text" do
    result = "\000\000\000\000"
    expect(Mail::Encodings::Base64.decode("AAAAAA==\n")).to eq result
  end
  
end
