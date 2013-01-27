# encoding: utf-8
require 'spec_helper'

describe "ContentTransferEncodingParser" do

  it "should work" do
    text = "quoted-printable"
    a = Mail::ContentTransferEncodingParser.new
    a.parse(text).should_not be_nil
    a.parse(text).encoding.text_value.should eq 'quoted-printable'
  end

  describe "trailing semi colons" do

    it "should parse" do
      text = "quoted-printable;"
      a = Mail::ContentTransferEncodingParser.new
      a.parse(text).should_not be_nil
      a.parse(text).encoding.text_value.should eq 'quoted-printable'
    end

    it "should parse with pre white space" do
      text = 'quoted-printable  ;'
      a = Mail::ContentTransferEncodingParser.new
      a.parse(text).should_not be_nil
      a.parse(text).encoding.text_value.should eq 'quoted-printable'
    end

    it "should parse with trailing white space" do
      text = 'quoted-printable; '
      a = Mail::ContentTransferEncodingParser.new
      a.parse(text).should_not be_nil
      a.parse(text).encoding.text_value.should eq 'quoted-printable'
    end

    it "should parse with pre and trailing white space" do
      text = 'quoted-printable  ;  '
      a = Mail::ContentTransferEncodingParser.new
      a.parse(text).should_not be_nil
      a.parse(text).encoding.text_value.should eq 'quoted-printable'
    end
  end

  describe "x-token values" do
    it "should work" do
      text = 'x-my-token'
      a = Mail::ContentTransferEncodingParser.new
      a.parse(text).should_not be_nil
      a.parse(text).encoding.text_value.should eq 'x-my-token'
    end
  end

  describe "wild content-transfer-encoding" do
    %w(7bits 8bits 7-bit 8-bit).each do |mechanism|
      it "should parse #{mechanism} variant" do
        a = Mail::ContentTransferEncodingParser.new
        a.parse(mechanism).should_not be_nil
        a.parse(mechanism).encoding.text_value.should eq mechanism
      end
    end
  end
end
