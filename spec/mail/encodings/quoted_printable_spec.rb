# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::Encodings::QuotedPrintable do

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

  it "should bypass line ending conversion for binary encoding" do
    text = "test \r \xF0\x9F\x8D\xBF"
    text = text.dup.force_encoding(Encoding::BINARY) if text.respond_to?(:force_encoding)
    expect(Mail::Encodings::QuotedPrintable.encode(text)).to eq "test =0D =F0=9F=8D=BF=\r\n"
  end

  it "should decode quoted printable" do
    result = "This is\na test"
    expect(Mail::Encodings::QuotedPrintable.decode("This is\r\na test")).to eq result
  end

  it "should encode quoted printable from binary" do
    text = "\000\000\r\xF0\x9F\x98\x8A\n\000\000"
    text = text.dup.force_encoding(Encoding::BINARY) if text.respond_to?(:force_encoding)
    expect(Mail::Encodings::QuotedPrintable.encode(text)).to eq "=00=00=0D=F0=9F=98=8A\r\n=00=00=\r\n"
  end

  it "should decode quoted printable text" do
    result = "\000\000\n\000\000"
    expect(Mail::Encodings::QuotedPrintable.decode("=00=00=0D=0A=00=00")).to eq result
  end

  it "should bypass line ending conversion for binary decoding" do
    result = "test \r \xF0\x9F\x8D\xBF"
    result = result.dup.force_encoding(Encoding::BINARY) if result.respond_to?(:force_encoding)
    expect(Mail::Encodings::QuotedPrintable.decode("test =0D =F0=9F=8D=BF=\n")).to eq result
  end

  [["\r", "=0D"], ["\n", "=0A"], ["\r\n", "=0D=0A"]].each do |crlf, linebreak|
    expected = "first line wraps\n\nsecond paragraph"

    it "should cope with inappropriate #{linebreak} line break encoding" do
      body = "first line=\r\n wraps#{linebreak}\r\n#{linebreak}\r\nsecond paragraph=\r\n"
      expect(Mail::Encodings::QuotedPrintable.decode(body)).to eq expected
    end

    it "should allow encoded #{linebreak} line breaks with soft line feeds" do
      body = "first line=\r\n wraps#{linebreak}=\r\n#{linebreak}=\r\nsecond paragraph=\r\n"
      expect(Mail::Encodings::QuotedPrintable.decode(body)).to eq expected
    end
  end
end
