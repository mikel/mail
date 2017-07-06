# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe "Round Tripping" do

  it "should round trip a basic email" do
    mail = Mail.new('Subject: FooBar')
    mail.body "This is Text"
    parsed_mail = Mail.new(mail.to_s)
    expect(parsed_mail.subject.to_s).to eq "FooBar"
    expect(parsed_mail.body.to_s).to eq "This is Text"
  end

  it "should round trip a html multipart email" do
    mail = Mail.new('Subject: FooBar')
    mail.text_part = Mail::Part.new do
      body "This is Text"
    end
    mail.html_part = Mail::Part.new do
      content_type "text/html; charset=US-ASCII"
      body "<b>This is HTML</b>"
    end
    parsed_mail = Mail.new(mail.to_s)
    expect(parsed_mail.mime_type).to eq 'multipart/alternative'
    expect(parsed_mail.boundary).to eq mail.boundary
    expect(parsed_mail.parts.length).to eq 2
    expect(parsed_mail.parts[0].body.to_s).to eq "This is Text"
    expect(parsed_mail.parts[1].body.to_s).to eq "<b>This is HTML</b>"
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
      add_file  :filename => "foo.txt", :content => "I have \ntwo lines\n\n"
    end
    expect(Mail.new(initial.encoded).encoded).to eq initial.encoded
  end

  it "preserves text attachment newlines" do
    body = "I have \r\ntwo lines\n\r"
    initial = Mail.new
    initial.add_file :filename => "foo.txt", :content => body
    expect(Mail.new(initial.encoded).attachments.first.decoded).to eq ::Mail::Utilities.binary_unsafe_to_lf(body)
  end
end
