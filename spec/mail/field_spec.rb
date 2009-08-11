# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Field do

  describe "initialization" do
    
    it "should be instantiated" do
      doing {Mail::Field.new('To: Mikel')}.should_not raise_error
    end
    
    it "should match up fields to class names" do
      structured_fields = %w[ Date From Sender Reply-To To Cc Bcc Message-ID In-Reply-To
                              References Keywords Resent-Date Resent-From Resent-Sender
                              Resent-To Resent-Cc Resent-Bcc Resent-Message-ID
                              Return-Path Received Subject Comments Mime-Version
                              Content-Transfer-Encoding ]
      structured_fields.each do |sf|
        words = sf.split("-").map { |a| a.capitalize }
        klass = "#{words.join}Field"
        Mail::Field.new("#{sf}: Value").field.class.should == Mail.const_get(klass)
      end
    end
    
    it "should match up fields to class names regardless of case" do
      structured_fields = %w[ dATE fROM sENDER REPLY-TO TO CC BCC MESSAGE-ID IN-REPLY-TO
                              REFERENCES KEYWORDS resent-date resent-from rESENT-sENDER
                              rESENT-tO rESent-cc resent-bcc reSent-MESSAGE-iD 
                              rEtURN-pAtH rEcEiVeD Subject Comments Mime-VeRSIOn 
                              cOntenT-transfer-EnCoDiNg]
      structured_fields.each do |sf|
        words = sf.split("-").map { |a| a.capitalize }
        klass = "#{words.join}Field"
        Mail::Field.new("#{sf}: Value").field.class.should == Mail.const_get(klass)
      end
    end
    
    it "should say anything that is not a known field is an optional field" do
      unstructured_fields = %w[ Too Becc bccc Random X-Mail MySpecialField ]
      unstructured_fields.each do |sf|
        Mail::Field.new("#{sf}: Value").field.class.should == Mail::OptionalField
      end
    end
    
    it "should split the name and values out of the raw field passed in" do
      field = Mail::Field.new('To: Bob')
      field.name.should == 'To'
      field.value.should == 'Bob'
    end
    
    it "should split the name and values out of the raw field passed in if missing whitespace" do
      field = Mail::Field.new('To:Bob')
      field.name.should == 'To'
      field.value.should == 'Bob'
    end
    
    it "should return an unstuctured field if the structured field parsing raises an error" do
      Mail::ToField.should_receive(:new).and_raise(Mail::Field::ParseError)
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

    it "should pass missing methods to it's instantiated field class" do
      field = Mail::Field.new('To: Bob')
      field.field.should_receive(:addresses).once
      field.addresses
    end

    it "should change it's type if you change the name" do
      field = Mail::Field.new("To: mikel@me.com")
      field.field.class.should == Mail::ToField
      field.value = "bob@me.com"
      field.field.class.should == Mail::ToField
    end
    
    it "should create a field without trying to parse if given a symbol" do
      field = Mail::Field.new('Message-ID')
      field.field.class.should == Mail::MessageIdField
    end

  end

  describe "helper methods" do
    it "should reply if it is responsible for a field name as a capitalized string - structured field" do
      field = Mail::Field.new("To: mikel@test.lindsaar.net")
      field.responsible_for?("To").should be_true
    end

    it "should reply if it is responsible for a field as a lower case string - structured field" do
      field = Mail::Field.new("To: mikel@test.lindsaar.net")
      field.responsible_for?("to").should be_true
    end

    it "should reply if it is responsible for a field as a symbol - structured field" do
      field = Mail::Field.new("To: mikel@test.lindsaar.net")
      field.responsible_for?(:to).should be_true
    end

    it "should say it is == to another if their field names match" do
      Mail::Field.new("To: mikel").same(Mail::Field.new("To: bob")).should be_true
    end

    it "should say it is not == to another if their field names do not match" do
      Mail::Field.new("From: mikel").should_not == Mail::Field.new("To: bob")
    end

    it "should sort according to the field order" do
      list = [Mail::Field.new("To: mikel"), Mail::Field.new("Return-Path: bob")]
      list.sort[0].name.should == "Return-Path"
    end

  end

end