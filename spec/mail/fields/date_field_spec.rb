# encoding: utf-8
require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::DateField do

  it "should initialize" do
    doing { Mail::DateField.new("12 Aug 2009 00:00:02 GMT") }.should_not raise_error
  end

  it "should be able to tell the time" do
    Mail::DateField.new("12 Aug 2009 00:00:02 GMT").date_time.class.should == DateTime
  end
  
  it "should mix in the CommonAddress module" do
    Mail::DateField.included_modules.should include(Mail::CommonDate::InstanceMethods) 
  end

  it "should accept two strings with the field separate" do
    t = Mail::DateField.new('Date', '12 Aug 2009 00:00:02 GMT')
    t.name.should == 'Date'
    t.value.should == '12 Aug 2009 00:00:02 GMT'
    t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end

  it "should accept a string with the field name" do
    t = Mail::DateField.new('Date: 12 Aug 2009 00:00:02 GMT')
    t.name.should == 'Date'
    t.value.should == '12 Aug 2009 00:00:02 GMT'
    t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end
  
  it "should accept a string without the field name" do
    t = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
    t.name.should == 'Date'
    t.value.should == '12 Aug 2009 00:00:02 GMT'
    t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end

end
