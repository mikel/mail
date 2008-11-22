require File.dirname(__FILE__) + '/../../spec_helper'

# encoding: ASCII-8BIT
require 'mail'

describe Mail::Field do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Field.new('field-name')}.should_not raise_error
    end
    
    it "should know which fields are structured" do
      structured_fields = %w[ Date From Sender Reply-To To Cc Bcc Message-ID In-Reply-To
                              References Keywords Resent-Date Resent-From Resent-Sender
                              Resent-To Resent-Cc Resent-Bcc Resent-Message-ID 
                              Return-Path Received ]
      structured_fields.each do |sf|
        Mail::Field.new(sf).class.should == Mail::StructuredField
      end
    end
    
    it "should know which fields are structured regardless of case" do
      structured_fields = %w[ dATE fROM sENDER REPLY-TO TO CC BCC MESSAGE-ID IN-REPLY-TO
                              REFERENCES KEYWORDS resent-date resent-from rESENT-sENDER
                              rESENT-tO rESent-cc resent-bcc resENT-mESSAGE-id 
                              rEtURN-pAtH rEcEiVeD ]
      structured_fields.each do |sf|
        Mail::Field.new(sf).class.should == Mail::StructuredField
      end
    end
    
    it "should say anything that is not a structured field is an unstructured field" do
      unstructured_fields = %[ Subject Comments Random X-Mail ]
      unstructured_fields.each do |sf|
        Mail::Field.new(sf).class.should == Mail::UnstructuredField
      end
    end
    
  end

end