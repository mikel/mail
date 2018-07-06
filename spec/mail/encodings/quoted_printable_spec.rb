# frozen_string_literal: true
require 'spec_helper'

describe Mail::Encodings::QuotedPrintable do
  
  it "should encode quoted printable from text" do
    result = "This is=0A=\r\na test=\n"
    expect(Mail::Encodings::QuotedPrintable.encode("This is\na test")).to eq result
  end

  it "should encode quoted printable from crlf text" do
    result = "This is=0D=0A=\r\na test=\n"
    expect(Mail::Encodings::QuotedPrintable.encode("This is\r\na test")).to eq result
  end

  it "should encode quoted printable from cr text" do
    result = "This is=0Da test=\n"
    expect(Mail::Encodings::QuotedPrintable.encode("This is\ra test")).to eq result
  end
  
  it "should decode quoted printable" do
    result = "This is\r\na test"
    expect(Mail::Encodings::QuotedPrintable.decode("This is\r\na test")).to eq result
  end
  
  it "should encode quoted printable from binary" do
    result = "=00=00=00=00=\n"
    expect(Mail::Encodings::QuotedPrintable.encode("\000\000\000\000")).to eq result
  end

  it "should normalize line separator after =0D=" do
    pad = "a" * 71
    result = pad + "=0D=\r\n=0A=\r\ntest=\n"
    expect(Mail::Encodings::QuotedPrintable.encode(pad + "\r\ntest")).to eq result
  end
  
  it "should decode quoted printable text" do
    result = "\000\000\000\000"
    expect(Mail::Encodings::QuotedPrintable.decode("=00=00=00=00")).to eq result
  end

#  it "should not exceed 76 chars limit per line" do
#    Mail::Encodings::QuotedPrintable.encode((("a" * 72) + "\r\n") * 5).each_line do |line|
#      expect(line.length).to be <= 76
#    end
#  end

  [["\r", "=0D"], ["\n", "=0A=\r\n"], ["\r\n", "=0D=0A=\r\n"]].each do |crlf, linebreak|
    expected = "paragraph#{linebreak}second paragraph=\n"
    it "should not encode #{crlf.inspect} as a single cr or lf" do
      body = "paragraph#{crlf}second paragraph"
      expect(Mail::Encodings::QuotedPrintable.encode(body)).to eq expected
    end
  end
  
end
