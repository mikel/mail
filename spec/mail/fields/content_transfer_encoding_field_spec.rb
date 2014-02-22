require 'spec_helper'

describe Mail::ContentTransferEncodingField do

  # Content-Transfer-Encoding Header Field
  # 
  # Many media types which could be usefully transported via email are
  # represented, in their "natural" format, as 8bit character or binary
  # data.  Such data cannot be transmitted over some transfer protocols.
  # For example, RFC 821 (SMTP) restricts mail messages to 7bit US-ASCII
  # data with lines no longer than 1000 characters including any trailing
  # CRLF line separator.
  # 
  # It is necessary, therefore, to define a standard mechanism for
  # encoding such data into a 7bit short line format.  Proper labelling
  # of unencoded material in less restrictive formats for direct use over
  # less restrictive transports is also desireable.  This document
  # specifies that such encodings will be indicated by a new "Content-
  # Transfer-Encoding" header field.  This field has not been defined by
  # any previous standard.
  # 
  # 6.1.  Content-Transfer-Encoding Syntax
  # 
  # The Content-Transfer-Encoding field's value is a single token
  # specifying the type of encoding, as enumerated below.  Formally:
  # 
  #   encoding := "Content-Transfer-Encoding" ":" mechanism
  # 
  #   mechanism := "7bit" / "8bit" / "binary" /
  #                "quoted-printable" / "base64" /
  #                ietf-token / x-token
  # 
  # These values are not case sensitive -- Base64 and BASE64 and bAsE64
  # are all equivalent.  An encoding type of 7BIT requires that the body
  # 
  # is already in a 7bit mail-ready representation.  This is the default
  # value -- that is, "Content-Transfer-Encoding: 7BIT" is assumed if the
  # Content-Transfer-Encoding header field is not present.
  # 
  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ContentTransferEncodingField.new("Content-Transfer-Encoding: 7bit") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::ContentTransferEncodingField.new('Content-Transfer-Encoding: 7bit')
      expect(t.name).to eq 'Content-Transfer-Encoding'
      expect(t.value).to eq '7bit'
    end

    it "should accept a string without the field name" do
      t = Mail::ContentTransferEncodingField.new('7bit')
      expect(t.name).to eq 'Content-Transfer-Encoding'
      expect(t.value).to eq '7bit'
    end

    it "should render an encoded field" do
      t = Mail::ContentTransferEncodingField.new('7bit')
      expect(t.encoded).to eq "Content-Transfer-Encoding: 7bit\r\n"
    end

    it "should render a decoded field" do
      t = Mail::ContentTransferEncodingField.new('7bit')
      expect(t.decoded).to eq '7bit'
    end

  end

  describe "parsing the value" do
    
    it "should return an encoding string" do
      ["7bit", "8bit", "binary", 'quoted-printable', "base64"].each do |encoding|
        t = Mail::ContentTransferEncodingField.new(encoding)
        expect(t.encoding).to eq encoding
      end
    end

    it "should treat 7bits/7-bit and 8bits/8-bit as 7bit and 8bit" do
      %w(7bits 7-bit).each do |mechanism|
        expect(Mail::ContentTransferEncodingField.new(mechanism).encoding).to eq '7bit'
      end

      %w(8bits 8-bit).each do |mechanism|
        expect(Mail::ContentTransferEncodingField.new(mechanism).encoding).to eq '8bit'
      end
    end
    
    it "should handle any valid 'x-token' value" do
      t = Mail::ContentTransferEncodingField.new('X-This-is_MY-encoding')
      expect(t.encoding).to eq 'x-this-is_my-encoding'
    end
    
    it "should handle an x-encoding" do
      t = Mail::ContentTransferEncodingField.new("x-uuencode")
      expect(t.encoding).to eq "x-uuencode"
    end

    it "should handle an ietf encoding (practically, any token)" do
      t = Mail::ContentTransferEncodingField.new("ietf-token")
      expect(t.encoding).to eq "ietf-token"
    end

    it "should replace the existing value" do
      t = Mail::ContentTransferEncodingField.new("7bit")
      t.parse("quoted-printable")
      expect(t.encoding).to eq 'quoted-printable'
    end

    it "should raise an error on bogus values" do
      expect(doing { Mail::ContentTransferEncodingField.new("broken@foo") }).to raise_error
    end 
    
    it "should handle an empty content transfer encoding" do
      t = Mail::ContentTransferEncodingField.new("")
      expect(t.encoding).to eq ""
    end

    it "should handle a hyphen" do
      t = Mail::ContentTransferEncodingField.new('7-bit')
      expect(t.decoded).to eq '7bit'
      t = Mail::ContentTransferEncodingField.new('8-bit')
      expect(t.decoded).to eq '8bit'
    end

  end

end
