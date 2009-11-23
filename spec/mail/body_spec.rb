# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

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
    
    it "should set it's own encoding to us_ascii if it is ascii only body" do
      body = Mail::Body.new('This is some text')
      body.charset.should == 'US-ASCII'
    end
    
    it "should allow you to set it's encoding" do
      body = Mail::Body.new('')
      body.charset = 'UTF-8'
      body.charset.should == 'UTF-8'
    end

    it "should allow you to specify an encoding" do
      body = Mail::Body.new('')
      body.encoding = 'base64'
      body.encoding.should == 'base64'
    end
    
    it "should convert all new lines to crlf" do
      body = Mail::Body.new("This has \n various \r new \r\n lines")
      body.encoded.should == "This has \r\n various \r\n new \r\n lines"
    end

  end

  describe "decoding" do
    
    it "should convert all new lines to crlf" do
      body = Mail::Body.new("This has \n various \r new \r\n lines")
      body.decoded.should == "This has \n various \n new \n lines"
    end
    
    it "should not change a body on decode if not given an encoding type to decode" do
      body = Mail::Body.new("The=3Dbody")
      body.decoded.should == "The=3Dbody"
    end

    it "should change return the raw text if it does not recognise the encoding" do
      body = Mail::Body.new("The=3Dbody")
      body.encoding = '7bit'
      body.decoded.should == "The=3Dbody"
    end

    it "should change a body on decode if given an encoding type to decode" do
      body = Mail::Body.new("The=3Dbody")
      body.encoding = 'quoted-printable'
      body.decoded.should == "The=body"
    end

    it "should change a body on decode if given an encoding type to decode" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      body.decoded.should == "The body"
    end

  end

  describe "splitting up a multipart document" do
    
    it "should store the boundary passed in" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.boundary.should == '----=_Part_2192_32400445'
    end

    it "should split at the boundry string given returning two message bodies" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445').parts.length.should == 2
    end

    it "should keep the preamble text as it's own preamble" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.preamble.should == "this is some text"
    end
    
    it "should return the parts as their own messages" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts[0].class.should == Mail::Part
      body.parts[1].class.should == Mail::Part
    end
    
    it "should return the first part as it's own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts[0].content_type.content_type.should == "text/plain"
    end
    
    it "should return the first part as it's own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts[1].content_type.content_type.should == "text/html"
    end

    it "should separate out it's parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.should be_multipart
    end

    it "should keep track of it's parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts.length.should == 2
    end

    it "should round trip it's parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.preamble = "Really! this is some text"
      body.epilogue = "And this is the end"
      new_body = Mail::Body.new(body.to_s)
      new_body.split!('----=_Part_2192_32400445')
      new_body.parts.length.should == 2
      new_body.preamble.should == "Really! this is some text"
      new_body.epilogue.should == "And this is the end"
    end

    it "should allow you to change the boundary" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.boundary = '------=_MIMEPART'
      new_body = Mail::Body.new(body.to_s)
      new_body.split!('------=_MIMEPART')
      new_body.parts.length.should == 2
      new_body.preamble.should == "this is some text"
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

  describe "adding parts" do
    it "should allow you to add a part" do
      body = Mail::Body.new('')
      body << Mail::Part.new('')
      body.parts.length.should == 1
      body.should be_multipart
    end
  end

  describe "matching" do
    it "should still equal itself" do
      body = Mail::Body.new('The body')
      body.should == body
    end

    it "should match on the body part decoded if given a string to ==" do
      body = Mail::Body.new('The body')
      (body == 'The body').should be_true
    end

    it "should match on the body part decoded if given a string to ==" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      (body == "The body").should be_true
    end

  end

end