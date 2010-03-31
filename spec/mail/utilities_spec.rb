# encoding: utf-8
require 'spec_helper'

module Mail
  class TestCase
    include Mail::Utilities
  end
end

describe "Utilities Module" do

  describe "escaping parenthesies" do
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
  
  describe "unescaping parenthesis" do

    it "should work" do
      test = '(This is a string)'
      result = 'This is a string'
      Mail::TestCase.new.send(:unparen, test).should == result
    end

    it "should work without parens" do
      test = 'This is a string'
      result = 'This is a string'
      Mail::TestCase.new.send(:unparen, test).should == result
    end

    it "should work using ActiveSupport mb_chars" do
      test = '(This is a string)'.mb_chars
      result = 'This is a string'
      Mail::TestCase.new.send(:unparen, test).should == result
    end

    it "should work without parens using ActiveSupport mb_chars" do
      test = 'This is a string'.mb_chars
      result = 'This is a string'
      Mail::TestCase.new.send(:unparen, test).should == result
    end

  end
  
  describe "quoting phrases" do
    it "should quote a phrase if it is unsafe" do
      test = 'this.needs quoting'
      result = '"this.needs quoting"'
      Mail::TestCase.new.send(:dquote, test).should == result
    end

    it "should properly quote a string, even if quoted but not escaped properly" do
      test = '"this needs "escaping"'
      result = '"this needs \"escaping"'
      Mail::TestCase.new.send(:dquote, test).should == result
    end
    
    it "should quote correctly a phrase with an escaped quote in it" do
      test = 'this needs \"quoting'
      result = '"this needs \"quoting"'
      Mail::TestCase.new.send(:dquote, test).should == result
    end
    
    it "should quote correctly a phrase with an escaped backslash followed by an escaped quote in it" do
      test = 'this needs \\\"quoting'
      result = '"this needs \\\"quoting"'
      Mail::TestCase.new.send(:dquote, test).should == result
    end
  end
  
  
  describe "parenthesizing phrases" do
    it "should parenthesize a phrase" do
      test = 'this.needs parenthesizing'
      result = '(this.needs parenthesizing)'
      Mail::TestCase.new.send(:paren, test).should == result
    end

    it "should properly parenthesize a string, and escape properly" do
      test = 'this needs (escaping'
      result = '(this needs \(escaping)'
      Mail::TestCase.new.send(:paren, test).should == result
    end

    it "should properly parenthesize a string, and escape properly (other way)" do
      test = 'this needs )escaping'
      result = '(this needs \)escaping)'
      Mail::TestCase.new.send(:paren, test).should == result
    end

    it "should properly parenthesize a string, even if parenthesized but not escaped properly" do
      test = '(this needs (escaping)'
      result = '(this needs \(escaping)'
      Mail::TestCase.new.send(:paren, test).should == result
    end

    it "should properly parenthesize a string, even if parenthesized but not escaped properly (other way)" do
      test = '(this needs )escaping)'
      result = '(this needs \)escaping)'
      Mail::TestCase.new.send(:paren, test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped parentheses in it" do
      test = 'this needs \(parenthesizing'
      result = '(this needs \(parenthesizing)'
      Mail::TestCase.new.send(:paren, test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped parentheses in it (other way)" do
      test = 'this needs \)parenthesizing'
      result = '(this needs \)parenthesizing)'
      Mail::TestCase.new.send(:paren, test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped backslash followed by an escaped parentheses in it" do
      test = 'this needs \\\(parenthesizing'
      result = '(this needs \\\(parenthesizing)'
      Mail::TestCase.new.send(:paren, test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped backslash followed by an escaped parentheses in it (other way)" do
      test = 'this needs \\\)parenthesizing'
      result = '(this needs \\\)parenthesizing)'
      Mail::TestCase.new.send(:paren, test).should == result
    end

    it "should parenthesize correctly a phrase with a set of parentheses" do
      test = 'this (needs) parenthesizing'
      result = '(this \(needs\) parenthesizing)'
      Mail::TestCase.new.send(:paren, test).should == result
    end
    
  end
  
end
