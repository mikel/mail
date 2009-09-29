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

  describe "B encodings" do
    # From rfc2047:
    # From: =?US-ASCII?Q?Keith_Moore?= <moore@cs.utk.edu>
    # To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
    # CC: =?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>
    # Subject: =?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=
    #  =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=
    # 
    # Note: In the first 'encoded-word' of the Subject field above, the
    # last "=" at the end of the 'encoded-text' is necessary because each
    # 'encoded-word' must be self-contained (the "=" character completes a
    # group of 4 base64 characters representing 2 octets).  An additional
    # octet could have been encoded in the first 'encoded-word' (so that
    # the encoded-word would contain an exact multiple of 3 encoded
    # octets), except that the second 'encoded-word' uses a different
    # 'charset' than the first one.
    # 
    it "should return a B encoded string" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        string = string.force_encoding('US-ASCII')
        Mail::Encodings.b_encode(string).should == '=?US-ASCII?B?VGhpcyBpcyBhIHN0cmluZw==?='
      else
        string = "This is a string"
        encoding = 'US-ASCII'
        Mail::Encodings.b_encode(string, encoding).should == '=?US-ASCII?B?VGhpcyBpcyBhIHN0cmluZw==?='
      end
    end
    
    it "should raise an argument error if no encoding is passed to less than Ruby 1.9" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        doing {Mail::Encodings.b_encode(string)}.should_not raise_error
      else
        string = "This is a string"
        doing {Mail::Encodings.b_encode(string)}.should raise_error
      end
    end
    
    it "should accept other encodings" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.b_encode(string).should == '=?UTF-8?B?VGhpcyBpcyBhIHN0cmluZw==?='
      else
        string = "This is a string"
        encoding = 'UTF-8'
        Mail::Encodings.b_encode(string, encoding).should == '=?UTF-8?B?VGhpcyBpcyBhIHN0cmluZw==?='
      end
    end
  end


  describe "Q encodings" do
    # From rfc2047:
    # From: =?US-ASCII?Q?Keith_Moore?= <moore@cs.utk.edu>
    # To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
    # CC: =?ISO-8859-1?Q?Andr=E9?= Pirard <PIRARD@vm1.ulg.ac.be>
    # Subject: =?ISO-8859-1?B?SWYgeW91IGNhbiByZWFkIHRoaXMgeW8=?=
    #  =?ISO-8859-2?B?dSB1bmRlcnN0YW5kIHRoZSBleGFtcGxlLg==?=
    # 
    # Note: In the first 'encoded-word' of the Subject field above, the
    # last "=" at the end of the 'encoded-text' is necessary because each
    # 'encoded-word' must be self-contained (the "=" character completes a
    # group of 4 base64 characters representing 2 octets).  An additional
    # octet could have been encoded in the first 'encoded-word' (so that
    # the encoded-word would contain an exact multiple of 3 encoded
    # octets), except that the second 'encoded-word' uses a different
    # 'charset' than the first one.
    # 
    it "should return a Q encoded string" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        string = string.force_encoding('US-ASCII')
        Mail::Encodings.q_encode(string).should == '=?US-ASCII?Q?This_is_a_string?='
      else
        string = "This is a string"
        encoding = 'US-ASCII'
        Mail::Encodings.q_encode(string, encoding).should == '=?US-ASCII?Q?This_is_a_string?='
      end
    end
    
    it "should raise an argument error if no encoding is passed to less than Ruby 1.9" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        doing {Mail::Encodings.q_encode(string)}.should_not raise_error
      else
        string = "This is a string"
        doing {Mail::Encodings.q_encode(string)}.should raise_error
      end
    end
    
    it "should accept other encodings" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.q_encode(string).should == '=?UTF-8?Q?This_is_a_string?='
      else
        string = "This is a string"
        encoding = 'UTF-8'
        Mail::Encodings.q_encode(string, encoding).should == '=?UTF-8?Q?This_is_a_string?='
      end
    end
    
  end
  
end
