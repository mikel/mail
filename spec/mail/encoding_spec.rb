# encoding: utf-8 
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'spec_helper')

describe "mail encoding" do

  it "should allow you to assign a mail wide charset" do
    mail = Mail.new
    mail.charset = 'utf-8'
    mail.charset.should == 'utf-8'
  end
  
  describe "using default encoding" do
    it "should allow you to send in unencoded strings to fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.subject = "This is あ string"
      mail[:subject].encoded.should == "Subject: =?UTF-8?B?VGhpcyBpcyDjgYIgc3RyaW5n?=\r\n"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = "Mikel Lindsああr <mikel@test.lindsaar.net>"
      mail[:to].encoded.should == "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = "あdあ <ada@test.lindsaar.net>"
      mail[:to].encoded.should == "To: =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'utf-8'
      mail.to = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      mail[:to].encoded.should == "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\t=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      mail.charset = 'utf-8'
      ['To', 'From', 'Cc', 'Reply-To'].each do |field|
        mail.send("#{field.downcase.gsub("-", '_')}=", ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"])
        mail[field].encoded.should == "#{field}: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\t=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
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
      string = "Subject: =?ISO-8859-1?B?VGhpcyBpcyDjgYIgc3RyaW5n?=\r\n"
      if RUBY_VERSION > '1.9'
        string.force_encoding('ISO8859-1')
        result.force_encoding('ISO8859-1')
      end
      result.should == string
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      string = "Mikel Lindsああr <mikel@test.lindsaar.net>"
      string.force_encoding('ISO8859-1') if RUBY_VERSION > '1.9'
      mail.to = string
      result = mail[:to].encoded
      string = "To: =?ISO-8859-1?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
      if RUBY_VERSION > '1.9'
        string.force_encoding('ISO8859-1')
        result.force_encoding('ISO8859-1')
      end
      result.should == string
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'ISO-8859-1'
      array = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      array.map! { |a| a.force_encoding('ISO8859-1') } if RUBY_VERSION > '1.9'
      mail.to = array
      result = mail[:to].encoded
      string = "To: =?ISO-8859-1?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\t=?ISO-8859-1?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      if RUBY_VERSION > '1.9'
        string.force_encoding('ISO8859-1')
        result.force_encoding('ISO8859-1')
      end
      result.should == string
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      array = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      array.map! { |a| a.force_encoding('ISO8859-1') } if RUBY_VERSION > '1.9'
      mail.charset = 'ISO-8859-1'
      ['To', 'From', 'Cc', 'Reply-To'].each do |field|
        mail.send("#{field.downcase.gsub("-", '_')}=", array)
        string = "#{field}: =?ISO-8859-1?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\t=?ISO-8859-1?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
        result = mail[field].encoded
        if RUBY_VERSION > '1.9'
          string.force_encoding('ISO8859-1')
          result.force_encoding('ISO8859-1')
        end
        result.should == string
      end
    end
  end

end