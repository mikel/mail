# encoding: utf-8
require 'spec_helper'

describe "ContentTransferEncodingParser" do

  it "should work" do
    text = "quoted-printable"
    a = Mail::Parsers::ContentTransferEncodingParser.new
    expect(a.parse(text).error).to be_nil
    expect(a.parse(text).encoding).to eq 'quoted-printable'
  end

  describe "trailing semi colons" do

    it "should parse" do
      text = "quoted-printable;"
      a = Mail::Parsers::ContentTransferEncodingParser.new
      expect(a.parse(text).error).to be_nil
      expect(a.parse(text).encoding).to eq 'quoted-printable'
    end

    it "should parse with pre white space" do
      text = 'quoted-printable  ;'
      a = Mail::Parsers::ContentTransferEncodingParser.new
      expect(a.parse(text).error).to be_nil
      expect(a.parse(text).encoding).to eq 'quoted-printable'
    end

    it "should parse with trailing white space" do
      text = 'quoted-printable; '
      a = Mail::Parsers::ContentTransferEncodingParser.new
      expect(a.parse(text).error).to be_nil
      expect(a.parse(text).encoding).to eq 'quoted-printable'
    end

    it "should parse with pre and trailing white space" do
      text = 'quoted-printable  ;  '
      a = Mail::Parsers::ContentTransferEncodingParser.new
      expect(a.parse(text).error).to be_nil
      expect(a.parse(text).encoding).to eq 'quoted-printable'
    end
  end

  describe "x-token values" do
    it "should work" do
      text = 'x-my-token'
      a = Mail::Parsers::ContentTransferEncodingParser.new
      expect(a.parse(text).error).to be_nil
      expect(a.parse(text).encoding).to eq 'x-my-token'
    end
  end

  describe "wild content-transfer-encoding" do
    %w(7bits 8bits 7-bit 8-bit).each do |mechanism|
      it "should parse #{mechanism} variant" do
        a = Mail::Parsers::ContentTransferEncodingParser.new
        expect(a.parse(mechanism).error).to be_nil
        expect(a.parse(mechanism).encoding).to eq mechanism
      end
    end
  end
end
