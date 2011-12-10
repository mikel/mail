# encoding: utf-8
require 'spec_helper'

describe "Round Tripping" do

  it "should round trip a basic email" do
    mail = Mail.new('Subject: FooBar')
    mail.body "This is Text"
    parsed_mail = Mail.new(mail.to_s)
    parsed_mail.subject.to_s.should eql "FooBar"
    parsed_mail.body.to_s.should eql "This is Text"
  end

  it "should round trip a html multipart email" do
    mail = Mail.new('Subject: FooBar')
    mail.text_part = Mail::Part.new do
      body "This is Text"
    end
    mail.html_part = Mail::Part.new do
      content_type = "text/html; charset=US-ASCII"
      body "<b>This is HTML</b>"
    end
    parsed_mail = Mail.new(mail.to_s)
    parsed_mail.mime_type.should eql 'multipart/alternative'
    parsed_mail.boundary.should eql mail.boundary
    parsed_mail.parts.length.should eql 2
    parsed_mail.parts[0].body.to_s.should eql "This is Text"
    parsed_mail.parts[1].body.to_s.should eql "<b>This is HTML</b>"
  end

  it "should round trip an email" do
    initial = Mail.new do
      to        "mikel@test.lindsaar.net"
      subject   "testing round tripping"
      body      "Really testing round tripping."
      from      "system@test.lindsaar.net"
      cc        "nobody@test.lindsaar.net"
      bcc       "bob@test.lindsaar.net"
      date      Time.local(2009, 11, 6)
    end
    Mail.new(initial.encoded).encoded.should eql initial.encoded
  end

end
