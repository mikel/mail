require 'spec_helper'

describe Mail::DateTimeElement do

  it "should parse a date" do
    date_text  = 'Wed, 27 Apr 2005 14:15:31 -0700'
    doing { Mail::DateTimeElement.new(date_text) }.should_not raise_error
  end

  it "should raise an error if the input is useless" do
    date_text = nil
    doing { Mail::DateTimeElement.new(date_text) }.should raise_error
  end

  it "should raise an error if the input is useless" do
    date_text  = '""""""""""""""""'
    doing { Mail::DateTimeElement.new(date_text) }.should raise_error
  end
  
end
