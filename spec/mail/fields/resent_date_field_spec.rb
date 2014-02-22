# encoding: utf-8
require 'spec_helper'

describe Mail::ResentDateField do
  it "should initialize" do
    expect(doing { Mail::ResentDateField.new("12 Aug 2009 00:00:02 GMT") }).not_to raise_error
  end
  
  it "should be able to tell the time" do
    expect(Mail::ResentDateField.new("12 Aug 2009 00:00:02 GMT").date_time.class).to eq DateTime
  end
  
  it "should mix in the CommonAddress module" do
    expect(Mail::ResentDateField.included_modules).to include(Mail::CommonDate) 
  end

  it "should accept a string with the field name" do
    t = Mail::ResentDateField.new('Resent-Date: 12 Aug 2009 00:00:02 GMT')
    expect(t.name).to eq 'Resent-Date'
    expect(t.value).to eq 'Wed, 12 Aug 2009 00:00:02 +0000'
    expect(t.date_time).to eq ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end
  
  it "should accept a string without the field name" do
    t = Mail::ResentDateField.new('12 Aug 2009 00:00:02 GMT')
    expect(t.name).to eq 'Resent-Date'
    expect(t.value).to eq 'Wed, 12 Aug 2009 00:00:02 +0000'
    expect(t.date_time).to eq ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
  end
  
  it "should give today's date if no date is specified" do
    now = Time.now
    allow(Time).to receive(:now).and_return(now)
    t = Mail::ResentDateField.new
    expect(t.name).to eq 'Resent-Date'
    expect(t.date_time).to eq ::DateTime.parse(now.to_s)
  end

end
