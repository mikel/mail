# encoding: utf-8
require 'spec_helper'

describe "mail encoding" do

  it "should allow you to assign a mail wide charset" do
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
      result = "To: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
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
      result = "To: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should allow you to send unquoted non us-ascii strings, with spaces in them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = ["Foo áëô îü <extended@example.net>"]
      result = "To: Foo =?UTF-8?B?w6HDq8O0?= =?UTF-8?B?IMOuw7w=?= <extended@example.net>\r\n"
      expect(mail[:to].encoded).to eq result
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      mail.charset = 'utf-8'
      ['To', 'From', 'Cc', 'Reply-To'].each do |field|
        mail.send("#{field.downcase.gsub("-", '_')}=", ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"])
        result = "#{field}: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
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
        skip
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

  describe "specifying an email wide encoding" do
    it "should allow you to send in unencoded strings to fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      subject = "This is あ string"
      subject.force_encoding('ISO8859-1') if RUBY_VERSION > '1.9'
      mail.subject = subject
      result = mail[:subject].encoded
      string = "Subject: =?ISO-8859-1?Q?This_is_=E3=81=82_string?=\r\n"
      if RUBY_VERSION > '1.9'
        string.force_encoding('ISO8859-1')
        result.force_encoding('ISO8859-1')
      end
      expect(result).to eq string
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      string = "Mikel Lindsああr <mikel@test.lindsaar.net>"
      string.force_encoding('ISO8859-1') if RUBY_VERSION > '1.9'
      mail.to = string
      result = mail[:to].encoded
      string = "To: Mikel =?ISO-8859-1?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
      if RUBY_VERSION > '1.9'
        string.force_encoding('ISO8859-1')
        result.force_encoding('ISO8859-1')
      end
      expect(result).to eq string
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      array = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      array.map! { |a| a.force_encoding('ISO8859-1') } if RUBY_VERSION > '1.9'
      mail.to = array
      result = mail[:to].encoded
      string = "To: Mikel =?ISO-8859-1?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?ISO-8859-1?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      if RUBY_VERSION > '1.9'
        string.force_encoding('ISO8859-1')
        result.force_encoding('ISO8859-1')
      end
      expect(result).to eq string
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      array = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      array.map! { |a| a.force_encoding('ISO8859-1') } if RUBY_VERSION > '1.9'
      mail.charset = 'ISO-8859-1'
      ['To', 'From', 'Cc', 'Reply-To'].each do |field|
        mail.send("#{field.downcase.gsub("-", '_')}=", array)
        string = "#{field}: Mikel =?ISO-8859-1?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?ISO-8859-1?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
        result = mail[field].encoded
        if RUBY_VERSION > '1.9'
          string.force_encoding('ISO8859-1')
          result.force_encoding('ISO8859-1')
        end
        expect(result).to eq string
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

  it "should skip invalid characters" do
    m = Mail.new
    m['Subject'] = Mail::SubjectField.new("=?utf-8?Q?Hello_=96_World?=")
    if RUBY_VERSION > '1.9'
      expect { expect(m.subject).to be_valid_encoding }.not_to raise_error
    else
      expect(m.subject).to eq "Hello  World"
    end
  end
end
