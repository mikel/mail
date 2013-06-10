# encoding: utf-8
require 'spec_helper'

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
      Mail::Encodings.get_encoding('Base64').should eq Mail::Encodings::Base64
    end

    it "should return the base64 Encoding class" do
      Mail::Encodings.get_encoding('base64').should eq Mail::Encodings::Base64
    end

    it "should return the base64 Encoding class" do
      Mail::Encodings.get_encoding(:base64).should eq Mail::Encodings::Base64
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
      Mail::Encodings.get_encoding('quoted-printable').should eq Mail::Encodings::QuotedPrintable
    end

    it "should return the QuotedPrintable Encoding class" do
      Mail::Encodings.get_encoding('Quoted-Printable').should eq Mail::Encodings::QuotedPrintable
    end

    it "should return the QuotedPrintable Encoding class" do
      Mail::Encodings.get_encoding(:quoted_printable).should eq Mail::Encodings::QuotedPrintable
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
    it "should just return the string if us-ascii and asked to B encoded string" do
      string = "This is a string"
      result = "This is a string"
      if RUBY_VERSION >= "1.9.1"
        string = string.force_encoding('US-ASCII')
        Mail::Encodings.b_value_encode(string).should eq(result)
      else
        encoding = 'US-ASCII'
        Mail::Encodings.b_value_encode(string, encoding).should eq(result)
      end
    end

    it "should accept other encodings" do
      string = "This is あ string"
      result = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      if RUBY_VERSION >= "1.9.1"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.b_value_encode(string).should eq(result)
      else
        string = "This is あ string"
        encoding = 'UTF-8'
        Mail::Encodings.b_value_encode(string, encoding).should eq(result)
      end
    end

    it "should complain if there is no encoding passed for Ruby < 1.9" do
      string = "This is あ string"
      if RUBY_VERSION >= "1.9.1"
        string = string.force_encoding('UTF-8')
        doing {Mail::Encodings.b_value_encode(string)}.should_not raise_error
      else
        doing {Mail::Encodings.b_value_encode(string, nil)}.should raise_error("Must supply an encoding")
      end
    end

    it "should split the string up into bite sized chunks that can be wrapped easily" do
      string = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
      result = '=?UTF-8?B?VGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GCIHJl?= =?UTF-8?B?YWxseSBsb25nIHN0cmluZyBUaGlzIGlzIOOBgiByZWFsbHkgbG9uZyBzdHJp?= =?UTF-8?B?bmcgVGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GC?= =?UTF-8?B?IHJlYWxseSBsb25nIHN0cmluZw==?='
      if RUBY_VERSION >= "1.9.1"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.b_value_encode(string).should eq(result)
      else
        encoding = 'UTF-8'
        Mail::Encodings.b_value_encode(string, encoding).should eq(result)
      end
    end

    it "should decode an encoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should decode a long encoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GCIHJl?= =?UTF-8?B?YWxseSBsb25nIHN0cmluZyBUaGlzIGlzIOOBgiByZWFsbHkgbG9uZyBzdHJp?= =?UTF-8?B?bmcgVGhpcyBpcyDjgYIgcmVhbGx5IGxvbmcgc3RyaW5nIFRoaXMgaXMg44GC?= =?UTF-8?B?IHJlYWxseSBsb25nIHN0cmluZw==?='
      result = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should decode UTF-16 encoded string" do
      string = "=?UTF-16?B?MEIwRDBGMEgwSg==?="
      result = "あいうえお"
      Mail::Encodings.value_decode(string).should == result
    end

    it "should decode UTF-32 encoded string" do
      string = "=?UTF-32?B?AAAwQgAAMEQAADBGAAAwSAAAMEo=?="
      result = "あいうえお"
      Mail::Encodings.value_decode(string).should == result
    end

    it "should decode a string that looks similar to an encoded string (contains '=?')" do
      string = "1+1=?"
      Mail::Encodings.value_decode(string).should == string
    end

    it "should collapse adjacent words" do
      string = "=?utf-8?B?0L3QvtCy0YvQuSDRgdC+0YLRgNGD0LTQvdC40Log4oCUINC00L7RgNC+0YQ=?=\n =?utf-8?B?0LXQtdCy?="
      result = "новый сотрудник — дорофеев"
      Mail::Encodings.value_decode(string).should == result
    end

    if '1.9'.respond_to?(:force_encoding)
      it "should decode 8bit encoded string" do
        string = "=?8bit?Q?ALPH=C3=89E?="
        result = "ALPH\xC3\x89E"
        Mail::Encodings.value_decode(string).should == result
      end

      it "should decode ks_c_5601-1987 encoded string" do
        string = '=?ks_c_5601-1987?B?seggx/bB+A==?= <a@b.org>'.force_encoding('us-ascii')
        Mail::Encodings.value_decode(string).should == "김 현진 <a@b.org>"
      end

      it "should decode shift-jis encoded string" do
        string = '=?shift-jis?Q?=93=FA=96{=8C=EA=?='.force_encoding('us-ascii')
        Mail::Encodings.value_decode(string).should == "日本語"
      end

      it "should decode GB18030 encoded string misidentified as GB2312" do
        string = '=?GB2312?B?6V8=?='.force_encoding('us-ascii')
        Mail::Encodings.value_decode(string).should == "開"
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
    it "should just return the string if us-ascii and asked to Q encoded string" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is a string"
        string = string.force_encoding('US-ASCII')
        Mail::Encodings.q_value_encode(string).should eq "This is a string"
      else
        string = "This is a string"
        encoding = 'US-ASCII'
        Mail::Encodings.q_value_encode(string, encoding).should eq "This is a string"
      end
    end

    it "should complain if there is no encoding passed for Ruby < 1.9" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ string"
        string = string.force_encoding('UTF-8')
        doing {Mail::Encodings.q_value_encode(string)}.should_not raise_error
      else
        string = "This is あ string"
        doing {Mail::Encodings.q_value_encode(string)}.should raise_error("Must supply an encoding")
      end
    end

    it "should accept other character sets" do
      if RUBY_VERSION >= "1.9.1"
        string = "This is あ string"
        string = string.force_encoding('UTF-8')
        Mail::Encodings.q_value_encode(string).should eq '=?UTF-8?Q?This_is_=E3=81=82_string?='
      else
        string = "This is あ string"
        encoding = 'UTF-8'
        Mail::Encodings.q_value_encode(string, encoding).should eq '=?UTF-8?Q?This_is_=E3=81=82_string?='
      end
    end

    it "should decode an encoded string" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a q encoded string and decode it" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should decode q encoded =5F as underscore" do
      string = "=?UTF-8?Q?This_=C2=AD_and=5Fthat?="
      result = "This ­ and_that"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should not fold a long string that has no spaces" do
      original = "ВосстановлениеВосстановлениеВашегопароля"
      if RUBY_VERSION >= '1.9'
        original.force_encoding('UTF-8')
        result = "Subject: =?UTF-8?Q?=D0=92=D0=BE=D1=81=D1=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5=D0=92=D0=BE=D1=81=D1=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5=D0=92=D0=B0=D1=88=D0=B5=D0=B3=D0=BE=D0=BF=D0=B0=D1=80=D0=BE=D0=BB=D1=8F?=\r\n"
      else
        result = "Subject: =?UTF-8?Q?=D0=92=D0=BE=D1=81=D1=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5=D0=92=D0=BE=D1=81=D1=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5=D0=92=D0=B0=D1=88=D0=B5=D0=B3=D0=BE=D0=BF=D0=B0=D1=80=D0=BE=D0=BB=D1=8F?=\r\n"
      end
      mail = Mail.new
      mail.subject = original
      mail[:subject].decoded.should eq original
      mail[:subject].encoded.should eq result
    end

    it "should round trip a complex string properly" do
      original = "ВосстановлениеВосстановлениеВашегопароля This is a NUT?????Z__string that== could (break) anything"
      if RUBY_VERSION >= '1.9'
        original.force_encoding('UTF-8')
      end
      result = "Subject: =?UTF-8?Q?=D0=92=D0=BE=D1=81=D1=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5=D0=92=D0=BE=D1=81=D1=81=D1=82=D0=B0=D0=BD=D0=BE=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5=D0=92=D0=B0=D1=88=D0=B5=D0=B3=D0=BE=D0=BF=D0=B0=D1=80=D0=BE=D0=BB=D1=8F?=\r\n =?UTF-8?Q?_This_is_a_NUT=3F=3F=3F=3F=3FZ=5F=5Fstring_that=3D=3D_could?=\r\n =?UTF-8?Q?_=28break=29_anything?=\r\n"
      mail = Mail.new
      mail.subject = original
      mail[:subject].decoded.should eq original
      mail[:subject].encoded.should eq result
      mail = Mail.new(mail.encoded)
      mail[:subject].decoded.should eq original
      mail[:subject].encoded.should eq result
      mail = Mail.new(mail.encoded)
      mail[:subject].decoded.should eq original
      mail[:subject].encoded.should eq result
    end

    it "should round trip another complex string (koi-8)" do
      original = "Слово 9999 и число"
      mail = Mail.new
      mail.subject = (RUBY_VERSION >= "1.9" ? original.encode('koi8-r') : Iconv.conv('koi8-r', 'UTF-8', original))
      mail[:subject].charset = 'koi8-r'
      wrapped = mail[:subject].wrapped_value
      unwrapped = Mail::Encodings.value_decode(wrapped)
      unwrapped.gsub("Subject: ", "").should eq original
    end
  end

  describe "mixed Q and B encodings" do
    it "should decode an encoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?= =?UTF-8?Q?_This_was_=E3=81=82_string?='
      result = "This is あ string This was あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
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

    before(:each) do
      Mail.defaults do
        param_encode_language('en')
      end
    end

    it "should leave an unencoded string alone" do
      string = "this isn't encoded"
      result = "this isn't encoded"
      Mail::Encodings.param_decode(string, 'us-ascii').should eq result
    end

    it "should unencode an encoded string" do
      string = "This%20is%20even%20more%20"
      result = "This is even more "
      result.force_encoding('us-ascii') if RUBY_VERSION >= '1.9'
      Mail::Encodings.param_decode(string, 'us-ascii').should eq result
    end

    it "should unencoded an encoded string and return the right charset on 1.9" do
      string = "This%20is%20even%20more%20"
      result = "This is even more "
      result.force_encoding('us-ascii') if RUBY_VERSION >= '1.9'
      Mail::Encodings.param_decode(string, 'us-ascii').should eq result
    end

    it "should unencode a complete string that included unencoded parts" do
      string = "This%20is%20even%20more%20%2A%2A%2Afun%2A%2A%2A%20isn't it"
      result = "This is even more ***fun*** isn't it"
      result.force_encoding('iso-8859-1') if RUBY_VERSION >= '1.9'
      Mail::Encodings.param_decode(string, 'iso-8859-1').should eq result
    end

    it "should encode a string" do
      string = "This is  あ string"
      if RUBY_VERSION >= '1.9'
        Mail::Encodings.param_encode(string).should eq "utf-8'en'This%20is%20%20%E3%81%82%20string"
      else
        Mail::Encodings.param_encode(string).should eq "utf8'en'This%20is%20%20%E3%81%82%20string"
      end
    end

    it "should just quote US-ASCII with spaces" do
      string = "This is even more"
      if RUBY_VERSION >= '1.9'
        Mail::Encodings.param_encode(string).should eq '"This is even more"'
      else
        Mail::Encodings.param_encode(string).should eq '"This is even more"'
      end
    end

    it "should leave US-ASCII without spaces alone" do
      string = "fun"
      if RUBY_VERSION >= '1.9'
        Mail::Encodings.param_encode(string).should eq 'fun'
      else
        Mail::Encodings.param_encode(string).should eq 'fun'
      end
    end

  end

  describe "decoding a string and detecting the encoding type" do

    it "should detect an encoded Base64 string to the decoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a multiple encoded Base64 string to the decoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?==?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      result = "This is あ stringThis is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a multiple encoded Base64 string with a space to the decoded string" do
      string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?= =?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
      result = "This is あ stringThis is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a multiple encoded Base64 string with a whitespace to the decoded string" do
      string = "=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?= \r\n\s=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?="
      result = "This is あ stringThis is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should decode B and Q encodings together if needed" do
      string = "=?UTF-8?Q?This_is_=E3=81=82_string?==?UTF-8?Q?This_is_=E3=81=82_string?= Some non encoded stuff =?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?= \r\n\sMore non encoded stuff"
      result = "This is あ stringThis is あ string Some non encoded stuff This is あ string \r\n\sMore non encoded stuff"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a encoded and unencoded Base64 string to the decoded string" do
      string = "Some non encoded stuff =?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?= \r\n\sMore non encoded stuff"
      result = "Some non encoded stuff This is あ string \r\n\sMore non encoded stuff"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect an encoded QP string to the decoded string" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should decode UTF-16 encoded string" do
      string = "=?UTF-16?Q?0B0D0F0H0J=?="
      result = "あいうえお"
      Mail::Encodings.value_decode(string).should == result
    end

    it "should decode UTF-32 encoded string" do
      string = "=?UTF-32?Q?=00=000B=00=000D=00=000F=00=000H=00=000J=?="
      result = "あいうえお"
      Mail::Encodings.value_decode(string).should == result
    end

    it "should detect multiple encoded QP string to the decoded string" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?==?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ stringThis is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect multiple encoded QP string with a space to the decoded string" do
      string = '=?UTF-8?Q?This_is_=E3=81=82_string?= =?UTF-8?Q?This_is_=E3=81=82_string?='
      result = "This is あ stringThis is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect multiple encoded QP string with a space to the decoded string" do
      string = "=?UTF-8?Q?This_is_=E3=81=82_string?= \r\n\s=?UTF-8?Q?This_is_=E3=81=82_string?="
      result = "This is あ stringThis is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a encoded and unencoded QP string to the decoded string" do
      string = "Some non encoded stuff =?UTF-8?Q?This_is_=E3=81=82_string?= \r\n\sMore non encoded stuff"
      result = "Some non encoded stuff This is あ string \r\n\sMore non encoded stuff"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should detect a plain string and return it" do
      string = 'This is あ string'
      result = "This is あ string"
      result.force_encoding('UTF-8') if RUBY_VERSION >= '1.9'
      Mail::Encodings.value_decode(string).should eq result
    end

    it "should handle a very long string efficiently" do
      string = "This is a string " * 10000
      Mail::Encodings.value_decode(string).should eq string
    end

    it "should handle Base64 encoded ISO-2022-JP string" do
      pending
      string = "ISO-2022-JP =?iso-2022-jp?B?GyRCJCQkPSRLITwkXiRrJEskSyE8JDgkJyQkJFQhPBsoQg==?="
      result = "ISO-2022-JP いそにーまるににーじぇいぴー"
      Mail::Encodings.value_decode(string).should eq result
    end
  end

  describe "altering an encoded text to decoded and visa versa" do

    describe "decoding" do

      before(:each) do
        @original = $KCODE if RUBY_VERSION < '1.9'
      end

      after(:each) do
        $KCODE = @original if RUBY_VERSION < '1.9'
      end

      it "should detect an encoded Base64 string and return the decoded string" do
        string = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
        result = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :decode).should eq result
      end

      it "should detect an encoded QP string and return the decoded string" do
        string = '=?UTF-8?Q?This_is_=E3=81=82_string?='
        result = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :decode).should eq result
      end

      it "should detect an a string is already decoded and leave it alone" do
        string = 'This is あ string'
        result = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :decode).should eq result
      end

    end

    describe "encoding" do

      it "should encode a string into Base64" do
        string = "This is あ string"
        if RUBY_VERSION >= '1.9'
          result = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
          result.force_encoding('UTF-8')
        else
          result = '=?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?='
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :encode).should eq result
      end

      it "should leave a string that doesn't need encoding alone" do
        string = 'This is a string'
        result = "This is a string"
        if RUBY_VERSION >= '1.9'
          result.force_encoding('UTF-8')
        else
          $KCODE = 'UTF-8'
        end
        Mail::Encodings.decode_encode(string, :encode).should eq result
      end

    end

    describe "unquote and convert to" do
      it "should unquote quoted printable and convert to utf-8" do
        a ="=?ISO-8859-1?Q?[166417]_Bekr=E6ftelse_fra_Rejsefeber?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "[166417] Bekr\303\246ftelse fra Rejsefeber"
      end

      it "should unquote base64 and convert to utf-8" do
        a ="=?ISO-8859-1?B?WzE2NjQxN10gQmVrcuZmdGVsc2UgZnJhIFJlanNlZmViZXI=?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "[166417] Bekr\303\246ftelse fra Rejsefeber"
      end

      it "should handle no charset" do
        a ="[166417]_Bekr=E6ftelse_fra_Rejsefeber"
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "[166417]_Bekr=E6ftelse_fra_Rejsefeber"
      end

      it "should unquote multiple lines" do
        a ="=?utf-8?q?Re=3A_=5B12=5D_=23137=3A_Inkonsistente_verwendung_von_=22Hin?==?utf-8?b?enVmw7xnZW4i?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "Re: [12] #137: Inkonsistente verwendung von \"Hinzuf\303\274gen\""
      end

      it "should unquote a string in the middle of the text" do
        a ="Re: Photos =?ISO-8859-1?Q?Brosch=FCre_Rand?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "Re: Photos Brosch\303\274re Rand"
      end

      it "should unquote and change to an ISO encoding if we really want" do
        a = "=?ISO-8859-1?Q?Brosch=FCre_Rand?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'iso-8859-1')
        expected = "Brosch\374re Rand"
        expected.force_encoding('iso-8859-1') if expected.respond_to?(:force_encoding)
        b.should eq expected
      end

      it "should unquote Shift_JIS QP with trailing =" do
        a = "=?Shift_JIS?Q?=93=FA=96{=8C=EA=?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "日本語"
      end

      it "handles Windows 1252 QP encoding" do
        # TODO: JRuby 1.7.0 has an encoding issue https://jira.codehaus.org/browse/JRUBY-6999
        pending if defined?(JRUBY_VERSION) && JRUBY_VERSION >= '1.7.0'

        a = "=?WINDOWS-1252?Q?simple_=96_dash_=96_?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "simple – dash – "
      end

      it "should unquote multiple strings in the middle of the text" do
        a = "=?Shift_JIS?Q?=93=FA=96{=8C=EA=?= <a@example.com>, =?Shift_JIS?Q?=93=FA=96{=8C=EA=?= <b@example.com>"
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "日本語 <a@example.com>, 日本語 <b@example.com>"
      end

      it "should handle multiline quoted headers with mixed content" do
        a = "=?iso-2022-jp?B?GyRCP3AwQxsoQg==?=2=?iso-2022-jp?B?GyRCIiobKEI=?= =?iso-2022-jp?B?GyRCOkc2YUxnPj4kcj5+JGsySCQsJFskSCRzJEk4K0V2GyhC?= =?iso-2022-jp?B?GyRCJD8kaSRKJCQhKjxkJDckJCQzJEgkRyQ5JE0hI0Z8GyhC?= =?iso-2022-jp?B?GyRCS1wkTiQkJCQkSCQzJG0hIiRvJFMkNSRTJE5AJDMmGyhC?= =?iso-2022-jp?B?GyRCJCw8OiRvJGwkRCREJCIkazg9Ol8hIiRKJHMkSCQrGyhC?= =?iso-2022-jp?B?GyRCOGVAJCRLO0QkNSRNJFAhIkxeQk4kSiQkISokSCReGyhC?= =?iso-2022-jp?B?GyRCJF4kTztXJCYkTiRAISMbKEI=?="
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "瑞庵2→最近門松を飾る家がほとんど見当たらない！寂しいことですね。日本のいいところ、わびさびの世界が失われつつある現在、なんとか後世に残さねば、勿体ない！とままは思うのだ。"
      end

      it "should handle quoted string with mixed content that have a plain string at the end" do
        a = 'Der Kunde ist K=?utf-8?B?w7Y=?=nig'
        b = Mail::Encodings.unquote_and_convert_to(a, 'utf-8')
        b.should eq "Der Kunde ist König"
      end

    end
  end

  describe "quoted printable encoding and decoding" do
    it "should handle underscores in the text" do
      expected = 'something_with_underscores'
      Mail::Encodings.get_encoding(:quoted_printable).encode(expected).unpack("M").first.should eq expected
    end

    it "should handle underscores in the text" do
      expected = 'something with_underscores'
      Mail::Encodings.get_encoding(:quoted_printable).encode(expected).unpack("M").first.should eq expected
    end

    it "should keep the underscores in the text" do
      expected = 'something_with_underscores'
      encoded = Mail::Encodings.get_encoding(:quoted_printable).encode(expected)
      Mail::Encodings.get_encoding(:quoted_printable).decode(encoded).should eq expected
    end

    it "should handle a new line in the text" do
      if RUBY_VERSION >= '1.9'
        expected = "\nRe: ol\341".force_encoding('ISO-8859-1').encode('utf-8')
      else
        expected = Iconv.conv("UTF-8", "ISO-8859-1", "\nRe: ol\341")
      end
      encoded = "=?ISO-8859-1?Q?\nRe=3A_ol=E1?="
      Mail::Encodings.value_decode(encoded).should eq expected
    end

  end

  describe "pre encoding non usascii text" do
    it "should not change an ascii string" do
      raw     = 'mikel@test.lindsaar.net'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq raw
    end

    it "should encode a display that contains non usascii" do
      raw     = 'Lindsああr <mikel@test.lindsaar.net>'
      encoded = '=?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode a single token that contains non usascii" do
      raw     = '<mikelああ@test.lindsaar.net>'
      encoded = Mail::Encodings.encode_non_usascii(raw, 'utf-8')
      Mail::Encodings.value_decode(encoded).should eq raw
    end

    it "should encode a display that contains non usascii with quotes as no quotes" do
      raw     = '"Lindsああr" <mikel@test.lindsaar.net>'
      encoded = '=?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode a display name with us-ascii and non-usascii parts" do
      raw     = 'Mikel Lindsああr <mikel@test.lindsaar.net>'
      encoded = 'Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode a display name with us-ascii and non-usascii parts ignoring quotes" do
      raw     = '"Mikel Lindsああr" <mikel@test.lindsaar.net>'
      encoded = '=?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode a quoted display name with us-ascii and non-usascii that ends with a non-usascii part" do
      raw     = '"Marc André" <marc@test.lindsaar.net>'
      encoded = '=?UTF-8?B?TWFyYyBBbmRyw6k=?= <marc@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode multiple addresses correctly" do
      raw     = '"Mikel Lindsああr" <mikel@test.lindsaar.net>, "あdあ" <ada@test.lindsaar.net>'
      encoded = '=?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode multiple unquoted addresses correctly" do
      raw     = 'Mikel Lindsああr <mikel@test.lindsaar.net>, あdあ <ada@test.lindsaar.net>'
      encoded = 'Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should encode multiple un bracketed addresses and groups correctly" do
      raw     = '"Mikel Lindsああr" test1@lindsaar.net, group: "あdあ" test2@lindsaar.net, me@lindsaar.net;'
      encoded = '=?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= test1@lindsaar.net, group: =?UTF-8?B?44GCZOOBgg==?= test2@lindsaar.net, me@lindsaar.net;'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end

    it "should correctly match and encode non-usascii letters at the end of a quoted string" do
      raw = '"Felix Baarß" <test@example.com>'
      encoded = '=?UTF-8?B?RmVsaXggQmFhcsOf?= <test@example.com>'
      Mail::Encodings.encode_non_usascii(raw, 'utf-8').should eq encoded
    end
  end

  describe "address encoding" do
    it "should not do anything to a plain address" do
      raw     = 'mikel@test.lindsaar.net'
      encoded = 'mikel@test.lindsaar.net'
      Mail::Encodings.address_encode(raw, 'utf-8').should eq encoded
    end

    it "should encode an address correctly" do
      raw     = '"Mikel Lindsああr" <mikel@test.lindsaar.net>'
      encoded = '=?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>'
      Mail::Encodings.address_encode(raw, 'utf-8').should eq encoded
    end

    it "should encode multiple addresses correctly" do
      raw     = ['"Mikel Lindsああr" <mikel@test.lindsaar.net>', '"あdあ" <ada@test.lindsaar.net>']
      encoded = '=?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>'
      Mail::Encodings.address_encode(raw, 'utf-8').should eq encoded
    end

    it "should handle a single ascii address correctly from a string" do
      raw     = ['"Mikel Lindsaar" <mikel@test.lindsaar.net>']
      encoded = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
      Mail::Encodings.address_encode(raw, 'utf-8').should eq encoded
    end

    it "should handle multiple ascii addresses correctly from a string" do
      raw     = 'Mikel Lindsaar <mikel@test.lindsaar.net>, Ada <ada@test.lindsaar.net>'
      encoded = 'Mikel Lindsaar <mikel@test.lindsaar.net>, Ada <ada@test.lindsaar.net>'
      Mail::Encodings.address_encode(raw, 'utf-8').should eq encoded
    end

    it "should handle ascii addresses correctly as an array" do
      raw     = ['Mikel Lindsaar <mikel@test.lindsaar.net>', 'Ada <ada@test.lindsaar.net>']
      encoded = 'Mikel Lindsaar <mikel@test.lindsaar.net>, Ada <ada@test.lindsaar.net>'
      Mail::Encodings.address_encode(raw, 'utf-8').should eq encoded
    end

    it "should ignore single nil" do
      Mail::Encodings.address_encode(nil, 'utf-8').should eq nil
    end

    it "should ignore nil in arrays" do
      Mail::Encodings.address_encode(["aa@bb.com", nil], 'utf-8').should eq "aa@bb.com"
    end
  end

end
