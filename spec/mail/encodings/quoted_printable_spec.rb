require 'spec_helper'

describe Mail::Encodings::QuotedPrintable do
  
  it "should encode quoted printable from text" do
    result = "This is\r\na test=\r\n"
    expect(Mail::Encodings::QuotedPrintable.encode("This is\na test")).to eq result
  end

  it "should encode quoted printable from crlf text" do
    result = "This is\r\na test=\r\n"
    expect(Mail::Encodings::QuotedPrintable.encode("This is\r\na test")).to eq result
  end

  it "should encode quoted printable from cr text" do
    result = "This is\r\na test=\r\n"
    expect(Mail::Encodings::QuotedPrintable.encode("This is\ra test")).to eq result
  end
  
  it "should decode quoted printable" do
    result = "This is\na test"
    expect(Mail::Encodings::QuotedPrintable.decode("This is\r\na test")).to eq result
  end
  
  it "should encode quoted printable from binary" do
    result = "=00=00=00=00=\r\n"
    expect(Mail::Encodings::QuotedPrintable.encode("\000\000\000\000")).to eq result
  end
  
  it "should decode quoted printable text" do
    result = "\000\000\000\000"
    expect(Mail::Encodings::QuotedPrintable.decode("=00=00=00=00")).to eq result
  end

  %w(=0D =0A =0D=0A).each do |linebreak|
    expected = "first line wraps\n\nsecond paragraph"
    it "should cope with inappropriate #{linebreak} line break encoding" do
      body = "first line=\r\n wraps#{linebreak}\r\n#{linebreak}\r\nsecond paragraph=\r\n"
      expect(Mail::Encodings::QuotedPrintable.decode(body)).to eq expected
    end
  end

  [["\r", "=0D"], ["\n", "=0A"], ["\r\n", "=0D=0A"]].each do |crlf, linebreak|
    expected = "first line wraps\n\nsecond paragraph"
    it "should allow encoded #{linebreak} line breaks with soft line feeds" do
      body = "first line=\r\n wraps#{linebreak}=\r\n#{linebreak}=\r\nsecond paragraph=\r\n"
      expect(Mail::Encodings::QuotedPrintable.decode(body)).to eq expected
    end
  end
  
end
