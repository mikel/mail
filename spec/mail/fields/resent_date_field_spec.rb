# encoding: utf-8
require 'spec_helper'

describe Mail::ResentDateField do
  it "should initialize" do
    doing { Mail::ResentDateField.new("12 Aug 2009 00:00:02 GMT") }.should_not raise_error
  end
  
  it "should be able to tell the time" do
    Mail::ResentDateField.new("12 Aug 2009 00:00:02 GMT").date_time.class.should == DateTime
  end
  
  it "should mix in the CommonAddress module" do
    Mail::ResentDateField.included_modules.should include(Mail::CommonDate) 
  end

  it "should accept a string with the field name" do
    t = Mail::ResentDateField.new('Resent-Date: 12 Aug 2009 00:00:02 GMT')
    t.name.should == 'Resent-Date'
    t.value.should == 'Wed, 12 Aug 2009 00:00:02 +0000'
    t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end
  
  it "should accept a string without the field name" do
    t = Mail::ResentDateField.new('12 Aug 2009 00:00:02 GMT')
    t.name.should == 'Resent-Date'
    t.value.should == 'Wed, 12 Aug 2009 00:00:02 +0000'
    t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end
  
  it "should give today's date if no date is specified" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    t = Mail::ResentDateField.new
    t.name.should == 'Resent-Date'
    t.date_time.should == ::DateTime.parse(now.to_s)
  end

end
