# encoding: utf-8
require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mail::CommonField do

  describe "multi-charset support" do
    it "should leave ascii alone" do
      field = Mail::SubjectField.new("Subject", "This is a test")
      field.encoded.should == "Subject: This is a test\r\n"
    end
    
    if RUBY_VERSION < '1.9'
    
      it "should encode a utf-8 string as utf-8 quoted printable" do
        $KCODE = 'u'
        value = "かきくけこ"
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?UTF8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end

      it "should encode a SJIS string as SJIS quoted printable" do
        $KCODE = 's'
        value = "かきくけこ"
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?SJIS?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end

      it "should wrap an encoded string if it is more than 10 characters" do
        $KCODE = 's'
        value = "かきくけこ かきくけこ かきくけこ"
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?SJIS?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93=20=E3=81=8B?=\r\n\t=?SJIS?Q?=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\t=?SJIS?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
    
    else
    
      it "should encode a utf-8 string as utf-8 quoted printable" do
        value = "かきくけこ"
        value = value.force_encoding('UTF-8')
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
      
      it "should encode a iso-8559 string as iso-8559 quoted printable" do
        value = "かきくけこ"
        value = value.force_encoding('ISO-8859-1')
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?ISO-8859-1?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
    
    end
    
  end

end
