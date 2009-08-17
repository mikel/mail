# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Body do

  # 3.5 Overall message syntax
  #
  # A message consists of header fields, optionally followed by a message
  # body.  Lines in a message MUST be a maximum of 998 characters
  # excluding the CRLF, but it is RECOMMENDED that lines be limited to 78
  # characters excluding the CRLF.  (See section 2.1.1 for explanation.)
  # In a message body, though all of the characters listed in the text
  # rule MAY be used, the use of US-ASCII control characters (values 1
  # through 8, 11, 12, and 14 through 31) is discouraged since their
  # interpretation by receivers for display is not guaranteed.
  #
  #  message         =       (fields / obs-fields)
  #                          [CRLF body]
  #
  #  body            =       *(*998text CRLF) *998text
  #
  # The header fields carry most of the semantic information and are
  # defined in section 3.6.  The body is simply a series of lines of text
  # which are uninterpreted for the purposes of this standard.
  #
  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Body.new}.should_not raise_error
    end
    
    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      body.to_s.should == 'this is some text'
    end
    
    it "should accept nil as a value and return an empty body" do
      body = Mail::Body.new
      body.to_s.should == ''
    end

  end

  describe "encoding" do

    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      body.encoded.should == 'this is some text'
    end

  end

  describe "splitting up a multipart document" do
    it "should respond to split" do
      body = Mail::Body.new('this is some text')
      body.should respond_to(:split)
    end

    it "should split at the boundry string given returning two message bodies" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split('------=_Part_2192_32400445').length.should == 2
    end

    it "should keep the preamble text as it's own preamble" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split('------=_Part_2192_32400445')
      body.preamble.should == "this is some text\r\n"
    end
    
    it "should return the parts as their own messages" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split('------=_Part_2192_32400445')[0].class.should == Mail::Message
      body.split('------=_Part_2192_32400445')[1].class.should == Mail::Message
    end
    
    it "should return the first part as it's own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split('------=_Part_2192_32400445')[0].content_type.content_type.should == "text/plain"
    end
    
    it "should return the first part as it's own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split('------=_Part_2192_32400445')[1].content_type.content_type.should == "text/html"
    end
  end

  describe "detecting non ascii" do
    it "should say an empty string is all ascii" do
      body = Mail::Body.new
      body.should be_only_us_ascii
    end

    it "should say if a body is ascii" do
      body = Mail::Body.new('This is ASCII')
      body.should be_only_us_ascii
    end

    it "should say if a body is not ascii" do
      body = Mail::Body.new("This is NOT plain text ASCII　− かきくけこ")
      body.should_not be_only_us_ascii
    end
  end

end