# encoding: utf-8
require 'spec_helper'

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
      doing { Mail::Body.new }.should_not raise_error
    end

    it "should initialize on a nil value" do
      doing { Mail::Body.new(nil) }.should_not raise_error
    end

    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      body.to_s.should eq 'this is some text'
    end

    it "should accept nil as a value and return an empty body" do
      body = Mail::Body.new
      body.to_s.should eq ''
    end

    it "should accept an array as the body and join it" do
      doing { Mail::Body.new(["line one\n", "line two\n"]) }.should_not raise_error
    end

    it "should accept an array as the body and join it" do
      body = Mail::Body.new(["line one\n", "line two\n"])
      body.encoded.should eq "line one\r\nline two\r\n"
    end

  end

  describe "encoding" do

    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      body.encoded.should eq 'this is some text'
    end

    it "should set it's own encoding to us_ascii if it is ascii only body" do
      body = Mail::Body.new('This is some text')
      body.charset.should eq 'US-ASCII'
    end

    it "should allow you to set it's encoding" do
      body = Mail::Body.new('')
      body.charset = 'UTF-8'
      body.charset.should eq 'UTF-8'
    end

    it "should allow you to specify an encoding" do
      body = Mail::Body.new('')
      body.encoding = 'base64'
      body.encoding.should eq 'base64'
    end

    it "should convert all new lines to crlf" do
      body = Mail::Body.new("This has \n various \r new \r\n lines")
      body.encoded.should eq "This has \r\n various \r\n new \r\n lines"
    end

  end

  describe "decoding" do

    it "should convert all new lines to crlf" do
      body = Mail::Body.new("This has \n various \r new \r\n lines")
      body.decoded.should eq "This has \n various \n new \n lines"
    end

    it "should not change a body on decode if not given an encoding type to decode" do
      body = Mail::Body.new("The=3Dbody")
      body.decoded.should eq "The=3Dbody"
    end

    it "should change return the raw text if it does not recognise the encoding" do
      body = Mail::Body.new("The=3Dbody")
      body.encoding = '7bit'
      body.decoded.should eq "The=3Dbody"
    end

    it "should change a body on decode if given an encoding type to decode" do
      body = Mail::Body.new("The=3Dbody")
      body.encoding = 'quoted-printable'
      body.decoded.should eq "The=body"
    end

    it "should change a body on decode if given an encoding type to decode" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      body.decoded.should eq "The body"
    end

  end

  describe "splitting up a multipart document" do

    it "should store the boundary passed in" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.boundary.should eq '----=_Part_2192_32400445'
    end

    it "should split at the boundry string given returning two message bodies" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445').parts.length.should eq 2
    end

    it "should keep the preamble text as it's own preamble" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.preamble.should eq "this is some text"
    end

    it "should return the parts as their own messages" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts[0].class.should eq Mail::Part
      body.parts[1].class.should eq Mail::Part
    end

    it "should return the first part as it's own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts[0].content_type.should eq "text/plain; charset=ISO-8859-1"
    end

    it "should return the first part as it's own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.parts[1].content_type.should eq "text/html"
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
      body.parts.length.should eq 2
    end

    it "should round trip it's parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.preamble = "Really! this is some text"
      body.epilogue = "And this is the end"
      new_body = Mail::Body.new(body.encoded)
      new_body.split!('----=_Part_2192_32400445')
      new_body.parts.length.should eq 2
      new_body.preamble.should eq "Really! this is some text"
      new_body.epilogue.should eq "And this is the end"
    end

    it "should allow you to change the boundary" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\nn------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.boundary = '------=_MIMEPART'
      new_body = Mail::Body.new(body.encoded)
      new_body.split!('------=_MIMEPART')
      new_body.parts.length.should eq 2
      new_body.preamble.should eq "this is some text"
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
      body.parts.length.should eq 1
      body.should be_multipart
    end

    it "should allow you to sort the parts" do
      body = Mail::Body.new('')
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched")
      body.parts.length.should eq 3
      body.should be_multipart
      body.sort_parts!
      body.parts[0].content_type.should eq "text/plain"
      body.parts[1].content_type.should eq "text/enriched"
      body.parts[2].content_type.should eq "text/html"
    end

    it "should allow you to sort the parts with an arbitrary sort order" do
      body = Mail::Body.new('')
      body.set_sort_order([ "text/plain", "text/html", "text/enriched" ])
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched")
      body.parts.length.should eq 3
      body.should be_multipart
      body.sort_parts!
      body.parts[0].content_type.should eq "text/plain"
      body.parts[1].content_type.should eq "text/html"
      body.parts[2].content_type.should eq "text/enriched"
    end

    it "should allow you to sort the parts with an arbitrary sort order" do
      body = Mail::Body.new('')
      body.set_sort_order(["application/x-yaml", "text/plain"])
      body << Mail::Part.new("content-type: text/plain\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/html\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: application/x-yaml\r\nsubject: Enriched")
      body.parts.length.should eq 3
      body.should be_multipart
      body.sort_parts!
      body.parts[0].content_type.should eq "application/x-yaml"
      body.parts[1].content_type.should eq "text/plain"
      body.parts[2].content_type.should eq "text/html"
    end

    it "should sort the parts on encode" do
      body = Mail::Body.new('')
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched")
      body.parts.length.should eq 3
      body.should be_multipart
      body.encoded
      body.parts[0].content_type.should eq "text/plain"
      body.parts[1].content_type.should eq "text/enriched"
      body.parts[2].content_type.should eq "text/html"
    end

    it "should put the part types it doesn't know about at the end" do
      body = Mail::Body.new('')
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: image/jpeg\r\n")
      body.parts.length.should eq 3
      body.should be_multipart
      body.encoded
      body.parts[0].content_type.should eq "text/plain"
      body.parts[1].content_type.should eq "text/html"
      body.parts[2].content_type.should eq "image/jpeg"
    end

    it "should allow you to sort the parts recursively" do
      part = Mail::Part.new('Content-Type: multipart/alternate')
      part.add_part(Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text"))
      part.add_part(Mail::Part.new("content-type: text/html\r\nsubject: HTML"))
      part.add_part(Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched"))
      body = Mail::Body.new('')
      body << part
      body << Mail::Part.new("content-type: image/jpeg\r\nsubject: JPGEG\r\n\r\nsdkjskjdksjdkjsd")
      body.parts.length.should eq 2
      body.should be_multipart
      body.sort_parts!
      body.parts[0].content_type.should match %r{\Amultipart/alternate(;|\Z)}
      body.parts[1].content_type.should eq "image/jpeg"
      body.parts[0].parts[0].content_type.should eq "text/plain"
      body.parts[0].parts[1].content_type.should eq "text/enriched"
      body.parts[0].parts[2].content_type.should eq "text/html"
    end

    it "should allow you to sort the parts recursively" do
      part = Mail::Part.new('Content-Type: multipart/alternate')
      part.add_part(Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched"))
      part.add_part(Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text"))
      part.add_part(Mail::Part.new("content-type: text/html\r\nsubject: HTML"))
      body = Mail::Body.new('')
      body << part
      body << Mail::Part.new("content-type: image/jpeg\r\nsubject: JPGEG\r\n\r\nsdkjskjdksjdkjsd")
      body.parts.length.should eq 2
      body.should be_multipart
      body.sort_parts!
      body.parts[0].content_type.should match %r{\Amultipart/alternate(;|\Z)}
      body.parts[1].content_type.should eq "image/jpeg"
      body.parts[0].parts[0].content_type.should eq "text/plain"
      body.parts[0].parts[1].content_type.should eq "text/enriched"
      body.parts[0].parts[2].content_type.should eq "text/html"
    end

  end

  describe "matching" do

    it "should still equal itself" do
      body = Mail::Body.new('The body')
      body.should eq body
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

    it "should match on the body part decoded if given a string to =~" do
      body = Mail::Body.new('The body')
      (body =~ /The/).should eq 0
    end

    it "should match on the body part decoded if given a string to ==" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      (body =~ /The/).should eq 0
    end

    it "should match on the body part decoded if given a string to match" do
      body = Mail::Body.new('The body')
      (body.match(/The/))[0].should eq 'The'
    end

    it "should match on the body part decoded if given a string to match" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      (body.match(/The/))[0].should eq 'The'
    end

    it "should match on the body part decoded if given a string to include?" do
      body = Mail::Body.new('The Body')
      body.should include('The')
    end

    it "should match on the body part decoded if given a string to include?" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      body.should include('The')
    end
  end

  describe "non US-ASCII charset" do
    it "should encoded" do
      body = Mail::Body.new("あいうえお\n")
      body.charset = 'iso-2022-jp'
      expect = (RUBY_VERSION < '1.9') ? "あいうえお\r\n" : "\e$B$\"$$$&$($*\e(B\r\n"
      body.encoded.should eq expect
    end
  end
end
