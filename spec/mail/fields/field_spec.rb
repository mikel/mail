require File.dirname(__FILE__) + '/../../spec_helper'

# encoding: ASCII-8BIT
require 'mail'

describe Mail::Field do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Field.new('To: Mikel')}.should_not raise_error
    end
    
    it "should know which fields are structured" do
      structured_fields = %w[ Date From Sender Reply-To To Cc Bcc Message-ID In-Reply-To
                              References Keywords Resent-Date Resent-From Resent-Sender
                              Resent-To Resent-Cc Resent-Bcc Resent-Message-ID 
                              Return-Path Received ]
      structured_fields.each do |sf|
        Mail::Field.new("#{sf}: Value").field.class.should == Mail::StructuredField
      end
    end
    
    it "should know which fields are structured regardless of case" do
      structured_fields = %w[ dATE fROM sENDER REPLY-TO TO CC BCC MESSAGE-ID IN-REPLY-TO
                              REFERENCES KEYWORDS resent-date resent-from rESENT-sENDER
                              rESENT-tO rESent-cc resent-bcc resENT-mESSAGE-id 
                              rEtURN-pAtH rEcEiVeD ]
      structured_fields.each do |sf|
        Mail::Field.new("#{sf}: Value").field.class.should == Mail::StructuredField
      end
    end
    
    it "should say anything that is not a structured field is an unstructured field" do
      unstructured_fields = %w[ Subject Comments Random X-Mail MySpecialField ]
      unstructured_fields.each do |sf|
        Mail::Field.new("#{sf}: Value").field.class.should == Mail::UnstructuredField
      end
    end
    
    it "should split the name and values out of the raw field passed in" do
      field = Mail::Field.new('To: Bob')
      field.name.should == 'To'
      field.value.should == 'Bob'
    end
    
    it "should return an unstuctured field if the structured field parsing raises an error" do
      Mail::StructuredField.should_receive(:new).and_raise(Mail::Field::ParseError)
      field = Mail::Field.new('To: Bob, ,,, Frank, Smith')
      field.field.class.should == Mail::UnstructuredField
      field.name.should == 'To'
      field.value.should == 'Bob, ,,, Frank, Smith'
    end
    
    it "should call to_s on it's field when sent to_s" do
      @field_type = Mail::UnstructuredField
      @field_type.should_receive(:to_s)
      Mail::UnstructuredField.should_receive(:new).and_return(@field_type)
      Mail::Field.new('Subject: Hello bob').to_s
    end
    
  end



end