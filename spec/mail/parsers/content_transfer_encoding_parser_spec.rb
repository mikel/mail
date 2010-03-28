# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/rfc2822_obsolete'))
Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/rfc2822'))
Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/content_transfer_encoding'))

describe "ContentTransferEncodingParser" do
  it "should work" do
    text = "quoted-printable"
    a = Mail::ContentTransferEncodingParser.new
    a.parse(text).should_not be_nil
    a.parse(text).encoding.text_value.should == 'quoted-printable'
  end
  
  it "should parse a content transfer encoding that has a trailing semi colon" do
    text = "quoted-printable;"
    a = Mail::ContentTransferEncodingParser.new
    a.parse(text).should_not be_nil
    a.parse(text).encoding.text_value.should == 'quoted-printable'
  end
  
  it "should parse a content transfer encoding that has a trailing semi colon with pre white space" do
    text = 'quoted-printable  ;'
    a = Mail::ContentTransferEncodingParser.new
    a.parse(text).should_not be_nil
    a.parse(text).encoding.text_value.should == 'quoted-printable'
  end
  
  it "should parse a content transfer encoding that has a trailing semi colon with trailing white space" do
    text = 'quoted-printable; '
    a = Mail::ContentTransferEncodingParser.new
    a.parse(text).should_not be_nil
    a.parse(text).encoding.text_value.should == 'quoted-printable'
  end
  
  it "should parse a content transfer encoding that has a trailing semi colon with pre and trailing white space" do
    text = 'quoted-printable  ;  '
    a = Mail::ContentTransferEncodingParser.new
    a.parse(text).should_not be_nil
    a.parse(text).encoding.text_value.should == 'quoted-printable'
  end
  
end