# encoding: utf-8
require 'spec_helper'

describe Mail::Encodings::QuotedPrintable do
  def utf8(str)
    str.respond_to?(:force_encoding) ? str.force_encoding("utf-8") : str
  end

  def decode(str)
    Mail::Encodings::QuotedPrintable.decode(str)
  end

  def encode(str)
    Mail::Encodings::QuotedPrintable.encode(str)
  end

  it "should be symetric" do
    expect(utf8(decode(encode("tå∂ƒt")))).to eq "tå∂ƒt"
    expect(utf8(encode(decode("t=C3=A5=E2=88=82=C6=92t")))).to eq "t=C3=A5=E2=88=82=C6=92t=\r\n"
  end

  it "should encode quoted printable from text" do
    result = "This is\r\na test=\r\n"
    expect(encode("This is\na test")).to eq result
  end

  it "should encode quoted printable from crlf text" do
    result = "This is\r\na test=\r\n"
    expect(encode("This is\r\na test")).to eq result
  end

  it "should encode quoted printable from cr text" do
    result = "This is\r\na test=\r\n"
    expect(encode("This is\ra test")).to eq result
  end

  it "should decode quoted printable" do
    result = "This is\na test"
    expect(decode("This is\r\na test")).to eq result
  end

  it "should encode quoted printable from binary" do
    result = "=00=00=00=00=\r\n"
    expect(encode("\000\000\000\000")).to eq result
  end

  it "should decode quoted printable text" do
    result = "\000\000\000\000"
    expect(decode("=00=00=00=00")).to eq result
  end

  # https://bugs.ruby-lang.org/issues/7175
  it "should remove trailing equal" do
    expect(utf8(decode("t=C3=A5=E2=88=82=C6=92t="))).to eq "tå∂ƒt"
  end

  %w(=0D =0A =0D=0A).each do |linebreak|
    expected = "first line wraps\n\nsecond paragraph"
    it "should cope with inappropriate #{linebreak} line break encoding" do
      body = "first line=\r\n wraps#{linebreak}\r\n#{linebreak}\r\nsecond paragraph=\r\n"
      expect(decode(body)).to eq expected
    end
  end

  [["\r", "=0D"], ["\n", "=0A"], ["\r\n", "=0D=0A"]].each do |crlf, linebreak|
    expected = "first line wraps\n\nsecond paragraph"
    it "should allow encoded #{linebreak} line breaks with soft line feeds" do
      body = "first line=\r\n wraps#{linebreak}=\r\n#{linebreak}=\r\nsecond paragraph=\r\n"
      expect(decode(body)).to eq expected
    end
  end
end
