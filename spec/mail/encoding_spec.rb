# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe "mail encoding" do

  it "should allow you to assign an email-wide charset" do
    mail = Mail.new
    mail.charset = 'utf-8'
    expect(mail.charset).to eq 'utf-8'
  end

  describe "using default encoding" do
    it "should allow you to send in unencoded strings to fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.subject = "This is あ string"
      result = "Subject: =?UTF-8?Q?This_is_=E3=81=82_string?=\r\n"
      expect(mail[:subject].encoded).to eq result
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = "Mikel Lindsああr <mikel@test.lindsaar.net>"
      result = "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = "あdあ <ada@test.lindsaar.net>"
      result = "To: =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      result = "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should allow you to send unquoted non us-ascii strings, with spaces in them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = ["Foo áëô îü <extended@example.net>"]
      result = "To: =?UTF-8?B?Rm9vIMOhw6vDtCDDrsO8?= <extended@example.net>\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      mail.charset = 'utf-8'
      ['To', 'From', 'Cc', 'Reply-To'].each do |field|
        mail.send("#{field.downcase.gsub("-", '_')}=", ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"])
        result = "#{field}: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
        expect(mail[field].encoded).to eq result
      end
    end

    it "should handle groups" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = "test1@lindsaar.net, group: test2@lindsaar.net, me@lindsaar.net;"
      result = "To: test1@lindsaar.net, \r\n\sgroup: test2@lindsaar.net, \r\n\sme@lindsaar.net;\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should handle groups with funky characters" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = '"Mikel Lindsああr" <test1@lindsaar.net>, group: "あdあ" <test2@lindsaar.net>, me@lindsaar.net;'
      result = "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <test1@lindsaar.net>, \r\n\sgroup: =?UTF-8?B?44GCZOOBgg==?= <test2@lindsaar.net>, \r\n\sme@lindsaar.net;\r\n"
      expect(mail[:to].encoded).to eq result
    end

    describe "quoting token safe chars" do

      it "should not quote the display name if unquoted" do
        mail = Mail.new
        mail.charset = 'utf-8'
        mail.to = 'Mikel Lindsaar <mikel@test.lindsaar.net>'
        expect(mail[:to].encoded).to eq %{To: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n}
      end

      it "should not quote the display name if already quoted" do
        mail = Mail.new
        mail.charset = 'utf-8'
        mail.to = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
        expect(mail[:to].encoded).to eq %{To: Mikel Lindsaar <mikel@test.lindsaar.net>\r\n}
      end

    end

    describe "quoting token unsafe chars" do
      it "should quote the display name" do
        mail = Mail.new
        mail.charset = 'utf-8'
        mail.to = "Mikel @ me Lindsaar <mikel@test.lindsaar.net>"
        expect(mail[:to].encoded).to eq %{To: "Mikel @ me Lindsaar" <mikel@test.lindsaar.net>\r\n}
      end

      it "should preserve quotes needed from the user and not double quote" do
        mail = Mail.new
        mail.charset = 'utf-8'
        mail.to = %{"Mikel @ me Lindsaar" <mikel@test.lindsaar.net>}
        expect(mail[:to].encoded).to eq %{To: "Mikel @ me Lindsaar" <mikel@test.lindsaar.net>\r\n}
      end
    end
  end

  describe "specifying an email-wide encoding" do
    it "should allow you to send in unencoded strings to fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      subject = "This is \xE4 string"
      subject = subject.dup.force_encoding('ISO8859-1')
      mail.subject = subject
      result = mail[:subject].encoded
      if result.respond_to?(:force_encoding)
        expect(result.encoding).to eq Encoding::UTF_8
      end
      expect(result).to eq "Subject: =?ISO-8859-1?Q?This_is_=E4_string?=\r\n"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'

      string = "Mikel Linds\xE4r <mikel@test.lindsaar.net>"
      string = string.dup.force_encoding('ISO8859-1')
      mail.to = string

      result = mail[:to].encoded
      if result.respond_to?(:force_encoding)
        expect(result.encoding).to eq Encoding::UTF_8
      end
      expect(result).to eq "To: Mikel =?ISO-8859-1?B?TGluZHPkcg==?= <mikel@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      array = ["Mikel Linds\xE4r <mikel@test.lindsaar.net>", "\xE4d <ada@test.lindsaar.net>"]
      array.map! { |a| a.dup.force_encoding('ISO8859-1') }
      mail.to = array
      result = mail[:to].encoded
      if result.respond_to?(:force_encoding)
        expect(result.encoding).to eq Encoding::UTF_8
      end
      expect(result).to eq "To: Mikel =?ISO-8859-1?B?TGluZHPkcg==?= <mikel@test.lindsaar.net>, \r\n =?ISO-8859-1?B?5GQ=?= <ada@test.lindsaar.net>\r\n"
    end

    %w[ To From Cc Reply-To ].each do |field|
      array = ["Mikel Linds\xE4r <mikel@test.lindsaar.net>", "\xE4d <ada@test.lindsaar.net>"]
      array.map! { |a| a.dup.force_encoding('ISO-8859-1') }

      it "allows multiple unencoded strings in #{field}" do
        mail = Mail.new
        mail.charset = 'ISO-8859-1'

        mail.send("#{Mail::Utilities.underscoreize(field)}=", array)
        expect(mail[field].errors).to eq []

        result = mail[field].encoded
        expect(result.encoding).to eq Encoding::UTF_8 if result.respond_to?(:force_encoding)
        expect(result).to eq "#{field}: Mikel =?ISO-8859-1?B?TGluZHPkcg==?= <mikel@test.lindsaar.net>, \r\n\s=?ISO-8859-1?B?5GQ=?= <ada@test.lindsaar.net>\r\n"
      end
    end
  end

  it "should let you define a charset per part" do
    mail = Mail.new
    part = Mail::Part.new
    part.content_type = "text/html"
    part.charset = "ISO-8859-1"
    part.body = "blah"
    mail.add_part(part)
    expect(mail.parts[0].content_type).to eq "text/html; charset=ISO-8859-1"
  end

  it "should replace invalid characters" do
    m = Mail.new
    m['Subject'] = Mail::SubjectField.new("=?utf-8?Q?Hello_=96_World?=")
    replace = '�'
    expect(m.subject).to eq "Hello #{replace} World"
  end

  it "should replace characters of unknown and invalid encoding" do
    m = Mail.new
    m['Subject'] = Mail::SubjectField.new("Hello=?UNKNOWN?B?4g==?=")
    replace = '�'
    expect(m.subject).to eq "Hello#{replace}"
  end

  describe "#pick_encoding" do
    it "picks binary for nil" do
      expect { ::Encoding.find(nil) }.to raise_error(TypeError)
      expect(Mail::Ruby19.pick_encoding(nil)).to eq(Encoding::BINARY)
    end

    {
      "latin2" => Encoding::ISO_8859_2,
      "ISO_8859-1" => Encoding::ISO_8859_1,
      "cp-850" => Encoding::CP850,
      "" => Encoding::BINARY
    }.each do |from, to|
      it "should support #{from}" do
        expect { ::Encoding.find(from) }.to raise_error(ArgumentError)
        expect(Mail::Ruby19.pick_encoding(from)).to eq(to)
      end
    end
  end
end
