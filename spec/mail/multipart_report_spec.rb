# encoding: utf-8
require 'spec_helper'

describe "multipart/report emails" do
  
  it "should know if it is a multipart report type" do
    mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
    mail.should be_multipart_report
  end
  
  describe "delivery-status reports" do
    
    it "should know if it is a deliver-status report" do
      mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
      mail.should be_delivery_status_report
    end

    it "should find it's message/delivery-status part" do
      mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
      mail.delivery_status_part.should_not be_nil
    end
    
    it "should handle a report that has a human readable message/delivery-status" do
      mail = Mail.read(fixture('emails', 'multipart_report_emails', 'multipart_report_multiple_status.eml'))
      mail.should be_bounced
    end

    describe "multipart reports with more than one address" do
      it "should not crash" do
        mail1 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce1.eml'))
        mail2 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce2.eml'))
        doing { mail1.bounced? }.should_not raise_error
        doing { mail2.bounced? }.should_not raise_error
      end

      it "should not know that a multi address email was bounced" do
        mail1 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce1.eml'))
        mail2 = Mail.read(fixture('emails', 'multipart_report_emails', 'multi_address_bounce2.eml'))
        mail1.should be_bounced
        mail2.should be_bounced
      end
    end

    describe "temporary failure" do
      
      before(:each) do
        @mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_422.eml'))
      end
      
      it "should be bounced" do
        @mail.should_not be_bounced
      end
      
      it "should say action 'delayed'" do
        @mail.action.should == 'delayed'
      end
      
      it "should give a final recipient" do
        @mail.final_recipient.should == 'RFC822; fraser@oooooooo.com.au'
      end
      
      it "should give an error code" do
        @mail.error_status.should == '4.2.2'
      end
      
      it "should give a diagostic code" do
        @mail.diagnostic_code.should == 'SMTP; 452 4.2.2 <fraser@oooooooo.com.au>... Mailbox full'
      end
      
      it "should give a remote-mta" do
        @mail.remote_mta.should == 'DNS; mail.oooooooo.com.au'
      end
      
      it "should be retryable" do
        @mail.should be_retryable
      end
    end

    describe "permanent failure" do
      
      before(:each) do
        @mail = Mail.read(fixture('emails', 'multipart_report_emails', 'report_530.eml'))
      end
      
      it "should be bounced" do
        @mail.should be_bounced
      end
      
      it "should say action 'failed'" do
        @mail.action.should == 'failed'
      end
      
      it "should give a final recipient" do
        @mail.final_recipient.should == 'RFC822; edwin@zzzzzzz.com'
      end
      
      it "should give an error code" do
        @mail.error_status.should == '5.3.0'
      end
      
      it "should give a diagostic code" do
        @mail.diagnostic_code.should == 'SMTP; 553 5.3.0 <edwin@zzzzzzz.com>... Unknown E-Mail Address'
      end
      
      it "should give a remote-mta" do
        @mail.remote_mta.should == 'DNS; mail.zzzzzz.com'
      end
      
      it "should be retryable" do
        @mail.should_not be_retryable
      end
    end

  end

end

