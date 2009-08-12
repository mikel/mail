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

  end

  describe "encoding" do

    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      body.encoded.should == 'this is some text'
    end

  end

end