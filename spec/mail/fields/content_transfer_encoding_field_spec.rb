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
      doing { Mail::ContentTransferEncodingField.new("Content-Transfer-Encoding: 7bit") }.should_not raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::ContentTransferEncodingField.new('Content-Transfer-Encoding: 7bit')
      t.name.should == 'Content-Transfer-Encoding'
      t.value.should == '7bit'
    end

    it "should accept a string without the field name" do
      t = Mail::ContentTransferEncodingField.new('7bit')
      t.name.should == 'Content-Transfer-Encoding'
      t.value.should == '7bit'
    end

    it "should render an encoded field" do
      t = Mail::ContentTransferEncodingField.new('7bit')
      t.encoded.should == "Content-Transfer-Encoding: 7bit\r\n"
    end

    it "should render a decoded field" do
      t = Mail::ContentTransferEncodingField.new('7bit')
      t.decoded.should == '7bit'
    end

  end

  describe "parsing the value" do
    
    it "should return an encoding string" do
      ["7bit", "8bit", "binary", 'quoted-printable', "base64"].each do |encoding|
        t = Mail::ContentTransferEncodingField.new(encoding)
        t.encoding.should == encoding
      end
    end
    
    it "should handle any valid 'x-token' value" do
      t = Mail::ContentTransferEncodingField.new('X-This-is_MY-encoding')
      t.encoding.should == 'x-this-is_my-encoding'
    end
    
    it "should handle an x-encoding" do
      t = Mail::ContentTransferEncodingField.new("x-uuencode")
      t.encoding.should == "x-uuencode"
    end

    it "should replace the existing value" do
      t = Mail::ContentTransferEncodingField.new("7bit")
      t.parse("quoted-printable")
      t.encoding.should == 'quoted-printable'
    end

    it "should raise an error on bogus values" do
      doing { Mail::ContentTransferEncodingField.new("broken@foo") }.should raise_error
    end 
    
    it "should handle an empty content transfer encoding" do
      t = Mail::ContentTransferEncodingField.new("")
      t.encoding.should == ""
    end

    it "should handle a hyphen" do
      t = Mail::ContentTransferEncodingField.new('7-bit')
      t.decoded.should == '7bit'
      t = Mail::ContentTransferEncodingField.new('8-bit')
      t.decoded.should == '8bit'
    end

  end

end
