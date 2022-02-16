# encoding: utf-8
# frozen_string_literal: true
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
      expect { Mail::Body.new }.not_to raise_error
    end

    it "should initialize on a nil value" do
      expect { Mail::Body.new(nil) }.not_to raise_error
    end

    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      expect(body.to_s).to eq 'this is some text'
    end

    it "should accept nil as a value and return an empty body" do
      body = Mail::Body.new
      expect(body.to_s).to eq ''
    end

    it "should accept an array as the body and join it" do
      expect { Mail::Body.new(["line one\n", "line two\n"]) }.not_to raise_error
    end

    it "should accept an array as the body and join it" do
      body = Mail::Body.new(["line one\n", "line two\n"])
      expect(body.encoded).to eq "line one\r\nline two\r\n"
    end

  end

  describe "encoding" do

    it "should accept text as raw source data" do
      body = Mail::Body.new('this is some text')
      expect(body.encoded).to eq 'this is some text'
    end

    it "should set its own encoding to us_ascii if it is ascii only body" do
      body = Mail::Body.new('This is some text')
      expect(body.charset).to eq 'US-ASCII'
    end

    it "should allow you to set its encoding" do
      body = Mail::Body.new('')
      body.charset = 'UTF-8'
      expect(body.charset).to eq 'UTF-8'
    end

    it "should allow you to specify an encoding" do
      body = Mail::Body.new('')
      body.encoding = 'base64'
      expect(body.encoding).to eq 'base64'
    end

    it "should convert all new lines to crlf" do
      body = Mail::Body.new("This has \n various \r new \r\n lines")
      expect(body.encoded).to eq "This has \r\n various \r\n new \r\n lines"
    end

  end

  describe "decoding" do

    it "should convert all new lines to crlf" do
      body = Mail::Body.new("This has \n various \r new \r\n lines")
      expect(body.decoded).to eq "This has \n various \n new \n lines"
    end

    it "should not change a body on decode if not given an encoding type to decode" do
      body = Mail::Body.new("The=3Dbody")
      expect(body.decoded).to eq "The=3Dbody"
    end

    it "should change return the raw text if it does not recognise the encoding" do
      body = Mail::Body.new("The=3Dbody")
      body.encoding = '7bit'
      expect(body.decoded).to eq "The=3Dbody"
    end

    it "should change a body on decode if given an encoding type to decode" do
      body = Mail::Body.new("The=3Dbody")
      body.encoding = 'quoted-printable'
      expect(body.decoded).to eq "The=body"
    end

    it "should change a body on decode if given an encoding type to decode" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      expect(body.decoded).to eq "The body"
    end

  end

  describe "splitting up a multipart document" do
    def assert_split_into(body, pre, epi, parts)
      body = Mail::Body.new(body)
      body.split!('----=_Part_2192_32400445')
      expect(body.parts.size).to eq parts
      expect(body.preamble).to eq pre
      expect(body.epilogue).to eq epi
    end

    it "should store the boundary passed in" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body.boundary).to eq '----=_Part_2192_32400445'
    end

    it "should split at the boundry string given returning two message bodies" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      expect(body.split!('----=_Part_2192_32400445').parts.length).to eq 2
    end

    it "should split with missing closing boundary" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain\r\n\r\nWhere is the closing boundary...\r\n"
      assert_split_into(multipart_body, "this is some text", "", 1)
    end

    it "should not split with empty space after missing closing boundary" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain\r\n\r\nWhere is the closing boundary...\r\n------=_Part_2192_32400445\r\n\r\n\r\n\r\n"
      assert_split_into(multipart_body, "this is some text", "", 1)
    end

    it "should split with multiple parts and missing closing boundary" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain\r\n\r\nExtra part 1\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain\r\n\r\nWhere is the closing boundary...\r\n"
      assert_split_into(multipart_body, "this is some text", "", 2)
    end

    it "should ignore blank parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\n\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain\r\n\r\nWhere is the closing boundary...\r\n"
      assert_split_into(multipart_body, "this is some text", "", 1)
    end

    it "should keep the preamble text as its own preamble" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body.preamble).to eq "this is some text"
    end

    it "should return the parts as their own messages" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body.parts[0].class).to eq Mail::Part
      expect(body.parts[1].class).to eq Mail::Part
    end

    it "should return the first part as its own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body.parts[0].content_type).to eq "text/plain; charset=ISO-8859-1"
    end

    it "should return the first part as its own message" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body.parts[1].content_type).to eq "text/html"
    end

    it "should separate out its parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body).to be_multipart
    end

    it "should keep track of its parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      expect(body.parts.length).to eq 2
    end

    it "should round trip its parts" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.preamble = "Really! this is some text"
      body.epilogue = "And this is the end"
      new_body = Mail::Body.new(body.encoded)
      new_body.split!('----=_Part_2192_32400445')
      expect(new_body.parts.length).to eq 2
      expect(new_body.parts[0].decoded).to eq "This is a plain text\n"
      expect(new_body.parts[1].decoded).to eq "<p>This is HTML</p>"
      expect(new_body.preamble).to eq "Really! this is some text"
      expect(new_body.epilogue).to eq "And this is the end"
    end

    it "should allow you to change the boundary" do
      multipart_body = "this is some text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/plain; charset=ISO-8859-1\r\n\r\nThis is a plain text\r\n\r\n------=_Part_2192_32400445\r\nContent-Type: text/html\r\n\r\n<p>This is HTML</p>\r\n------=_Part_2192_32400445--\r\n"
      body = Mail::Body.new(multipart_body)
      body.split!('----=_Part_2192_32400445')
      body.boundary = '------=_MIMEPART'
      new_body = Mail::Body.new(body.encoded)
      new_body.split!('------=_MIMEPART')
      expect(new_body.parts.length).to eq 2
      expect(new_body.preamble).to eq "this is some text"
    end

    it "should split if boundary is not set" do
      multipart_body = "\n\n--\nDate: Thu, 01 Aug 2013 15:14:20 +0100\nMime-Version: 1.0\nContent-Type: text/plain\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment;\n filename=\"\"\nContent-ID: <51fa6d3cac796_d84e3fe5a58349e025683@local.mail>\n\n\n\n----"
      body = Mail::Body.new(multipart_body)
      expect { body.split!(nil) }.not_to raise_error
    end

  end

  describe "detecting non ascii" do
    it "should say an empty string is all ascii" do
      body = Mail::Body.new
      expect(body).to be_ascii_only
    end

    it "should say if a body is ascii" do
      body = Mail::Body.new('This is ASCII')
      expect(body).to be_ascii_only
    end

    it "should say if a body is not ascii" do
      body = Mail::Body.new("This is NOT plain text ASCII　− かきくけこ")
      expect(body).not_to be_ascii_only
    end
  end

  describe "adding parts" do
    it "should allow you to add a part" do
      body = Mail::Body.new('')
      body << Mail::Part.new('')
      expect(body.parts.length).to eq 1
      expect(body).to be_multipart
    end

    it "should allow you to sort the parts" do
      body = Mail::Body.new('')
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched")
      expect(body.parts.length).to eq 3
      expect(body).to be_multipart
      body.sort_parts!
      expect(body.parts[0].content_type).to eq "text/plain"
      expect(body.parts[1].content_type).to eq "text/enriched"
      expect(body.parts[2].content_type).to eq "text/html"
    end

    it "should allow you to sort the parts with an arbitrary sort order" do
      body = Mail::Body.new('')
      body.set_sort_order([ "text/plain", "text/html", "text/enriched" ])
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched")
      expect(body.parts.length).to eq 3
      expect(body).to be_multipart
      body.sort_parts!
      expect(body.parts[0].content_type).to eq "text/plain"
      expect(body.parts[1].content_type).to eq "text/html"
      expect(body.parts[2].content_type).to eq "text/enriched"
    end

    it "should allow you to sort the parts with an arbitrary sort order" do
      body = Mail::Body.new('')
      body.set_sort_order(["application/x-yaml", "text/plain"])
      body << Mail::Part.new("content-type: text/plain\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/html\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: application/x-yaml\r\nsubject: Enriched")
      expect(body.parts.length).to eq 3
      expect(body).to be_multipart
      body.sort_parts!
      expect(body.parts[0].content_type).to eq "application/x-yaml"
      expect(body.parts[1].content_type).to eq "text/plain"
      expect(body.parts[2].content_type).to eq "text/html"
    end

    it "should sort the parts on encode" do
      body = Mail::Body.new('')
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched")
      expect(body.parts.length).to eq 3
      expect(body).to be_multipart
      body.encoded
      expect(body.parts[0].content_type).to eq "text/plain"
      expect(body.parts[1].content_type).to eq "text/enriched"
      expect(body.parts[2].content_type).to eq "text/html"
    end

    it "should put the part types it doesn't know about at the end" do
      body = Mail::Body.new('')
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text")
      body << Mail::Part.new("content-type: image/jpeg\r\n")
      expect(body.parts.length).to eq 3
      expect(body).to be_multipart
      body.encoded
      expect(body.parts[0].content_type).to eq "text/plain"
      expect(body.parts[1].content_type).to eq "text/html"
      expect(body.parts[2].content_type).to eq "image/jpeg"
    end

    it "should allow you to sort the parts recursively" do
      part = Mail::Part.new('Content-Type: multipart/alternate')
      part.add_part(Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text"))
      part.add_part(Mail::Part.new("content-type: text/html\r\nsubject: HTML"))
      part.add_part(Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched"))
      body = Mail::Body.new('')
      body << part
      body << Mail::Part.new("content-type: image/jpeg\r\nsubject: JPGEG\r\n\r\nsdkjskjdksjdkjsd")
      expect(body.parts.length).to eq 2
      expect(body).to be_multipart
      body.sort_parts!
      expect(body.parts[0].content_type).to match %r{\Amultipart/alternate(;|\Z)}
      expect(body.parts[1].content_type).to eq "image/jpeg"
      expect(body.parts[0].parts[0].content_type).to eq "text/plain"
      expect(body.parts[0].parts[1].content_type).to eq "text/enriched"
      expect(body.parts[0].parts[2].content_type).to eq "text/html"
    end

    it "should allow you to sort the parts recursively" do
      part = Mail::Part.new('Content-Type: multipart/alternate')
      part.add_part(Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched"))
      part.add_part(Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text"))
      part.add_part(Mail::Part.new("content-type: text/html\r\nsubject: HTML"))
      body = Mail::Body.new('')
      body << part
      body << Mail::Part.new("content-type: image/jpeg\r\nsubject: JPGEG\r\n\r\nsdkjskjdksjdkjsd")
      expect(body.parts.length).to eq 2
      expect(body).to be_multipart
      body.sort_parts!
      expect(body.parts[0].content_type).to match %r{\Amultipart/alternate(;|\Z)}
      expect(body.parts[1].content_type).to eq "image/jpeg"
      expect(body.parts[0].parts[0].content_type).to eq "text/plain"
      expect(body.parts[0].parts[1].content_type).to eq "text/enriched"
      expect(body.parts[0].parts[2].content_type).to eq "text/html"
    end

    it "should maintain the relative order of the parts with the same content-type as they are added" do
      body = Mail::Body.new('');
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML_1")
      body << Mail::Part.new("content-type: image/jpeg\r\nsubject: JPGEG_1\r\n\r\nsdkjskjdksjdkjsd")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text_1")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched_1")
      body << Mail::Part.new("content-type: text/html\r\nsubject: HTML_2")
      body << Mail::Part.new("content-type: text/plain\r\nsubject: Plain Text_2")
      body << Mail::Part.new("content-type: image/jpeg\r\nsubject: JPGEG_2\r\n\r\nsdkjskjdksjdkjsd")
      body << Mail::Part.new("content-type: text/enriched\r\nsubject: Enriched_2")
      expect(body.parts.length).to eq 8
      expect(body).to be_multipart
      body.sort_parts!
      expect(body.parts[0].subject).to eq "Plain Text_1"
      expect(body.parts[1].subject).to eq "Plain Text_2"
      expect(body.parts[2].subject).to eq "Enriched_1"
      expect(body.parts[3].subject).to eq "Enriched_2"
      expect(body.parts[4].subject).to eq "HTML_1"
      expect(body.parts[5].subject).to eq "HTML_2"
      expect(body.parts[6].subject).to eq "JPGEG_1"
      expect(body.parts[7].subject).to eq "JPGEG_2"
    end
  end

  describe "matching" do

    it "should still equal itself" do
      body = Mail::Body.new('The body')
      expect(body).to eq body
    end

    it "should match on the body part decoded if given a string to ==" do
      body = Mail::Body.new('The body')
      expect(body == 'The body').to be_truthy
    end

    it "should match on the body part decoded if given a string to ==" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      expect(body == "The body").to be_truthy
    end

    it "should match on the body part decoded if given a string to =~" do
      body = Mail::Body.new('The body')
      expect(body =~ /The/).to eq 0
    end

    it "should match on the body part decoded if given a string to ==" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      expect(body =~ /The/).to eq 0
    end

    it "should match on the body part decoded if given a string to match" do
      body = Mail::Body.new('The body')
      expect((body.match(/The/))[0]).to eq 'The'
    end

    it "should match on the body part decoded if given a string to match" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      expect((body.match(/The/))[0]).to eq 'The'
    end

    it "should match on the body part decoded if given a string to include?" do
      body = Mail::Body.new('The Body')
      expect(body).to include('The')
    end

    it "should match on the body part decoded if given a string to include?" do
      body = Mail::Body.new("VGhlIGJvZHk=\n")
      body.encoding = 'base64'
      expect(body).to include('The')
    end
  end

  describe "non US-ASCII charset" do
    it "should encoded" do
      body = Mail::Body.new("あいうえお\r\n")
      body.charset = 'iso-2022-jp'
      expect(body.encoded).to eq "\e$B$\"$$$&$($*\e(B\r\n"
    end
  end

  describe "invalid encoding" do
    it "should round trip" do
      body = Mail::Body.new('The Body')
      body.encoding = 'invalid'
      expect(body.encoded).to eq 'The Body'
    end
  end

  describe "Partslist empty" do
    it "should not break on empty PartsList on body" do
      body = Mail::Body.new('The Body')
      body.sort_parts!
      expect(body.parts.count).to eq 0
    end
  end
end
