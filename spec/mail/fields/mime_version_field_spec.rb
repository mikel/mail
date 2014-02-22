require 'spec_helper'

describe Mail::MimeVersionField do
  # MIME-Version Header Field
  # 
  # Since RFC 822 was published in 1982, there has really been only one
  # format standard for Internet messages, and there has been little
  # perceived need to declare the format standard in use.  This document
  # is an independent specification that complements RFC 822.  Although
  # the extensions in this document have been defined in such a way as to
  # be compatible with RFC 822, there are still circumstances in which it
  # might be desirable for a mail-processing agent to know whether a
  # message was composed with the new standard in mind.
  # 
  # Therefore, this document defines a new header field, "MIME-Version",
  # which is to be used to declare the version of the Internet message
  # body format standard in use.
  # 
  # Messages composed in aMimeVersionordance with this document MUST include such
  # a header field, with the following verbatim text:
  # 
  #   MIME-Version: 1.0
  # 
  # The presence of this header field is an assertion that the message
  # has been composed in compliance with this document.
  # 
  # Since it is possible that a future document might extend the message
  # format standard again, a formal BNF is given for the content of the
  # MIME-Version field:
  # 
  #   version := "MIME-Version" ":" 1*DIGIT "." 1*DIGIT
  # 
  # Thus, future format specifiers, which might replace or extend "1.0",
  # are constrained to be two integer fields, separated by a period.  If
  # a message is received with a MIME-version value other than "1.0", it
  # cannot be assumed to conform with this document.
  # 
  # Note that the MIME-Version header field is required at the top level
  # of a message.  It is not required for each body part of a multipart
  # entity.  It is required for the embedded headers of a body of type
  # "message/rfc822" or "message/partial" if and only if the embedded
  # message is itself claimed to be MIME-conformant.
  # 
  # It is not possible to fully specify how a mail reader that conforms
  # with MIME as defined in this document should treat a message that
  # might arrive in the future with some value of MIME-Version other than
  # "1.0".
  # 
  # It is also worth noting that version control for specific media types
  # is not aMimeVersionomplished using the MIME-Version mechanism.  In particular,
  # some formats (such as application/postscript) have version numbering
  # conventions that are internal to the media format.  Where such
  # conventions exist, MIME does nothing to supersede them.  Where no
  # such conventions exist, a MIME media type might use a "version"
  # parameter in the content-type field if necessary.
  # 
  # NOTE TO IMPLEMENTORS:  When checking MIME-Version values any RFC 822
  # comment strings that are present must be ignored.  In particular, the
  # following four MIME-Version fields are equivalent:
  # 
  #   MIME-Version: 1.0
  # 
  #   MIME-Version: 1.0 (produced by MetaSend Vx.x)
  # 
  #   MIME-Version: (produced by MetaSend Vx.x) 1.0
  # 
  #   MIME-Version: 1.(produced by MetaSend Vx.x)0
  # 
  # In the absence of a MIME-Version field, a receiving mail user agent
  # (whether conforming to MIME requirements or not) may optionally
  # choose to interpret the body of the message aMimeVersionording to local
  # conventions.  Many such conventions are currently in use and it
  # should be noted that in practice non-MIME messages can contain just
  # about anything.
  # 
  # It is impossible to be certain that a non-MIME mail message is
  # actually plain text in the US-ASCII character set since it might well
  # be a message that, using some set of nonstandard local conventions
  # that predate MIME, includes text in another character set or non-
  # textual data presented in a manner that cannot be automatically
  # recognized (e.g., a uuencoded compressed UNIX tar file).

  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::MimeVersionField.new("1.0") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::MimeVersionField.new('Mime-Version: 1.0')
      expect(t.name).to eq 'Mime-Version'
      expect(t.value).to eq '1.0'
    end

    it "should accept a string without the field name" do
      t = Mail::MimeVersionField.new('1.0')
      expect(t.name).to eq 'Mime-Version'
      expect(t.value).to eq '1.0'
    end

  end

  describe "parsing a version string" do
    it "should get a major value" do
      t = Mail::MimeVersionField.new('1.0')
      expect(t.major).to eq 1
    end

    it "should get a minor value" do
      t = Mail::MimeVersionField.new('1.0')
      expect(t.minor).to eq 0
    end

    it "should get a version string" do
      t = Mail::MimeVersionField.new('1.0')
      expect(t.version).to eq '1.0'
    end
    
    it "should handle comments before the major version" do
      t = Mail::MimeVersionField.new('(This is a comment) 1.0')
      expect(t.version).to eq '1.0'
    end

    it "should handle comments before the major version without space" do
      t = Mail::MimeVersionField.new('(This is a comment)1.0')
      expect(t.version).to eq '1.0'
    end

    it "should handle comments after the major version without space" do
      t = Mail::MimeVersionField.new('1(This is a comment).0')
      expect(t.version).to eq '1.0'
    end

    it "should handle comments before the minor version without space" do
      t = Mail::MimeVersionField.new('1.(This is a comment)0')
      expect(t.version).to eq '1.0'
    end

    it "should handle comments after the minor version without space" do
      t = Mail::MimeVersionField.new('1.0(This is a comment)')
      expect(t.version).to eq '1.0'
    end

    it "should handle comments after the minor version" do
      t = Mail::MimeVersionField.new('1.0 (This is a comment)')
      expect(t.version).to eq '1.0'
    end
    
    it "should accept nil as a value" do
      t = Mail::MimeVersionField.new(nil)
      expect(t.version).not_to be_nil
    end
    
    it "should provide an encoded value" do
      t = Mail::MimeVersionField.new('1.0 (This is a comment)')
      expect(t.encoded).to eq "Mime-Version: 1.0\r\n"
    end

    it "should provide an decoded value" do
      t = Mail::MimeVersionField.new('1.0 (This is a comment)')
      expect(t.decoded).to eq '1.0'
    end

  end

end
