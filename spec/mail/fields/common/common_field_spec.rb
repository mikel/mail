# encoding: utf-8
require 'spec_helper'

describe Mail::CommonField do

  describe "multi-charset support" do
    
    before(:each) do
      @original = $KCODE if RUBY_VERSION < '1.9'
    end

    after(:each) do
      $KCODE = @original if RUBY_VERSION < '1.9'
    end
    
    it "should leave ascii alone" do
      field = Mail::SubjectField.new("This is a test")
      field.encoded.should eq "Subject: This is a test\r\n"
      field.decoded.should eq "This is a test"
    end
    
    it "should encode a utf-8 string as utf-8 quoted printable" do
      value = "かきくけこ"
      if RUBY_VERSION < '1.9'
        $KCODE = 'u'
        result = "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
      else
        value.force_encoding('UTF-8')
        result = "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
      end
      field = Mail::SubjectField.new(value)
      field.encoded.should eq result
      field.decoded.should eq value
      field.value.should eq value
    end

    it "should wrap an encoded at 60 characters" do
      value = "かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ"
      if RUBY_VERSION < '1.9'
        $KCODE = 'u'
        result = "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
      else
        value.force_encoding('UTF-8')
        result = "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
      end
      field = Mail::SubjectField.new(value)
      field.encoded.should eq result
      field.decoded.should eq value
      field.value.should eq value
    end
  
    it "should handle charsets in assigned addresses" do
      value = '"かきくけこ" <mikel@test.lindsaar.net>'
      if RUBY_VERSION < '1.9'
        $KCODE = 'u'
        result = "From: =?UTF-8?B?44GL44GN44GP44GR44GT?= <mikel@test.lindsaar.net>\r\n"
      else
        value.force_encoding('UTF-8')
        result = "From: =?UTF-8?B?44GL44GN44GP44GR44GT?= <mikel@test.lindsaar.net>\r\n"
      end
      field = Mail::FromField.new(value)
      field.encoded.should eq result
      field.decoded.should eq value
    end
    
  end

end
