# encoding: utf-8
require 'spec_helper'

describe Mail::Header do

  describe "initialization" do
    
    it "should instantiate empty" do
      doing { Mail::Header.new }.should_not raise_error
    end

    it "should instantiate with a string passed in" do
      doing { Mail::Header.new("To: Mikel\r\nFrom: bob\r\n") }.should_not raise_error
    end

  end

  describe "instance methods" do
    
    it "should save away the raw source of the header that it is passed" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.raw_source.should == "To: Mikel\r\nFrom: bob\r\n"
    end
    
    it "should say if it has a message_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.should_not be_has_message_id
    end
    
    it "should say if it has a message_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\nMessage-ID: 1234")
      header.should be_has_message_id
    end
    
    it "should say if it has a content_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.should_not be_has_content_id
    end
    
    it "should say if it has a content_id field defined" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\nContent-ID: <1234@me.com>")
      header.should be_has_content_id
    end
    
    it "should know it's own charset" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\nContent-ID: <1234@me.com>")
      header.charset.should == nil
    end
    
    it "should know it's own charset if set" do
      header = Mail::Header.new
      header['content-type'] = 'text/plain; charset=utf-8'
      header.charset.should == 'utf-8'
    end
    
  end

  describe "creating fields" do
      it "should recognise a bcc field" do
        header = Mail::Header.new
        header['bcc'] = 'mikel@test.lindsaar.net'
        header['bcc'].field.class.should == Mail::BccField
      end
      
      it "should recognise a cc field" do
        header = Mail::Header.new
        header['cc'] = 'mikel@test.lindsaar.net'
        header['cc'].field.class.should == Mail::CcField
      end
      
      it "should recognise a content-description field" do
        header = Mail::Header.new
        header['content-description'] = 'Text'
        header['content-description'].field.class.should == Mail::ContentDescriptionField
      end
      
      it "should recognise a content-disposition field" do
        header = Mail::Header.new
        header['content-disposition'] = 'attachment; filename=File'
        header['content-disposition'].field.class.should == Mail::ContentDispositionField
      end

      it "should recognise an inline content-disposition field" do
        header = Mail::Header.new
        header['content-disposition'] = 'inline'
        header['content-disposition'].field.class.should == Mail::ContentDispositionField
      end


      it "should recognise a content-id field" do
        header = Mail::Header.new
        header['content-id'] = '<1234@test.lindsaar.net>'
        header['content-id'].field.class.should == Mail::ContentIdField
      end
      
      it "should recognise a content-transfer-encoding field" do
        header = Mail::Header.new
        header['content-transfer-encoding'] = '7bit'
        header['content-transfer-encoding'].field.class.should == Mail::ContentTransferEncodingField
      end
      
      it "should recognise a content-type field" do
        header = Mail::Header.new
        header['content-type'] = 'text/plain'
        header['content-type'].field.class.should == Mail::ContentTypeField
      end
      
      it "should recognise a date field" do
        header = Mail::Header.new
        header['date'] = 'Fri, 21 Nov 1997 09:55:06 -0600'
        header['date'].field.class.should == Mail::DateField
      end
      
      it "should recognise a from field" do
        header = Mail::Header.new
        header['from'] = 'mikel@test.lindsaar.net'
        header['from'].field.class.should == Mail::FromField
      end
      
      it "should recognise a in-reply-to field" do
        header = Mail::Header.new
        header['in-reply-to'] = '<1234@test.lindsaar.net>'
        header['in-reply-to'].field.class.should == Mail::InReplyToField
      end
      
      it "should recognise a keywords field" do
        header = Mail::Header.new
        header['keywords'] = 'mikel test lindsaar net'
        header['keywords'].field.class.should == Mail::KeywordsField
      end
      
      it "should recognise a message-id field" do
        header = Mail::Header.new
        header['message-id'] = '<1234@test.lindsaar.net>'
        header['message-id'].field.class.should == Mail::MessageIdField
      end
      
      it "should recognise a mime-version field" do
        header = Mail::Header.new
        header['mime-version'] = '1.0'
        header['mime-version'].field.class.should == Mail::MimeVersionField
      end
      
      it "should recognise a received field" do
        header = Mail::Header.new
        header['received'] = 'from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id C1B953B4CB6 for <xxxxx@Exxx.xxxx.xxx>; Tue, 10 May 2005 15:27:05 -0500'
        header['received'].field.class.should == Mail::ReceivedField
      end
      
      it "should recognise a references field" do
        header = Mail::Header.new
        header['references'] = '<1234@test.lindsaar.net>'
        header['references'].field.class.should == Mail::ReferencesField
      end
      
      it "should recognise a reply-to field" do
        header = Mail::Header.new
        header['reply-to'] = 'mikel@test.lindsaar.net'
        header['reply-to'].field.class.should == Mail::ReplyToField
      end
      
      it "should recognise a resent-bcc field" do
        header = Mail::Header.new
        header['resent-bcc'] = 'mikel@test.lindsaar.net'
        header['resent-bcc'].field.class.should == Mail::ResentBccField
      end
      
      it "should recognise a resent-cc field" do
        header = Mail::Header.new
        header['resent-cc'] = 'mikel@test.lindsaar.net'
        header['resent-cc'].field.class.should == Mail::ResentCcField
      end
      
      it "should recognise a resent-date field" do
        header = Mail::Header.new
        header['resent-date'] = 'Fri, 21 Nov 1997 09:55:06 -0600'
        header['resent-date'].field.class.should == Mail::ResentDateField
      end
      
      it "should recognise a resent-from field" do
        header = Mail::Header.new
        header['resent-from'] = 'mikel@test.lindsaar.net'
        header['resent-from'].field.class.should == Mail::ResentFromField
      end
      
      it "should recognise a resent-message-id field" do
        header = Mail::Header.new
        header['resent-message-id'] = '<1234@mail.baci.local>'
        header['resent-message-id'].field.class.should == Mail::ResentMessageIdField
      end
      
      it "should recognise a resent-sender field" do
        header = Mail::Header.new
        header['resent-sender'] = 'mikel@test.lindsaar.net'
        header['resent-sender'].field.class.should == Mail::ResentSenderField
      end
      
      it "should recognise a resent-to field" do
        header = Mail::Header.new
        header['resent-to'] = 'mikel@test.lindsaar.net'
        header['resent-to'].field.class.should == Mail::ResentToField
      end
      
      it "should recognise a return-path field" do
        header = Mail::Header.new
        header['return-path'] = '<mikel@me.com>'
        header['return-path'].field.class.should == Mail::ReturnPathField
      end
      
      it "should recognise a sender field" do
        header = Mail::Header.new
        header['sender'] = 'mikel@test.lindsaar.net'
        header['sender'].field.class.should == Mail::SenderField
      end
      
      it "should recognise a to field" do
        header = Mail::Header.new
        header['to'] = 'mikel@test.lindsaar.net'
        header['to'].field.class.should == Mail::ToField
      end

      it "should maintain header case" do
        header = Mail::Header.new
        header['User-Agent'] = 'My funky mailer'
        header.encoded.should match(/^User-Agent: /)
        header.encoded.should_not match(/^user-agent: /)
      end
      
    end
  

  describe "parsing" do

    it "should split the header into separate fields" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.fields.length.should == 2
    end
    
    it "should not split a wrapped header in two" do
      header = Mail::Header.new("To: mikel lindsaar\r\n\s<mikel@lindsaar>\r\nFrom: bob\r\nSubject: This is\r\n a long\r\n\s \t \t \t    badly formatted             \r\n       \t\t  \t       field")
      header.fields.length.should == 3
    end
    
    #  Header fields are lines composed of a field name, followed by a colon
    #  (":"), followed by a field body, and terminated by CRLF.  A field
    #  name MUST be composed of printable US-ASCII characters (i.e.,
    #  characters that have values between 33 and 126, inclusive), except
    #  colon.
    it "should accept any valid header field name" do
      test_name = ascii.reject { |c| c == ':' }.join
      doing { Mail::Header.new("#{test_name}: This is a crazy name") }.should_not raise_error
    end

    # A field body may be composed of any US-ASCII characters,
    # except for CR and LF.  However, a field body may contain CRLF when
    # used in header "folding" and  "unfolding" as described in section
    # 2.2.3.
    it "should accept any valid header field value" do
      test_value = ascii.reject { |c| c == ':' }
      test_value << ' '
      test_value << '\r\n'
      doing {Mail::Header.new("header: #{test_value}")}.should_not raise_error
    end

    it "should split each field into an name and value" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header.fields[0].name.should == "From"
      header.fields[0].value.should == "bob"
      header.fields[1].name.should == "To"
      header.fields[1].value.should == "Mikel"
    end
    
    it "should split each field into an name and value - even if whitespace is missing" do
      header = Mail::Header.new("To: Mikel\r\nFrom:bob\r\n")
      header.fields[0].name.should == "From"
      header.fields[0].value.should == "bob"
      header.fields[1].name.should == "To"
      header.fields[1].value.should == "Mikel"
    end
    
    it "should preserve the order of the fields it is given" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'To: bob@you.com', 'Subject: This is a badly formed email']
      header.fields[0].name.should == 'From'
      header.fields[1].name.should == 'To'
      header.fields[2].name.should == 'Subject'
    end
    
    it "should allow you to reference each field and value by literal string name" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['To'].value.should == "Mikel"
      header['From'].value.should == "bob"
    end

    it "should return an array of fields if there is more than one match" do
      header = Mail::Header.new
      header.fields = ['From: mikel@me.com', 'X-Mail-SPAM: 15', 'X-Mail-SPAM: 23']
      header['X-Mail-SPAM'].map { |x| x.value }.should == ['15', '23']
    end

    it "should return nil if no value in the header" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['Subject'].should be_nil
    end
    
    it "should add a new field if the field does not exist" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['Subject'] = "G'Day!"
      header['Subject'].value.should == "G'Day!"
    end
    
    it "should allow you to pass in an array of raw fields" do
      header = Mail::Header.new
      header.fields = ['From: mikel@test.lindsaar.net', 'To: bob@you.com']
      header['To'].value.should == 'bob@you.com'
      header['From'].value.should == 'mikel@test.lindsaar.net'
    end
    
    it "should reset the value of a single-only field if it already exists" do
      header = Mail::Header.new("To: Mikel\r\nFrom: bob\r\n")
      header['To'] = 'George'
      header['To'].value.should == "George"
    end
    
    it "should allow you to delete a field by setting it to nil" do
      header = Mail::Header.new
      header.fields = ['To: bob@you.com']
      header.fields.length.should == 1
      header['To'] = nil
      header.fields.length.should == 0
    end
    
    it "should delete all matching fields found if there are multiple options" do
      header = Mail::Header.new
      header.fields = ['X-SPAM: 1000', 'X-SPAM: 20']
      header['X-SPAM'] = nil
      header.fields.length.should == 0
    end
    
    # Handle empty X-Optional header from Microsoft Exchange
    it "should handle an empty X-* header value" do
      header = Mail::Header.new("X-MS-TNEF-Correlator:\r\n")
      header.fields.length.should == 1
      header['X-MS-TNEF-Correlator'].decoded.should == nil
      header['X-MS-TNEF-Correlator'].encoded.should == "X-MS-TNEF-Correlator: \r\n"
    end
    
    it "should accept X- option fields from MS-Exchange" do
      header = Mail::Header.new("X-Ms-Has-Attach:\r\nX-MS-TNEF-Correlator: \r\n")
      header.fields.length.should == 2
      header['X-Ms-Has-Attach'].decoded.should == nil
      header['X-Ms-Has-Attach'].encoded.should == "X-Ms-Has-Attach: \r\n"
      header['X-MS-TNEF-Correlator'].decoded.should == nil
      header['X-MS-TNEF-Correlator'].encoded.should == "X-MS-TNEF-Correlator: \r\n"
    end
    
    it "should return nil if asked for the value of a non existent field" do
      header = Mail::Header.new
      header['Bobs-Field'].should == nil
    end
    
    it "should allow you to replace a from field" do
      header = Mail::Header.new
      header['From'].should == nil
      header['From'] = 'mikel@test.lindsaar.net'
      header['From'].decoded.should == 'mikel@test.lindsaar.net'
      header['From'] = 'bob@test.lindsaar.net'
      header['From'].decoded.should == 'bob@test.lindsaar.net'
    end
    
    it "should maintain the class of the field" do
      header = Mail::Header.new
      header['From'] = 'mikel@test.lindsaar.net'
      header['From'].field.class.should == Mail::FromField
      header['From'] = 'bob@test.lindsaar.net'
      header['From'].field.class.should == Mail::FromField
    end
    
  end

  describe "folding and unfolding" do
    
    it "should unfold a header" do
      header = Mail::Header.new("To: Mikel,\r\n Lindsaar, Bob")
      header['To'].value.should == 'Mikel, Lindsaar, Bob'
    end
    
    it "should remove multiple spaces during unfolding a header" do
      header = Mail::Header.new("To: Mikel,\r\n   Lindsaar,     Bob")
      header['To'].value.should == 'Mikel, Lindsaar, Bob'
    end
    
    it "should handle a crazy long folded header" do
      header_text =<<HERE
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE
      header = Mail::Header.new(header_text.gsub(/\n/, "\r\n"))
      header['Received'].value.should == 'from [127.0.220.158] (helo=fg-out-1718.google.com) by smtp.totallyrandom.com with esmtp (Exim 4.68) (envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>) id 1K4JeQ-0005Nd-Ij for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700'
    end
    
    it "should convert all lonesome LFs to CRLF" do
      header_text =<<HERE
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE
      header = Mail::Header.new(header_text.gsub(/\n/, "\n"))
      header['Received'].value.should == 'from [127.0.220.158] (helo=fg-out-1718.google.com) by smtp.totallyrandom.com with esmtp (Exim 4.68) (envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>) id 1K4JeQ-0005Nd-Ij for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700'
    end
    
    it "should convert all lonesome CRs to CRLF" do
      header_text =<<HERE
Received: from [127.0.220.158] (helo=fg-out-1718.google.com)
	by smtp.totallyrandom.com with esmtp (Exim 4.68)
	(envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>)
	id 1K4JeQ-0005Nd-Ij
	for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700
HERE
      header = Mail::Header.new(header_text.gsub(/\n/, "\r"))
      header['Received'].value.should == 'from [127.0.220.158] (helo=fg-out-1718.google.com) by smtp.totallyrandom.com with esmtp (Exim 4.68) (envelope-from <stuff+caf_=support=aaa.somewhere.com@gmail.com>) id 1K4JeQ-0005Nd-Ij for support@aaa.somewhere.com; Thu, 05 Jun 2008 10:53:29 -0700'
    end
    
  end
  
  describe "error handling" do
    it "should collect up any of its fields' errors" do
      header = Mail::Header.new("Content-Transfer-Encoding: vlad\r\nReply-To: a b b")
      header.errors.should_not be_blank
      header.errors.size.should == 2
      header.errors[0][0].should == 'Content-Transfer-Encoding'
      header.errors[0][1].should == 'vlad'
      header.errors[1][0].should == 'Reply-To'
      header.errors[1][1].should == 'a b b'
    end
  end

  describe "handling date fields with multiple values" do
    it "should know which fields can only appear once" do
      %w[ date ].each do |field|
        header = Mail::Header.new
        header[field] = "Thu, 05 Jun 2008 10:53:29 -0700"
        header[field] = "Mon, 15 Nov 2010 11:05:29 -1100"
        header[field].value.should == "Mon, 15 Nov 2010 11:05:29 -1100"
      end
    end
  
    it "should know which fields can only appear once" do
      %w[ from sender reply-to to cc bcc ].each do |field|
        header = Mail::Header.new
        header[field] = "mikel@test.lindsaar.net"
        header[field] = "ada@test.lindsaar.net"
        header[field].value.should == "ada@test.lindsaar.net"
      end
    end

    it "should enforce appear-once rule even with mass assigned header" do
      header = Mail::Header.new(
        "Content-Type: multipart/alternative\nContent-Type: text/plain\n"
      )
      header['content-type'].should_not be_kind_of(Array)
    end
    
    it "should add additional fields that can appear more than once" do
      %w[ comments keywords x-spam].each do |field|
        header = Mail::Header.new
        header[field] = "1234"
        header[field] = "5678"
        header[field].map { |x| x.value }.should == ["1234", "5678"]
      end
    end
    
    it "should delete all references to a field" do
      header = Mail::Header.new
      header.fields = ['X-Mail-SPAM: 15', 'X-Mail-SPAM: 20']
      header['X-Mail-SPAM'] = '10000'
      header['X-Mail-SPAM'].map { |x| x.value }.should == ['15', '20', '10000']
      header['X-Mail-SPAM'] = nil
      header['X-Mail-SPAM'].should == nil
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
      @traced_header.fields.length.should == 5
    end
    
    it "should add a new received header after the other received headers if they exist" do
      @traced_header['To'] = "Mikel"
      @traced_header['Received'] = "from agw2 by xxx.xxxx.xxx; Sun, 8 May 2005 12:30:13 -0500"
      @traced_header.fields[0].addresses.should == ['xxx@xxxx.xxxtest']
      @traced_header.fields[1].info.should == 'from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id 6AAEE3B4D23 for <xxx@xxxx.xxx>'
      @traced_header.fields[2].info.should == 'from xxx.xxxx.xxx by xxx.xxxx.xxx with ESMTP id j48HUC213279 for <xxx@xxxx.xxx>'
      @traced_header.fields[3].info.should == 'from conversion-xxx.xxxx.xxx.net by xxx.xxxx.xxx id <0IG600901LQ64I@xxx.xxxx.xxx> for <xxx@xxxx.xxx>'
      @traced_header.fields[5].info.should == "from agw2 by xxx.xxxx.xxx"
      @traced_header.fields[6].field.class.should == Mail::ToField
    end
    
  end

  describe "encoding" do
    it "should output a parsed version of itself to US-ASCII on encoded and tidy up and sort correctly" do
      header = Mail::Header.new("To: Mikel\r\n\sLindsaar <mikel@test.lindsaar.net>\r\nFrom: bob\r\n\s<bob@test.lindsaar.net>\r\nSubject: This is\r\n a long\r\n\s \t \t \t    badly formatted             \r\n       \t\t  \t       field")
      result = "From: bob <bob@test.lindsaar.net>\r\nTo: Mikel Lindsaar <mikel@test.lindsaar.net>\r\nSubject: This is a long badly formatted field\r\n"
      header.encoded.should == result
    end

    it "should not merge Content-Disposition and User-Agent headers" do
      header = Mail::Header.new("To: Mikel\r\n\sLindsaar <mikel@test.lindsaar.net>\r\nFrom: bob\r\n\s<bob@test.lindsaar.net>\r\nSubject: testing\r\nContent-Disposition: inline\r\nUser-Agent: some sweet mail app\r\n")
      result = "To: Mikel\r\n\sLindsaar <mikel@test.lindsaar.net>\r\nFrom: bob\r\n\s<bob@test.lindsaar.net>\r\nSubject: testing\r\nContent-Disposition: inline\r\nUser-Agent: some sweet mail app\r\n"
      header['Content-Disposition'].should == 'inline'
      header['User-Agent'].should == 'some sweet mail app'
      header.encoded.should == result
    end

    it "should encode Content-Disposition correct" do
      str = "Content-Disposition: inline\r\n"
      header = Mail::Header.new(str)
      header.encoded.should == str

      str = "Content-Disposition: attachment; filename=File\r\n"
      header = Mail::Header.new(str)
      header.encoded.should == str
    end
  end
  
  describe "detecting required fields" do
    it "should not say it has a message id if it doesn't" do
      Mail::Header.new.should_not be_has_message_id
    end

    it "should say it has a message id if it does" do
      Mail::Header.new('Message-ID: 1234').should be_has_message_id
    end

    it "should not say it has a date if it doesn't" do
      Mail::Header.new.should_not be_has_date
    end

    it "should say it has a date id if it does" do
      Mail::Header.new('Date: Mon, 24 Nov 1997 14:22:01 -0800').should be_has_date
    end

    it "should not say it has a mime-version if it doesn't" do
      Mail::Header.new.should_not be_has_mime_version
    end

    it "should say it has a date id if it does" do
      Mail::Header.new('Mime-Version: 1.0').should be_has_mime_version
    end
  end
  
  describe "mime version handling" do
    it "should return the mime version of the email" do
      header = Mail::Header.new("Mime-Version: 1.0")
      header['mime-version'].value.should == '1.0'
    end
    
    it "should return nil if no mime-version header field" do
      header = Mail::Header.new('To: bob')
      header['mime_version'].should == nil
    end
    
    it "should return the transfer-encoding of the email" do
      header = Mail::Header.new("Content-Transfer-Encoding: Base64")
      header['content-transfer-encoding'].value.should == 'Base64'
    end
    
    it "should return nil if no transfer-encoding header field" do
      header = Mail::Header.new
      header['content-transfer-encoding'].should == nil
    end
    
    it "should return the content-description of the email" do
      header = Mail::Header.new("Content-Description: This is a description")
      header['Content-Description'].value.should == 'This is a description'
    end
    
    it "should return nil if no content-description header field" do
      header = Mail::Header.new
      header['Content-Description'].should == nil
    end
    
  end

end
