# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'
require 'mail/fields/common_field'

describe Mail::CommonField do

  describe "multi-charset support" do

    it "should return '' on to_s if there is no value" do
      expect(Mail::SubjectField.new(nil).to_s).to eq ''
    end

    it "should leave ascii alone" do
      field = Mail::SubjectField.new("This is a test")
      expect(field.encoded).to eq "Subject: This is a test\r\n"
      expect(field.decoded).to eq "This is a test"
    end

    it "should encode a utf-8 string as utf-8 quoted printable" do
      value = "かきくけこ"
      value = value.dup.force_encoding('UTF-8')
      result = "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
      field = Mail::SubjectField.new(value)
      expect(field.encoded).to eq result
      expect(field.decoded).to eq value
      expect(field.value).to eq value
    end

    it "should wrap an encoded at 60 characters" do
      value = "かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ"
      value = value.dup.force_encoding('UTF-8')
      result = "Subject: =?UTF-8?Q?=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n\s=?UTF-8?Q?_=E3=81=8B=E3=81=8D=E3=81=8F=E3=81=91=E3=81=93?=\r\n"
      field = Mail::SubjectField.new(value)
      expect(field.encoded).to eq result
      expect(field.decoded).to eq value
      expect(field.value).to eq value
    end

    it "should handle charsets in assigned addresses" do
      value = '"かきくけこ" <mikel@test.lindsaar.net>'
      value = value.dup.force_encoding('UTF-8')
      result = "From: =?UTF-8?B?44GL44GN44GP44GR44GT?= <mikel@test.lindsaar.net>\r\n"
      field = Mail::FromField.new(value)
      expect(field.encoded).to eq result
      expect(field.decoded).to eq value
    end

  end

  describe "with content that looks like the field name" do
    it "does not strip from start" do
      field = Mail::SubjectField.new("Subject: for your approval")
      expect(field.decoded).to eq("Subject: for your approval")
    end

    it "does not strip from middle" do
      field = Mail::SubjectField.new("for your approval subject: xyz")
      expect(field.decoded).to eq("for your approval subject: xyz")
    end
  end
end
