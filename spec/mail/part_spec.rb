# frozen_string_literal: true
require 'spec_helper'

describe Mail::Part do

  it "should not add a default Content-ID" do
    part = Mail::Part.new
    part.to_s
    expect(part.content_id).to be_nil
  end

  it "should not add a default Content-ID to non-inline attachments" do
    part = Mail::Part.new(:content_disposition => 'attachment')
    part.to_s
    expect(part.content_id).to be_nil
  end

  it "should add a default Content-ID to inline attachments" do
    part = Mail::Part.new(:content_disposition => 'inline')
    part.to_s
    expect(part.content_id).not_to be_nil
  end

  it "should not add a Date, MIME-Version, or Message-ID" do
    part = Mail::Part.new
    part.to_s
    expect(part.date).to be_nil
    expect(part.mime_version).to be_nil
    expect(part.message_id).to be_nil
  end

  it "should preserve any content id that you put into it" do
    part = Mail::Part.new do
      content_id "<thisis@acontentid>"
      body "This is Text"
    end
    expect(part.content_id).to eq "<thisis@acontentid>"
  end
  
  it "should return an inline content_id" do
    part = Mail::Part.new do
      content_id "<thisis@acontentid>"
      body "This is Text"
    end
    expect(part.cid).to eq "thisis@acontentid"
    expect($stderr).to receive(:puts).with("Part#inline_content_id is deprecated, please call Part#cid instead")
    expect(part.inline_content_id).to eq "thisis@acontentid"
  end
  
  
  it "should URL escape its inline content_id" do
    part = Mail::Part.new do
      content_id "<thi%%sis@acontentid>"
      body "This is Text"
    end
    expect(part.cid).to eq "thi%25%25sis@acontentid"
    expect($stderr).to receive(:puts).with("Part#inline_content_id is deprecated, please call Part#cid instead")
    expect(part.inline_content_id).to eq "thi%25%25sis@acontentid"
  end
  
  it "should add a content_id if there is none and is asked for an inline_content_id" do
    part = Mail::Part.new
    expect(part.cid).not_to be_nil
    expect($stderr).to receive(:puts).with("Part#inline_content_id is deprecated, please call Part#cid instead")
    expect(part.inline_content_id).not_to be_nil
  end
  
  it "should respond correctly to inline?" do
    part = Mail::Part.new(:content_disposition => 'attachment')
    expect(part).not_to be_inline

    part = Mail::Part.new(:content_disposition => 'inline')
    expect(part).to be_inline
  end

  it "handles un-parsable content_disposition headers" do
    part = Mail::Part.new
    field = Mail::Field.new('content-disposition')
    field.field = Mail::UnstructuredField.new('content-disposition', 'failed to parse')
    part.header.fields << field
    expect(part).not_to be_inline
  end

  describe "parts that have a missing header" do
    it "should not try to init a header if there is none" do
      part =<<PARTEND

The original message was received at Mon, 24 Dec 2007 10:03:47 +1100
from 60-0-0-146.static.tttttt.com.au [60.0.0.146]

This message was generated by mail12.tttttt.com.au

   ----- The following addresses had permanent fatal errors -----
<edwin@zzzzzzz.com>
    (reason: 553 5.3.0 <edwin@zzzzzzz.com>... Unknown E-Mail Address)

   ----- Transcript of session follows -----
... while talking to mail.zzzzzz.com.:
>>> DATA
<<< 553 5.3.0 <edwin@zzzzzzz.com>... Unknown E-Mail Address
550 5.1.1 <edwin@zzzzzzz.com>... User unknown
<<< 503 5.0.0 Need RCPT (recipient)

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
PARTEND
      expect($stderr).not_to receive(:puts)
      Mail::Part.new(part)
    end
  end
  
  describe "delivery status reports" do
    before do
      @delivery_report = Mail::Part.new(Mail::Utilities.to_crlf(<<ENDPART))
Content-Type: message/delivery-status

Reporting-MTA: dns; mail12.rrrr.com.au
Received-From-MTA: DNS; 60-0-0-146.static.tttttt.com.au
Arrival-Date: Mon, 24 Dec 2007 10:03:47 +1100

Final-Recipient: RFC822; edwin@zzzzzzz.com
Action: failed
Status: 5.3.0
Remote-MTA: DNS; mail.zzzzzz.com
Diagnostic-Code: SMTP; 553 5.3.0 <edwin@zzzzzzz.com>... Unknown E-Mail Address
Last-Attempt-Date: Mon, 24 Dec 2007 10:03:53 +1100
ENDPART
    end

    it "should know if it is a delivery-status report" do
      expect(@delivery_report).to be_delivery_status_report_part
    end
    
    it "should create a delivery_status_data header object" do
      expect(@delivery_report.delivery_status_data).not_to be_nil
    end

    it "should be bounced" do
      expect(@delivery_report).to be_bounced
    end
    
    it "should say action 'delayed'" do
      expect(@delivery_report.action).to eq 'failed'
    end
    
    it "should give a final recipient" do
      expect(@delivery_report.final_recipient).to eq 'RFC822; edwin@zzzzzzz.com'
    end
    
    it "should give an error code" do
      expect(@delivery_report.error_status).to eq '5.3.0'
    end
    
    it "should give a diagostic code" do
      expect(@delivery_report.diagnostic_code).to eq 'SMTP; 553 5.3.0 <edwin@zzzzzzz.com>... Unknown E-Mail Address'
    end
    
    it "should give a remote-mta" do
      expect(@delivery_report.remote_mta).to eq 'DNS; mail.zzzzzz.com'
    end
    
    it "should be retryable" do
      expect(@delivery_report).not_to be_retryable
    end

    context "on a part without a certain field" do
      before(:each) do
        part =<<ENDPART
Content-Type: message/delivery-status

Reporting-MTA: dns; mail12.rrrr.com.au
Received-From-MTA: DNS; 60-0-0-146.static.tttttt.com.au
Arrival-Date: Mon, 24 Dec 2007 10:03:47 +1100

Final-Recipient: RFC822; edwin@zzzzzzz.com
Action: failed
Status: 5.3.0
Remote-MTA: DNS; mail.zzzzzz.com
Last-Attempt-Date: Mon, 24 Dec 2007 10:03:53 +1100
ENDPART
        @delivery_report = Mail::Part.new(part)
      end

      it "returns nil" do
        expect(@delivery_report.diagnostic_code).to be_nil
      end
    end
  end
  
  it "should correctly parse plain text raw source and not truncate after newlines - issue 208" do
    plain_text = "First Line\n\nSecond Line\n\nThird Line\n\n"
    #Note: trailing \n\n is stripped off by Mail::Part initialization
    part = Mail::Part.new(plain_text)
    expect(part[:content_type].content_type).to eq 'text/plain'
    expect(part.to_s).to match(/^First Line\r\n\r\nSecond Line\r\n\r\nThird Line/)
  end

  describe "negotiating transfer encoding" do
    it "doesn't override part encoding when it's compatible with message" do
      mail = Mail.new
      mail.body << Mail::Part.new.tap do |part|
        part.header[:content_disposition] = 'attachment; filename="unnamed"'
        part.content_type  = 'text/plain'
        # part.body          = 'a' * 998
        part.body          = 'a' * 999
        part.body.encoding = 'base64'
      end

      part_body_encoding = mail.to_s.scan(/Content-Transfer-Encoding: (.+)\r$/).last.first
      expect(part_body_encoding).to eq('base64')
    end

    it "retains specified encoding even though it isn't lowest cost" do
      part = Mail::Part.new.tap do |part|
        part.header[:content_disposition] = 'attachment; filename="unnamed"'
        part.content_type  = 'text/plain'
        # part.body          = 'a' * 998
        part.body          = 'a' * 999
        part.body.encoding = 'base64'
      end

      part_body_encoding = part.to_s.scan(/Content-Transfer-Encoding: (.+)\r$/).last.first
      expect(part_body_encoding).to eq('base64')
    end
  end
end
