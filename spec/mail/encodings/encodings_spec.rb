# encoding: utf-8
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
        Mail::Encodings.b_value_encode(string).should == "=?US-ASCII?B?VGhpcyBpcyBhIHN0cmluZw==?="
      else
        string = "This is a string"
        encoding = 'US-ASCII'
        Mail::Encodings.b_value_encode(string, encoding).should == "=?US-ASCII?B?VGhpcyBpcyBhIHN0cmluZw==?="
      end
    end
    
    it "should raise an argument error if no encoding is passed to less than Ruby 1.9" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ string"
        doing {Mail::Encodings.b_value_encode(string)}.should_not raise_error
      else
        string = "This is あ string"
        doing {Mail::Encodings.b_value_encode(string)}.should raise_error
      end
    end
    
    it "should accept other encodings" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ string"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.b_value_encode(string).should == '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      else
        string = "This is あ string"
        encoding = 'UTF-8'
        Mail::Encodings.b_value_encode(string, encoding).should == '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      end
    end

    it "should split the string up into bite sized chunks that can be wrapped easily" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.b_value_encode(string).should == '=?UTF-8?B?VGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GCIHJl?= =?UTF-8?B?YWxseSBsb25nIHN0cmluZyBUaGlzIGlzIOOBgiByZWFsbHkgbG9uZyBzdHJp?= =?UTF-8?B?bmcgVGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GC?= =?UTF-8?B?IHJlYWxseSBsb25nIHN0cmluZw==?='
      else
        string = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
        encoding = 'UTF-8'
        Mail::Encodings.b_value_encode(string, encoding).should == '=?UTF-8?B?VGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GCIHJl?= =?UTF-8?B?YWxseSBsb25nIHN0cmluZyBUaGlzIGlzIOOBgiByZWFsbHkgbG9uZyBzdHJp?= =?UTF-8?B?bmcgVGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GC?= =?UTF-8?B?IHJlYWxseSBsb25nIHN0cmluZw==?='
      end
    end

    it "should decode an encoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.b_value_decode(string).should == result
    end

    it "should decode a long encoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GCIHJl?= =?UTF-8?B?YWxseSBsb25nIHN0cmluZyBUaGlzIGlzIOOBgiByZWFsbHkgbG9uZyBzdHJp?= =?UTF-8?B?bmcgVGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GC?= =?UTF-8?B?IHJlYWxseSBsb25nIHN0cmluZw==?='
      result = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.b_value_decode(string).should == result
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
        Mail::Encodings.q_value_encode(string).should == "=?US-ASCII?Q?This_is_a_string?="
      else
        string = "This is a string"
        encoding = 'US-ASCII'
        Mail::Encodings.q_value_encode(string, encoding).should == "=?US-ASCII?Q?This_is_a_string?="
      end
    end
    
    it "should raise an argument error if no encoding is passed to less than Ruby 1.9" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ string"
        doing {Mail::Encodings.q_value_encode(string)}.should_not raise_error
      else
        string = "This is あ string"
        doing {Mail::Encodings.q_value_encode(string)}.should raise_error
      end
    end
    
    it "should accept other character sets" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ string"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.q_value_encode(string).should == '=?UTF-8?Q?This_is_=E3=81=82_string?='
      else
        string = "This is あ string"
        encoding = 'UTF-8'
        Mail::Encodings.q_value_encode(string, encoding).should == '=?UTF-8?Q?This_is_=E3=81=82_string?='
      end
    end

    it "should decode an encoded string" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.q_value_decode(string).should == result
    end
    
    it "should detect a q encoded string and decode it" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should == result
    end
    
  end
  
  describe "parameter MIME encodings" do
    #  Character set and language information may be combined with the
    #  parameter continuation mechanism. For example:
    #
    #  Content-Type: application/x-stuff
    #   title*0*=us-ascii'en'This%20is%20even%20more%20
    #   title*1*=%2A%2A%2Afun%2A%2A%2A%20
    #   title*2="isn't it!"
    #
    #  Note that:
    #
    #   (1)   Language and character set information only appear at
    #         the beginning of a given parameter value.
    #
    #   (2)   Continuations do not provide a facility for using more
    #         than one character set or language in the same
    #         parameter value.
    #
    #   (3)   A value presented using multiple continuations may
    #         contain a mixture of encoded and unencoded segments.
    #
    #   (4)   The first segment of a continuation MUST be encoded if
    #         language and character set information are given.
    #
    #   (5)   If the first segment of a continued parameter value is
    #         encoded the language and character set field delimiters
    #         MUST be present even when the fields are left blank.
    #
    it "should leave an unencoded string alone" do
      string = "this isn't encoded"
      result = "this isn't encoded"
      Mail::Encodings.param_decode(string, 'us-ascii').should == result
    end
    
    it "should unencode an encoded string" do
      string = "This%20is%20even%20more%20"
      result = "This is even more "
      result.force_encoding('us-ascii') if RUBY_VERSION >= '1.9'
      Mail::Encodings.param_decode(string, 'us-ascii').should == result
    end
    
    it "should unencoded an encoded string and return the right charset on 1.9" do
      string = "This%20is%20even%20more%20"
      result = "This is even more "
      result.force_encoding('us-ascii') if RUBY_VERSION >= '1.9'
      Mail::Encodings.param_decode(string, 'us-ascii').should == result
    end
    
    it "should unencode a complete string that included unencoded parts" do
      string = "This%20is%20even%20more%20%2A%2A%2Afun%2A%2A%2A%20isn't it"
      result = "This is even more ***fun*** isn't it"
      result.force_encoding('iso-8859-1') if RUBY_VERSION >= '1.9'
      Mail::Encodings.param_decode(string, 'iso-8859-1').should == result
    end
    
    it "should encode a string" do
      string = "This is  あ string"
      if RUBY_VERSION >= '1.9'
        Mail::Encodings.param_encode(string).should == "utf-8'en'This%20is%20%20%E3%81%82%20string"
      else
        Mail::Encodings.param_encode(string).should == "utf8'en'This%20is%20%20%E3%81%82%20string"
      end
    end

    it "should just quote US-ASCII with spaces" do
      string = "This is even more"
      if RUBY_VERSION >= '1.9'
        Mail::Encodings.param_encode(string).should == '"This is even more"'
      else
        Mail::Encodings.param_encode(string).should == '"This is even more"'
      end
    end

    it "should leave US-ASCII without spaces alone" do
      string = "fun"
      if RUBY_VERSION >= '1.9'
        Mail::Encodings.param_encode(string).should == 'fun'
      else
        Mail::Encodings.param_encode(string).should == 'fun'
      end
    end
    
  end
  
  describe "decoding a string and detecting the encoding type" do
    
    it "should detect an encoded Base64 string to the decoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should == result
    end

    it "should detect an encoded QP string to the decoded string" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should == result
    end

    it "should detect an plain string and return it" do
      string = 'This is あ string'
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should == result
    end

  end
  
  describe "altering an encoded text to decoded and visa versa" do

    describe "decoding" do

      it "should detect an encoded Base64 string and return the decoded string" do
        string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
        result = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :decode).should == result
      end

      it "should detect an encoded QP string and return the decoded string" do
        string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
        result = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :decode).should == result
      end

      it "should detect an a string is already decoded and leave it alone" do
        string = 'This is あ string'
        result = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :decode).should == result
      end

    end
    
    describe "encoding" do
      
      it "should encode a string into Base64" do
        string = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
          result.force_encoding('UTF-8')
        else
          result = '=?UTF8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :encode).should == result
      end

      it "should leave a string that doesn't need encoding alone" do
        string = 'This is a string'
        result = "This is a string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :encode).should == result
      end

    end


  end
  
end
