# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::Header do

  describe "initialization" do

    it "should instantiate empty" do
      expect { Mail::Header.new }.not_to raise_error
    end

    it "should instantiate with a string passed in" do
      expect { Mail::Header.new("To: Mikel\r\nFrom: bob\r\n") }.not_to raise_error
    end

  end

  describe "copying" do

    it "should instantiate with a string passed in" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      copy = header.dup
      expect(copy.to_a).to eq(header.to_a)
      expect(copy[:to]).to eq(header[:to])
    end

  end

  describe "instance methods" do

    it "should save away the raw source of the header that it is passed" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header.raw_source).to eq "To: Mikel\r\nFrom: bob\r\n"
    end

    it "should say if it has a message_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header).not_to be_has_message_id
    end

    it "should say if it has a message_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\nMessage-ID: 1234")
      expect(header).to be_has_message_id
    end

    it "should say if it has a content_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header).not_to be_has_content_id
    end

    it "should say if it has a content_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\nContent-ID: <1234@me.com>")
      expect(header).to be_has_content_id
    end

    it "should know its own charset" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\nContent-ID: <1234@me.com>")
      expect(header.charset).to be_nil
    end

    it "should know its own charset if set" do
      header = Mail::Header.new
      header['content-type'] = 'text/plain; charset=utf-8'
      expect(header.charset).to eq 'utf-8'
    end

    it "should not unset previously set charset if content-type is set without charset" do
      header = Mail::Header.new(nil, 'utf-8')
      header['content-type'] = 'text/plain'
      expect(header.charset).to eq 'utf-8'
    end

    it "shouldn't die when queried for a charset and the content-type header is invalid" do
      header = Mail::Header.new
      header['Content-Type'] = 'invalid/invalid; charset="iso-8859-1"'
      expect { header.charset }.not_to raise_error
    end

    it "should be Enumerable" do
      header = Mail::Header.new("To: James Random\r\nFrom: Santa Claus\r\n")
      expect(header.find {|f| f.responsible_for?('From') }).to be_a(Mail::Field)
    end
  end

  describe "creating fields" do
      it "should recognise a bcc field" do
        header = Mail::Header.new
        header['bcc'] = 'mikel@test.lindsaar.net'
        expect(header['bcc'].field.class).to eq Mail::BccField
      end

      it "should recognise a cc field" do
        header = Mail::Header.new
        header['cc'] = 'mikel@test.lindsaar.net'
        expect(header['cc'].field.class).to eq Mail::CcField
      end

      it "should recognise a content-description field" do
        header = Mail::Header.new
        header['content-description'] = 'Text'
        expect(header['content-description'].field.class).to eq Mail::ContentDescriptionField
      end

      it "should recognise a content-disposition field" do
        header = Mail::Header.new
        header['content-disposition'] = 'attachment; filename=File'
        expect(header['content-disposition'].field.class).to eq Mail::ContentDispositionField
      end

      it "should recognise an inline content-disposition field" do
        header = Mail::Header.new
        header['content-disposition'] = 'inline'
        expect(header['content-disposition'].field.class).to eq Mail::ContentDispositionField
      end


      it "should recognise a content-id field" do
        header = Mail::Header.new
        header['content-id'] = '<1234@test.lindsaar.net>'
        expect(header['content-id'].field.class).to eq Mail::ContentIdField
      end

      it "should recognise a content-transfer-encoding field" do
        header = Mail::Header.new
        header['content-transfer-encoding'] = '7bit'
        expect(header['content-transfer-encoding'].field.class).to eq Mail::ContentTransferEncodingField
      end

      it "should recognise a content-type field" do
        header = Mail::Header.new
        header['content-type'] = 'text/plain'
        expect(header['content-type'].field.class).to eq Mail::ContentTypeField
      end

      it "should recognise a date field" do
        header = Mail::Header.new
        header['date'] = 'Fri, 21 Nov 1997 09:55:06 -0600'
        expect(header['date'].field.class).to eq Mail::DateField
      end

      it "should recognise a from field" do
        header = Mail::Header.new
        header['from'] = 'mikel@test.lindsaar.net'
        expect(header['from'].field.class).to eq Mail::FromField
      end

      it "should recognise a in-reply-to field" do
        header = Mail::Header.new
        header['in-reply-to'] = '<1234@test.lindsaar.net>'
        expect(header['in-reply-to'].field.class).to eq Mail::InReplyToField
      end

      it "should recognise a keywords field" do
        header = Mail::Header.new
        header['keywords'] = 'mikel test lindsaar net'
        expect(header['keywords'].field.class).to eq Mail::KeywordsField
      end

      it "should recognise a message-id field" do
        header = Mail::Header.new
        header['message-id'] = '<1234@test.lindsaar.net>'
        expect(header['message-id'].field.class).to eq Mail::MessageIdField
      end

      it "should recognise a mime-version field" do
        header = Mail::Header.new
        header['mime-version'] = '1.0'
        expect(header['mime-version'].field.class).to eq Mail::MimeVersionField
      end

      it "should recognise a received field" do
        header = Mail::Header.new
        header['received'] = 'from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id C1B953B4CB6 for <xxxxx@Exxx.xxxx.xxx>; Tue, 10 May 2005 15:27:05 -0500'
        expect(header['received'].field.class).to eq Mail::ReceivedField
      end

      it "should recognise a references field" do
        header = Mail::Header.new
        header['references'] = '<1234@test.lindsaar.net>'
        expect(header['references'].field.class).to eq Mail::ReferencesField
      end

      it "should recognise a reply-to field" do
        header = Mail::Header.new
        header['reply-to'] = 'mikel@test.lindsaar.net'
        expect(header['reply-to'].field.class).to eq Mail::ReplyToField
      end

      it "should recognise a resent-bcc field" do
        header = Mail::Header.new
        header['resent-bcc'] = 'mikel@test.lindsaar.net'
        expect(header['resent-bcc'].field.class).to eq Mail::ResentBccField
      end

      it "should recognise a resent-cc field" do
        header = Mail::Header.new
        header['resent-cc'] = 'mikel@test.lindsaar.net'
        expect(header['resent-cc'].field.class).to eq Mail::ResentCcField
      end

      it "should recognise a resent-date field" do
        header = Mail::Header.new
        header['resent-date'] = 'Fri, 21 Nov 1997 09:55:06 -0600'
        expect(header['resent-date'].field.class).to eq Mail::ResentDateField
      end

      it "should recognise a resent-from field" do
        header = Mail::Header.new
        header['resent-from'] = 'mikel@test.lindsaar.net'
        expect(header['resent-from'].field.class).to eq Mail::ResentFromField
      end

      it "should recognise a resent-message-id field" do
        header = Mail::Header.new
        header['resent-message-id'] = '<1234@mail.baci.local>'
        expect(header['resent-message-id'].field.class).to eq Mail::ResentMessageIdField
      end

      it "should recognise a resent-sender field" do
        header = Mail::Header.new
        header['resent-sender'] = 'mikel@test.lindsaar.net'
        expect(header['resent-sender'].field.class).to eq Mail::ResentSenderField
      end

      it "should recognise a resent-to field" do
        header = Mail::Header.new
        header['resent-to'] = 'mikel@test.lindsaar.net'
        expect(header['resent-to'].field.class).to eq Mail::ResentToField
      end

      it "should recognise a return-path field" do
        header = Mail::Header.new
        header['return-path'] = '<mikel@me.com>'
        expect(header['return-path'].field.class).to eq Mail::ReturnPathField
      end

      it "should recognise a sender field" do
        header = Mail::Header.new
        header['sender'] = 'mikel@test.lindsaar.net'
        expect(header['sender'].field.class).to eq Mail::SenderField
      end

      it "should recognise a to field" do
        header = Mail::Header.new
        header['to'] = 'mikel@test.lindsaar.net'
        expect(header['to'].field.class).to eq Mail::ToField
      end

      it "should maintain header case" do
        header = Mail::Header.new
        header['User-Agent'] = 'My funky mailer'
        expect(header.encoded).to match(/^User-Agent: /)
        expect(header.encoded).not_to match(/^user-agent: /)
      end

      it "should not accept field names containing colons" do
        expect { Mail::Header.new['a:b'] = 'c' }.to raise_error(ArgumentError)
      end

    end


  describe "parsing" do

    it "should split the header into separate fields" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header.fields.length).to eq 2
    end

    it "should not split a wrapped header in two" do
      header = Mail::Header.new("To: mikel lindsaar\r\n\s<mikel@lindsaar>\r\nFrom: bob\r\nSubject: This is\r\n a long\r\n\s \t \t \t    badly formatted             \r\n       \t\t  \t       field")
      expect(header.fields.length).to eq 3
    end

    #  Header fields are lines composed of a field name, followed by a colon
    #  (":"), followed by a field body, and terminated by CRLF.  A field
    #  name MUST be composed of printable US-ASCII characters (i.e.,
    #  characters that have values between 33 and 126, inclusive), except
    #  colon.
    it "should accept any valid header field name" do
      test_name = ascii.reject { |c| c == ':' }.join
      expect { Mail::Header.new("#{test_name}: This is a crazy name") }.not_to raise_error
    end

    it "should not try to accept colons in header field names" do
      header = Mail::Header.new("Colon:in:header: oops")
      expect(header.fields.size).to eq 1
      expect(header.fields.first.name).to eq 'Colon'
      expect(header['Colon'].value).to eq 'in:header: oops'
    end

    # A field body may be composed of any US-ASCII characters,
    # except for CR and LF.  However, a field body may contain CRLF when
    # used in header "folding" and  "unfolding" as described in section
    # 2.2.3.
    it "should accept any valid header field value" do
      test_value = ascii.reject { |c| c == ':' }
      test_value << ' '
      test_value << '\r\n'
      expect {Mail::Header.new("header: #{test_value}")}.not_to raise_error
    end

    it "should split each field into an name and value" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header.fields[0].name).to eq "From"
      expect(header.fields[0].value).to eq "bob"
      expect(header.fields[1].name).to eq "To"
      expect(header.fields[1].value).to eq "Mikel"
    end

    it "should split each field into an name and value - even if whitespace is missing" do
      header = Mail::Header.new("To: Mikel\r\nFrom:bob\r\n")
      expect(header.fields[0].name).to eq "From"
      expect(header.fields[0].value).to eq "bob"
      expect(header.fields[1].name).to eq "To"
      expect(header.fields[1].value).to eq "Mikel"
    end

    it "should preserve the order of the fields it is given" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'To: bob@you.com', 'Subject: This is a badly formed email']
      expect(header.fields[0].name).to eq 'From'
      expect(header.fields[1].name).to eq 'To'
      expect(header.fields[2].name).to eq 'Subject'
    end

    it "should allow you to reference each field and value by literal string name" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header['To'].value).to eq "Mikel"
      expect(header['From'].value).to eq "bob"
    end

    it "should return an array of fields if there is more than one match" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'X-Mail-SPAM: 15', 'X-Mail-SPAM: 23']
      expect(header['X-Mail-SPAM'].map { |x| x.value }).to eq ['15', '23']
    end

    it "should return nil if no value in the header" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      expect(header['Subject']).to be_nil
    end

    it "should add a new field if the field does not exist" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['Subject'] = "G'Day!"
      expect(header['Subject'].value).to eq "G'Day!"
    end

    it "should allow you to pass in an array of raw fields" do
      header = Mail::Header.new
      header.fields = ['From: mikel@test.lindsaar.net', 'To: bob@you.com']
      expect(header['To'].value).to eq 'bob@you.com'
      expect(header['From'].value).to eq 'mikel@test.lindsaar.net'
    end

    it "should reset the value of a single-only field if it already exists" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['To'] = 'George'
      expect(header['To'].value).to eq "George"
    end

    it "should allow you to delete a field by setting it to nil" do
      header = Mail::Header.new
      header.fields = ['To: bob@you.com']
      expect(header.fields.length).to eq 1
      header['To'] = nil
      expect(header.fields.length).to eq 0
    end

    it "should delete all matching fields found if there are multiple options" do
      header = Mail::Header.new
      header.fields = ['X-SPAM: 1000', 'X-SPAM: 20']
      header['X-SPAM'] = nil
      expect(header.fields.length).to eq 0
    end

    it "should delete only matching fields found" do
      header = Mail::Header.new
      header.fields = ['X-SPAM: 1000', 'X-AUTHOR: Steve']
      header['X-SPAM'] = nil
      expect(header['X-AUTHOR']).not_to be_nil
      expect(header.fields.length).to eq 1
    end

    # Handle empty X-Optional header from Microsoft Exchange
    it "should handle an empty X-* header value" do
      header = Mail::Header.new("X-MS-TNEF-Correlator:\r\n")
      expect(header.fields.length).to eq 1
      expect(header['X-MS-TNEF-Correlator'].decoded).to be_nil
      expect(header['X-MS-TNEF-Correlator'].encoded).to eq "X-MS-TNEF-Correlator: \r\n"
    end

    it "should accept X- option fields from MS-Exchange" do
      header = Mail::Header.new("X-Ms-Has-Attach:\r\nX-MS-TNEF-Correlator: \r\n")
      expect(header.fields.length).to eq 2
      expect(header['X-Ms-Has-Attach'].decoded).to be_nil
      expect(header['X-Ms-Has-Attach'].encoded).to eq "X-Ms-Has-Attach: \r\n"
      expect(header['X-MS-TNEF-Correlator'].decoded).to be_nil
      expect(header['X-MS-TNEF-Correlator'].encoded).to eq "X-MS-TNEF-Correlator: \r\n"
    end

    it "should return nil if asked for the value of a non existent field" do
      header = Mail::Header.new
      expect(header['Bobs-Field']).to be_nil
    end

    it "should allow you to replace a from field" do
      header = Mail::Header.new
      expect(header['From']).to be_nil
      header['From'] = 'mikel@test.lindsaar.net'
      expect(header['From'].decoded).to eq 'mikel@test.lindsaar.net'
      header['From'] = 'bob@test.lindsaar.net'
      expect(header['From'].decoded).to eq 'bob@test.lindsaar.net'
    end

    it "should maintain the class of the field" do
      header = Mail::Header.new
      header['From'] = 'mikel@test.lindsaar.net'
      expect(header['From'].field.class).to eq Mail::FromField
      header['From'] = 'bob@test.lindsaar.net'
      expect(header['From'].field.class).to eq Mail::FromField
    end
  end

  describe "folding and unfolding" do

    it "should unfold a header" do
      header = Mail::Header.new("To: Mikel,\r\n Lindsaar, Bob")
      expect(header['To'].value).to eq 'Mikel, Lindsaar, Bob'
    end

    it "should preserve whitespace when unfolding a header" do
      header = Mail::Header.new("To: Mikel,\r\n\t   Lindsaar,     Bob")
      expect(header['To'].value).to eq "Mikel,\t   Lindsaar,     Bob"
    end

    it "should handle a crazy long folded header" do
      header = Mail::Header.new(<<HERE)
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE

      expect(header['Received'].value).to eq "from [127.0.220.158] (helo=fg-out-1718.google.com)\tby smtp.totallyrandom.com with esmtp (Exim 4.68)\t(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)\tid 1K4JeQ-0005Nd-Ij\tfor support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700"
    end

    it "should convert all lonesome LFs to CRLF" do
      header = Mail::Header.new(<<HERE)
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE

      expect(header['Received'].value).to eq "from [127.0.220.158] (helo=fg-out-1718.google.com)\tby smtp.totallyrandom.com with esmtp (Exim 4.68)\t(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)\tid 1K4JeQ-0005Nd-Ij\tfor support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700"
    end

    it "should convert all lonesome LFs to CRLF in UTF-8 too" do
      header = Mail::Header.new(<<HERE)
Subject: Iñtërnâtiônàlizætiøn
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE

      expect(header['Received'].value).to eq "from [127.0.220.158] (helo=fg-out-1718.google.com)\tby smtp.totallyrandom.com with esmtp (Exim 4.68)\t(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)\tid 1K4JeQ-0005Nd-Ij\tfor support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700"
    end

    it "should convert all lonesome CRs to CRLF" do
      header = Mail::Header.new(<<HERE.gsub(/\n/, "\r"))
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE

      expect(header['Received'].value).to eq "from [127.0.220.158] (helo=fg-out-1718.google.com)\tby smtp.totallyrandom.com with esmtp (Exim 4.68)\t(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)\tid 1K4JeQ-0005Nd-Ij\tfor support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700"
    end

  end

  describe "error handling" do
    it "should collect up any of its fields' errors" do
      header = Mail::Header.new("Content-Transfer-Encoding: vl@d\r\nReply-To: a b b")
      expect(Mail::Utilities.blank?(header.errors)).not_to be_truthy
      expect(header.errors.size).to eq 2
      expect(header.errors[0][0]).to eq 'Reply-To'
      expect(header.errors[0][1]).to eq 'a b b'
      expect(header.errors[1][0]).to eq 'Content-Transfer-Encoding'
      expect(header.errors[1][1]).to eq 'vl@d'
    end
  end

  describe "handling date fields with multiple values" do
    it "should know which fields can only appear once" do
      %w[ date ].each do |field|
        header = Mail::Header.new
        header[field] = "Thu, 05 Jun 2008 10:53:29 -0700"
        header[field] = "Mon, 15 Nov 2010 11:05:29 -1100"
        expect(header[field].value).to eq "Mon, 15 Nov 2010 11:05:29 -1100"
      end
    end

    it "should know which fields can only appear once" do
      %w[ from sender reply-to to cc bcc ].each do |field|
        header = Mail::Header.new
        header[field] = "mikel@test.lindsaar.net"
        header[field] = "ada@test.lindsaar.net"
        expect(header[field].value).to eq "ada@test.lindsaar.net"
      end
    end

    it "should enforce appear-once rule even with mass assigned header" do
      header = Mail::Header.new(
        "Content-Type: multipart/alternative\nContent-Type: text/plain\n"
      )
      expect(header['content-type']).not_to be_kind_of(Array)
    end

    it "should add additional fields that can appear more than once" do
      %w[ comments keywords x-spam].each do |field|
        header = Mail::Header.new
        header[field] = "1234"
        header[field] = "5678"
        expect(header[field].map { |x| x.value }).to eq ["1234", "5678"]
      end
    end

    it "should delete all references to a field" do
      header = Mail::Header.new
      header.fields = ['X-Mail-SPAM: 15', 'X-Mail-SPAM: 20']
      header['X-Mail-SPAM'] = '10000'
      expect(header['X-Mail-SPAM'].map { |x| x.value }).to eq ['15', '20', '10000']
      header['X-Mail-SPAM'] = nil
      expect(header['X-Mail-SPAM']).to be_nil
    end
  end

  describe "handling trace fields" do

    before(:each) do
      trace_header =<<TRACEHEADER
Return-Path: <xxx@xxxx.xxxtest>
Received: from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:23 -0500
Received: from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id j48HUC213279 for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:13 -0500
Received: from conversion-xxx.xxxx.xxx.net by xxx.xxxx.xxx id <0IG600901LQ64I@xxx.xxxx.xxx> for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:12 -0500
Received: from agw1 by xxx.xxxx.xxx with ESMTP id <0IG600JFYLYCAxxx@xxxx.xxx> for <xxx@xxxx.xxx>; Sun, 8 May 2005 12:30:12 -0500
TRACEHEADER
      @traced_header = Mail::Header.new(trace_header)
    end

    it "should instantiate one trace field object per header" do
      expect(@traced_header.fields.length).to eq 5
    end

    it "should add a new received header after the other received headers if they exist" do
      @traced_header['To'] = "Mikel"
      @traced_header['Received'] = "from agw2 by xxx.xxxx.xxx; Sun, 8 May 2005 12:30:13 -0500"
      expect(@traced_header.fields[0].addresses).to eq ['xxx@xxxx.xxxtest']
      expect(@traced_header.fields[1].info).to eq 'from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>'
      expect(@traced_header.fields[2].info).to eq 'from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id j48HUC213279 for <xxx@xxxx.xxx>'
      expect(@traced_header.fields[3].info).to eq 'from conversion-xxx.xxxx.xxx.net by xxx.xxxx.xxx id <0IG600901LQ64I@xxx.xxxx.xxx> for <xxx@xxxx.xxx>'
      expect(@traced_header.fields[5].info).to eq "from agw2 by xxx.xxxx.xxx"
      expect(@traced_header.fields[6].field.class).to eq Mail::ToField
    end

  end

  describe "encoding" do
    it "should output a parsed version of itself to US-ASCII on encoded and tidy up and sort correctly" do
      encoded = Mail::Header.new("To: Mikel\r\n\sLindsaar <mikel@test.lindsaar.net>\r\nFrom: bob\r\n\s<bob@test.lindsaar.net>\r\nSubject: This is\r\n a long\r\n\s \t \t \t    badly formatted             \r\n       \t\t  \t       field").encoded
      result = "From: bob <bob@test.lindsaar.net>\r\nTo: Mikel Lindsaar <mikel@test.lindsaar.net>\r\nSubject: This is a long           badly formatted                             \r\n   field\r\n"
      if result.respond_to?(:encode!)
        result = result.dup.encode!(::Encoding::US_ASCII)
        expect(encoded.encoding).to eq ::Encoding::US_ASCII if encoded.respond_to?(:encoding)
      end
      expect(encoded).to eq result
    end

    if '1.9'.respond_to?(:force_encoding)
      it "should not blow up on encoding mismatches" do
        junk = "Subject: \xAF".dup.force_encoding(Encoding::ASCII_8BIT)
        header = Mail::Header.new(junk, 'utf-8')
        expect(header.encoded).to eq("Subject: =?UTF-8?Q?=EF=BF=BD?=\r\n")
      end
    end
  end

  describe "detecting required fields" do
    it "should not say it has a message id if it doesn't" do
      expect(Mail::Header.new).not_to be_has_message_id
    end

    it "should say it has a message id if it does" do
      expect(Mail::Header.new('Message-ID: 1234')).to be_has_message_id
    end

    it "should not say it has a date if it doesn't" do
      expect(Mail::Header.new).not_to be_has_date
    end

    it "should say it has a date id if it does" do
      expect(Mail::Header.new('Date: Mon, 24 Nov 1997 14:22:01 -0800')).to be_has_date
    end

    it "should not say it has a mime-version if it doesn't" do
      expect(Mail::Header.new).not_to be_has_mime_version
    end

    it "should say it has a date id if it does" do
      expect(Mail::Header.new('Mime-Version: 1.0')).to be_has_mime_version
    end
  end

  describe "mime version handling" do
    it "should return the mime version of the email" do
      header = Mail::Header.new("Mime-Version: 1.0")
      expect(header['mime-version'].value).to eq '1.0'
    end

    it "should return nil if no mime-version header field" do
      header = Mail::Header.new('To: bob')
      expect(header['mime_version']).to be_nil
    end

    it "should return the transfer-encoding of the email" do
      header = Mail::Header.new("Content-Transfer-Encoding: Base64")
      expect(header['content-transfer-encoding'].value).to eq 'Base64'
    end

    it "should return nil if no transfer-encoding header field" do
      header = Mail::Header.new
      expect(header['content-transfer-encoding']).to be_nil
    end

    it "should return the content-description of the email" do
      header = Mail::Header.new("Content-Description: This is a description")
      expect(header['Content-Description'].value).to eq 'This is a description'
    end

    it "should return nil if no content-description header field" do
      header = Mail::Header.new
      expect(header['Content-Description']).to be_nil
    end

  end

  describe "configuration option .maximum_amount" do

    it "should be 1000 by default" do
      expect(Mail::Header.maximum_amount).to eq(1000)
    end

    it "should limit amount of parsed headers" do
      Mail::Header.maximum_amount, old_max = 10, Mail::Header.maximum_amount
      $VERBOSE, old_verbose = nil, $VERBOSE

      begin
        expect(Kernel).to receive(:warn).with(match(/10 header fields/))
        header = Mail::Header.new("X-SubscriberID: 345\n" * 11)
        expect(header.fields.size).to eq(10)
      ensure
        $VERBOSE = old_verbose
        Mail::Header.maximum_amount = old_max
      end
    end

  end

end
