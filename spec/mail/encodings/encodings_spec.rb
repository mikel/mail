require File.dirname(__FILE__) + '/../../spec_helper'

require 'mail'

describe Mail::Encodings do
  
  describe "base64 Encoding" do
  
    it "should return true for base64" do
      Mail::Encodings.defined?('base64').should be_true
    end
  
    it "should return true for Base64" do
      Mail::Encodings.defined?('Base64').should be_true
    end
  
    it "should return true for :base64" do
      Mail::Encodings.defined?(:base64).should be_true
    end
  
    it "should return the Base64 Encoding class" do
      Mail::Encodings.get_encoding('Base64').should == Mail::Encodings::Base64
    end
  
    it "should return the base64 Encoding class" do
      Mail::Encodings.get_encoding('base64').should == Mail::Encodings::Base64
    end
  
    it "should return the base64 Encoding class" do
      Mail::Encodings.get_encoding(:base64).should == Mail::Encodings::Base64
    end

  end

  describe "quoted-printable Encoding" do
  
    it "should return true for quoted-printable" do
      Mail::Encodings.defined?('quoted-printable').should be_true
    end
  
    it "should return true for Quoted-Printable" do
      Mail::Encodings.defined?('Quoted-Printable').should be_true
    end
  
    it "should return true for :quoted_printable" do
      Mail::Encodings.defined?(:quoted_printable).should be_true
    end
  
    it "should return the QuotedPrintable Encoding class" do
      Mail::Encodings.get_encoding('quoted-printable').should == Mail::Encodings::QuotedPrintable
    end
  
    it "should return the QuotedPrintable Encoding class" do
      Mail::Encodings.get_encoding('Quoted-Printable').should == Mail::Encodings::QuotedPrintable
    end
  
    it "should return the QuotedPrintable Encoding class" do
      Mail::Encodings.get_encoding(:quoted_printable).should == Mail::Encodings::QuotedPrintable
    end

  end


  
end
