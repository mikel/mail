# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::UnstructuredField do

  describe "initialization" do

    it "should be instantiated" do
      expect {Mail::UnstructuredField.new("Name", "Value")}.not_to raise_error
    end

  end

  describe "manipulation" do

    before(:each) do
      @field = Mail::UnstructuredField.new("Subject", "Hello Frank")
    end

    it "should allow us to set a text value at initialization" do
      expect {Mail::UnstructuredField.new("Subject", "Value")}.not_to raise_error
    end

    it "should provide access to the text of the field once set" do
      expect(@field.value).to eq "Hello Frank"
    end

    it "should provide a means to change the value" do
      @field.value = "Goodbye Frank"
      expect(@field.value).to eq "Goodbye Frank"
    end
  end

  describe "displaying encoded field and decoded value" do

    before(:each) do
      @field = Mail::UnstructuredField.new("Subject", "Hello Frank")
    end

    it "should provide a to_s function that returns the field name and value" do
      expect(@field.value).to eq "Hello Frank"
    end

    it "should return '' on to_s if there is no value" do
      @field.value = nil
      expect(@field.to_s).to eq ''
    end

    it "should give an encoded value ready to insert into an email" do
      expect(@field.encoded).to eq "Subject: Hello Frank\r\n"
    end

    it "should return nil on encoded if it has no value" do
      @field.value = nil
      expect(@field.encoded).to eq ''
    end

    it "should handle array" do
      @field = Mail::UnstructuredField.new("To", ['mikel@example.com', 'bob@example.com'])
      expect(@field.encoded).to eq "To: mikel@example.com, bob@example.com\r\n"
    end

    it "should handle string" do
      @field.value = 'test'
      expect(@field.encoded).to eq "Subject: test\r\n"
    end

    it "should give an decoded value ready to insert into an email" do
      expect(@field.decoded).to eq "Hello Frank"
    end

    it "should return a nil on decoded if it has no value" do
      @field.value = nil
      expect(@field.decoded).to eq nil
    end

    it "should just add the CRLF at the end of the line" do
      @field = Mail::SubjectField.new("=?utf-8?Q?testing_testing_=D6=A4?=")
      result = "Subject: =?UTF-8?Q?testing_testing_=D6=A4?=\r\n"
      expect(@field.encoded).to eq result
      expect(@field.decoded).to eq "testing testing \326\244"
    end

    it "should do encoded-words encoding correctly without extra equal sign" do
      @field = Mail::SubjectField.new("testing testing æøå")
      result = "Subject: =?UTF-8?Q?testing_testing_=C3=A6=C3=B8=C3=A5?=\r\n"
      expect(@field.encoded).to eq result
      expect(@field.decoded).to eq "testing testing æøå"
    end

    it "should encode the space between two adjacent encoded-words" do
      @field = Mail::SubjectField.new("Her er æ ø å")
      result = "Subject: =?UTF-8?Q?Her_er_=C3=A6_=C3=B8_=C3=A5?=\r\n"
      expect(@field.encoded).to eq result
      expect(@field.decoded).to eq "Her er æ ø å"
    end

    it "should encode additional special characters inside encoded-word-encoded strings" do
      string = %Q(Her er æ()<>@,;:\\"/[]?.=)
      @field = Mail::SubjectField.new(string)
      result = %Q(Subject: =?UTF-8?Q?Her_er_=C3=A6=28=29<>@,;:\\=22/[]=3F.=3D?=\r\n)
      expect(@field.encoded).to eq result
      expect(@field.decoded).to eq string
    end

    it "should decode a utf-7(B) encoded unstructured field" do
      string = "=?UTF-7?B?JkFPUS0mLSZBT1EtJi0mQU9RLQ==?="
      @field = Mail::UnstructuredField.new("References", string)
      expect(@field.decoded).to eq 'ä&ä&ä'
    end

    if !'1.9'.respond_to?(:force_encoding)
      it "shouldn't get fooled into encoding on 1.8 due to an unrelated Encoding constant" do
        begin
          Mail::UnstructuredField::Encoding = 'derp'
          expect(@field.encoded).to eq "Subject: Hello Frank\r\n"
        ensure
          Mail::UnstructuredField.send :remove_const, :Encoding
        end
      end
    end
  end

  describe "folding" do

    it "should not fold itself if it is 78 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is _exactly_ 78 characters....")
      expect(@field.encoded).to eq "Subject: This is a subject header message that is _exactly_ 78 characters....\r\n"
    end

    it "should fold itself if it is 79 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is absolutely 79 characters long")
      result = "Subject: This is a subject header message that is absolutely 79 characters\r\n\slong\r\n"
      expect(@field.encoded).to eq result
    end

    it "should fold itself if it is 997 chracters long" do
      @field = Mail::UnstructuredField.new("Subject", "This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. This is a subject header message that is going to be 997 characters long. And this makes it 997....")
      lines = @field.encoded.split("\r\n\s")
      lines.each { |line| expect(line.length).to be < 78 }
    end

    it "should fold itself if it is 998 characters long" do
      value = "This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. This is a subject header message that is going to be 998 characters long. And this makes it 998 long"
      @field = Mail::UnstructuredField.new("Subject", value)
      lines = @field.encoded.split("\r\n\s")
      lines.each { |line| expect(line.length).to be < 78 }
    end

    it "should fold itself if it is 999 characters long" do
      value = "This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. This is a subject header message that is going to be 999 characters long. And this makes it 999 long."
      @field = Mail::UnstructuredField.new("Subject", value)
      lines = @field.encoded.split("\r\n\s")
      lines.each { |line| expect(line.length).to be < 78 }
    end

    it "should fold itself if it is non us-ascii" do
      @original = $KCODE if RUBY_VERSION < '1.9'
      string = "This is あ really long string This is あ really long string This is あ really long string This is あ really long string This is あ really long string"
      @field = Mail::UnstructuredField.new("Subject", string)
      if string.respond_to?(:force_encoding)
        string = string.dup.force_encoding('UTF-8')
      else
        $KCODE = 'u'
      end
      result = "Subject: =?UTF-8?Q?This_is_=E3=81=82_really_long_string_This_is_=E3=81=82?=\r\n\s=?UTF-8?Q?_really_long_string_This_is_=E3=81=82_really_long_string_This_is?=\r\n\s=?UTF-8?Q?_=E3=81=82_really_long_string_This_is_=E3=81=82_really_long?=\r\n\s=?UTF-8?Q?_string?=\r\n"
      expect(@field.encoded).to eq result
      expect(@field.decoded).to eq string
      $KCODE = @original if RUBY_VERSION < '1.9'
    end

    it "should fold properly with my actual complicated header" do
      @original = $KCODE if RUBY_VERSION < '1.9'
      string = %|{"unique_args": {"mailing_id":147,"account_id":2}, "to": ["larspind@gmail.com"], "category": "mailing", "filters": {"domainkeys": {"settings": {"domain":1,"enable":1}}}, "sub": {"{{open_image_url}}": ["http://betaling.larspind.local/O/token/147/Mailing::FakeRecipient"], "{{name}}": ["[FIRST NAME]"], "{{signup_reminder}}": ["(her kommer til at stå hvornår folk har skrevet sig op ...)"], "{{unsubscribe_url}}": ["http://betaling.larspind.local/U/token/147/Mailing::FakeRecipient"], "{{email}}": ["larspind@gmail.com"], "{{link:308}}": ["http://betaling.larspind.local/L/308/0/Mailing::FakeRecipient"], "{{confirm_url}}": [""], "{{ref}}": ["[REF]"]}}|
      @field = Mail::UnstructuredField.new("X-SMTPAPI", string)
      if string.respond_to?(:force_encoding)
        string = string.dup.force_encoding('UTF-8')
      else
        $KCODE = 'u'
      end
      result = "X-SMTPAPI: =?UTF-8?Q?{=22unique=5Fargs=22:_{=22mailing=5Fid=22:147,=22a?=\r\n =?UTF-8?Q?ccount=5Fid=22:2},_=22to=22:_[=22larspind@gmail.com=22],_=22categ?=\r\n =?UTF-8?Q?ory=22:_=22mailing=22,_=22filters=22:_{=22domainkeys=22:_{=22sett?=\r\n =?UTF-8?Q?ings=22:_{=22domain=22:1,=22enable=22:1}}},_=22sub=22:_{=22{{op?=\r\n =?UTF-8?Q?en=5Fimage=5Furl}}=22:_[=22http://betaling.larspind.local/O?=\r\n =?UTF-8?Q?/token/147/Mailing::FakeRecipient=22],_=22{{name}}=22:_[=22[FIRST?=\r\n =?UTF-8?Q?_NAME]=22],_=22{{signup=5Freminder}}=22:_[=22=28her_kommer_til_at?=\r\n =?UTF-8?Q?_st=C3=A5_hvorn=C3=A5r_folk_har_skrevet_sig_op_...=29=22],?=\r\n =?UTF-8?Q?_=22{{unsubscribe=5Furl}}=22:_[=22http://betaling.larspind.?=\r\n =?UTF-8?Q?local/U/token/147/Mailing::FakeRecipient=22],_=22{{email}}=22:?=\r\n =?UTF-8?Q?_[=22larspind@gmail.com=22],_=22{{link:308}}=22:_[=22http://beta?=\r\n =?UTF-8?Q?ling.larspind.local/L/308/0/Mailing::FakeRecipient=22],_=22{{con?=\r\n =?UTF-8?Q?firm=5Furl}}=22:_[=22=22],_=22{{ref}}=22:_[=22[REF]=22]}}?=\r\n"
      expect(@field.encoded).to eq result
      expect(@field.decoded).to eq string
      $KCODE = @original if RUBY_VERSION < '1.9'
    end

    it "should fold properly with continuous spaces around the linebreak" do
      @field = Mail::UnstructuredField.new("Subject", "This is a header that has continuous spaces around line break point,     which should be folded properly")
      result = "Subject: This is a header that has continuous spaces around line break point,\s\r\n\s\s\s\swhich should be folded properly\r\n"
      expect(@field.encoded).to eq result
    end

  end

  describe "encoding non QP safe chars" do
    it "should encode an ascii string that has carriage returns if asked to" do
      result = "Subject: =0Aasdf=0A\r\n"
      @field = Mail::UnstructuredField.new("Subject", "\nasdf\n")
      expect(@field.encoded).to eq result
    end
  end

  describe "iso-2022-jp Subject" do
    it "should encoded with ISO-2022-JP encoding" do
      @field = Mail::UnstructuredField.new("Subject", "あいうえお")
      @field.charset = 'iso-2022-jp'
      expect = (RUBY_VERSION < '1.9') ? "Subject: =?ISO-2022-JP?Q?=E3=81=82=E3=81=84=E3=81=86=E3=81=88=E3=81=8A?=\r\n" : "Subject: =?ISO-2022-JP?Q?=1B$B$=22$$$&$=28$*=1B=28B?=\r\n"
      expect(@field.encoded).to eq expect
    end
  end
end
