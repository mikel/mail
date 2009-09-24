require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe Mail::TransferEncodings do
  
  describe "base64 Encoding" do
  
    it "should return true for base64" do
      Mail::TransferEncodings.defined?('base64').should be_true
    end
  
    it "should return true for Base64" do
      Mail::TransferEncodings.defined?('Base64').should be_true
    end
  
    it "should return true for :base64" do
      Mail::TransferEncodings.defined?(:base64).should be_true
    end
  
    it "should return the Base64 Encoding class" do
      Mail::TransferEncodings.get_encoding('Base64').should == Mail::TransferEncodings::Base64
    end
  
    it "should return the base64 Encoding class" do
      Mail::TransferEncodings.get_encoding('base64').should == Mail::TransferEncodings::Base64
    end
  
    it "should return the base64 Encoding class" do
      Mail::TransferEncodings.get_encoding(:base64).should == Mail::TransferEncodings::Base64
    end

  end

  describe "quoted-printable Encoding" do
  
    it "should return true for quoted-printable" do
      Mail::TransferEncodings.defined?('quoted-printable').should be_true
    end
  
    it "should return true for Quoted-Printable" do
      Mail::TransferEncodings.defined?('Quoted-Printable').should be_true
    end
  
    it "should return true for :quoted_printable" do
      Mail::TransferEncodings.defined?(:quoted_printable).should be_true
    end
  
    it "should return the QuotedPrintable Encoding class" do
      Mail::TransferEncodings.get_encoding('quoted-printable').should == Mail::TransferEncodings::QuotedPrintable
    end
  
    it "should return the QuotedPrintable Encoding class" do
      Mail::TransferEncodings.get_encoding('Quoted-Printable').should == Mail::TransferEncodings::QuotedPrintable
    end
  
    it "should return the QuotedPrintable Encoding class" do
      Mail::TransferEncodings.get_encoding(:quoted_printable).should == Mail::TransferEncodings::QuotedPrintable
    end

  end


  
end
