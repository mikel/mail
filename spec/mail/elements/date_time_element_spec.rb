# frozen_string_literal: true
require 'spec_helper'

describe Mail::DateTimeElement do

  it "should parse a date" do
    date_text  = 'Wed, 27 Apr 2005 14:15:31 -0700'
    expect { Mail::DateTimeElement.new(date_text) }.not_to raise_error
  end

  it "should raise an error if the input is nil" do
    date_text = nil
    expect { Mail::DateTimeElement.new(date_text) }.to raise_error(Mail::Field::ParseError)
  end

  it "should raise an error if the input is useless" do
    date_text  = '""""""""""""""""'
    expect { Mail::DateTimeElement.new(date_text) }.to raise_error(Mail::Field::ParseError)
  end

end
