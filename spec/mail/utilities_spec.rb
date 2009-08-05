require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

module Mail
  class TestCase
    include Mail::Utilities
  end
end

describe "Utilities Module" do

  it "should escape parens" do
    test = 'This is not (escaped)'
    result = 'This is not \(escaped\)'
    Mail::TestCase.new.send(:escape_paren, test).should == result
  end

  it "should not double escape parens" do
    test = 'This is not \(escaped\)'
    result = 'This is not \(escaped\)'
    Mail::TestCase.new.send(:escape_paren, test).should == result
  end

  it "should escape all parens" do
    test = 'This is not \()escaped(\)'
    result = 'This is not \(\)escaped\(\)'
    Mail::TestCase.new.send(:escape_paren, test).should == result
  end

end
