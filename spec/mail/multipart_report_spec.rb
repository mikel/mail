# encoding: utf-8
require 'spec_helper'

describe "multipart/report emails" do
  
  it "should know if it is a multipart report type" do
    mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
    expect(mail).to be_multipart_report
  end
  
  describe "delivery-status reports" do
    
    it "should know if it is a deliver-status report" do
      mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
      expect(mail).to be_delivery_status_report
    end

    it "should find its message/delivery-status part" do
      mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
      expect(mail.delivery_status_part).not_to be_nil
    end
    
    it "should handle a report that has a human readable message/delivery-status" do
      mail = Mail.read(fixture('emails', 'multipart_report_emails', 'multipart_report_multiple_status.eml'))
      expect(mail).to be_bounced
    end

    describe "multipart reports with more than one address" do
      it "should not crash" do
        mail1 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce1.eml'))
        mail2 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce2.eml'))
        expect(doing { mail1.bounced? }).not_to raise_error
        expect(doing { mail2.bounced? }).not_to raise_error
      end

      it "should not know that a multi address email was bounced" do
        mail1 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce1.eml'))
        mail2 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce2.eml'))
        expect(mail1).to be_bounced
        expect(mail2).to be_bounced
      end
    end

    describe "temporary failure" do
      
      before(:each) do
        @mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
      end
      
      it "should be bounced" do
        expect(@mail).not_to be_bounced
      end
      
      it "should say action 'delayed'" do
        expect(@mail.action).to eq 'delayed'
      end
      
      it "should give a final recipient" do
        expect(@mail.final_recipient).to eq 'RFC822; fraser@oooooooo.com.au'
      end
      
      it "should give an error code" do
        expect(@mail.error_status).to eq '4.2.2'
      end
      
      it "should give a diagostic code" do
        expect(@mail.diagnostic_code).to eq 'SMTP; 452 4.2.2 <fraser@oooooooo.com.au>... Mailbox full'
      end
      
      it "should give a remote-mta" do
        expect(@mail.remote_mta).to eq 'DNS; mail.oooooooo.com.au'
      end
      
      it "should be retryable" do
        expect(@mail).to be_retryable
      end
    end

    describe "permanent failure" do
      
      before(:each) do
        @mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_530.eml'))
      end
      
      it "should be bounced" do
        expect(@mail).to be_bounced
      end
      
      it "should say action 'failed'" do
        expect(@mail.action).to eq 'failed'
      end
      
      it "should give a final recipient" do
        expect(@mail.final_recipient).to eq 'RFC822; edwin@zzzzzzz.com'
      end
      
      it "should give an error code" do
        expect(@mail.error_status).to eq '5.3.0'
      end
      
      it "should give a diagostic code" do
        expect(@mail.diagnostic_code).to eq 'SMTP; 553 5.3.0 <edwin@zzzzzzz.com>... Unknown E-Mail Address'
      end
      
      it "should give a remote-mta" do
        expect(@mail.remote_mta).to eq 'DNS; mail.zzzzzz.com'
      end
      
      it "should be retryable" do
        expect(@mail).not_to be_retryable
      end
    end

  end

end

