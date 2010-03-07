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
      mail.charset = 'iso-8559-1'
      mail.subject = "This is あ string"
      mail[:subject].encoded.should == "Subject: =?ISO-8559-1?B?VGhpcyBpcyDjgYIgc3RyaW5n?=\r\n"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'iso-8559-1'
      mail.to = "Mikel Lindsああr <mikel@test.lindsaar.net>"
      mail[:to].encoded.should == "To: =?ISO-8559-1?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      mail = Mail.new
      mail.charset = 'iso-8559-1'
      mail.to = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      mail[:to].encoded.should == "To: =?ISO-8559-1?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\t=?ISO-8559-1?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      mail.charset = 'iso-8559-1'
      ['To', 'From', 'Cc', 'Reply-To'].each do |field|
        mail.send("#{field.downcase.gsub("-", '_')}=", ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"])
        mail[field].encoded.should == "#{field}: =?ISO-8559-1?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\t=?ISO-8559-1?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      end
    end
  end

end