# encoding: utf-8
require 'spec_helper'

describe "Utilities Module" do

  include Mail::Utilities

  describe "token safe" do
    
    describe "checking" do
      it "should return true if a string is token safe" do
        token_safe?('.abc').should be_true
      end

      it "should return false if a string is token safe" do
        token_safe?('?=abc').should be_false
      end

      it "should work with mb_chars" do
        token_safe?('.abc'.mb_chars).should be_true
        token_safe?('?=abc'.mb_chars).should be_false
      end
    end

    describe "quoting" do
      it "should return true if a string is token safe" do
        quote_token('.abc').should == '.abc'
      end

      it "should return false if a string is token safe" do
        quote_token('?=abc').should == '"?=abc"'
      end

      it "should work with mb_chars" do
        quote_token('.abc'.mb_chars).should == '.abc'
        quote_token('?=abc'.mb_chars).should == '"?=abc"'
      end
    end

  end

  describe "atom safe" do
    
    describe "checking" do
      it "should return true if a string is token safe" do
        atom_safe?('?=abc').should be_true
      end

      it "should return false if a string is token safe" do
        atom_safe?('.abc').should be_false
      end

      it "should work with mb_chars" do
        atom_safe?('?=abc'.mb_chars).should be_true
        atom_safe?('.abc'.mb_chars).should be_false
      end
    end

    describe "quoting" do
      it "should return true if a string is token safe" do
        quote_atom('?=abc').should == '?=abc'
      end

      it "should return false if a string is token safe" do
        quote_atom('.abc').should == '".abc"'
      end

      it "should work with mb_chars" do
        quote_atom('?=abc'.mb_chars).should == '?=abc'
        quote_atom('.abc'.mb_chars).should == '".abc"'
      end

      it "should work with mb_chars" do
        quote_atom('?=abc'.mb_chars).should == '?=abc'
        quote_atom('.abc'.mb_chars).should == '".abc"'
      end
      
      it "should quote white space" do
        quote_atom('ab abc'.mb_chars).should == '"ab abc"'
        quote_atom("a\sb\ta\r\nbc".mb_chars).should == %{"a\sb\ta\r\nbc"}
      end
    end

  end

  describe "escaping parenthesies" do
    it "should escape parens" do
      test = 'This is not (escaped)'
      result = 'This is not \(escaped\)'
      escape_paren(test).should == result
    end

    it "should not double escape parens" do
      test = 'This is not \(escaped\)'
      result = 'This is not \(escaped\)'
      escape_paren(test).should == result
    end

    it "should escape all parens" do
      test = 'This is not \()escaped(\)'
      result = 'This is not \(\)escaped\(\)'
      escape_paren(test).should == result
    end
    
  end
  
  describe "unescaping parenthesis" do

    it "should work" do
      test = '(This is a string)'
      result = 'This is a string'
      unparen(test).should == result
    end

    it "should work without parens" do
      test = 'This is a string'
      result = 'This is a string'
      unparen(test).should == result
    end

    it "should work using ActiveSupport mb_chars" do
      test = '(This is a string)'.mb_chars
      result = 'This is a string'
      unparen(test).should == result
    end

    it "should work without parens using ActiveSupport mb_chars" do
      test = 'This is a string'.mb_chars
      result = 'This is a string'
      unparen(test).should == result
    end

  end
  
  describe "unescaping brackets" do

    it "should work" do
      test = '<This is a string>'
      result = 'This is a string'
      unbracket(test).should == result
    end

    it "should work without brackets" do
      test = 'This is a string'
      result = 'This is a string'
      unbracket(test).should == result
    end

    it "should work using ActiveSupport mb_chars" do
      test = '<This is a string>'.mb_chars
      result = 'This is a string'
      unbracket(test).should == result
    end

    it "should work without parens using ActiveSupport mb_chars" do
      test = 'This is a string'.mb_chars
      result = 'This is a string'
      unbracket(test).should == result
    end

  end
  
  describe "quoting phrases" do
    it "should quote a phrase if it is unsafe" do
      test = 'this.needs quoting'
      result = '"this.needs quoting"'
      dquote(test).should == result
    end

    it "should properly quote a string, even if quoted but not escaped properly" do
      test = '"this needs "escaping"'
      result = '"this needs \"escaping"'
      dquote(test).should == result
    end
    
    it "should quote correctly a phrase with an escaped quote in it" do
      test = 'this needs \"quoting'
      result = '"this needs \"quoting"'
      dquote(test).should == result
    end
    
    it "should quote correctly a phrase with an escaped backslash followed by an escaped quote in it" do
      test = 'this needs \\\"quoting'
      result = '"this needs \\\"quoting"'
      dquote(test).should == result
    end
  end
  
  
  describe "parenthesizing phrases" do
    it "should parenthesize a phrase" do
      test = 'this.needs parenthesizing'
      result = '(this.needs parenthesizing)'
      paren(test).should == result
    end

    it "should properly parenthesize a string, and escape properly" do
      test = 'this needs (escaping'
      result = '(this needs \(escaping)'
      paren(test).should == result
    end

    it "should properly parenthesize a string, and escape properly (other way)" do
      test = 'this needs )escaping'
      result = '(this needs \)escaping)'
      paren(test).should == result
    end

    it "should properly parenthesize a string, even if parenthesized but not escaped properly" do
      test = '(this needs (escaping)'
      result = '(this needs \(escaping)'
      paren(test).should == result
    end

    it "should properly parenthesize a string, even if parenthesized but not escaped properly (other way)" do
      test = '(this needs )escaping)'
      result = '(this needs \)escaping)'
      paren(test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped parentheses in it" do
      test = 'this needs \(parenthesizing'
      result = '(this needs \(parenthesizing)'
      paren(test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped parentheses in it (other way)" do
      test = 'this needs \)parenthesizing'
      result = '(this needs \)parenthesizing)'
      paren(test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped backslash followed by an escaped parentheses in it" do
      test = 'this needs \\\(parenthesizing'
      result = '(this needs \\\(parenthesizing)'
      paren(test).should == result
    end
    
    it "should parenthesize correctly a phrase with an escaped backslash followed by an escaped parentheses in it (other way)" do
      test = 'this needs \\\)parenthesizing'
      result = '(this needs \\\)parenthesizing)'
      paren(test).should == result
    end

    it "should parenthesize correctly a phrase with a set of parentheses" do
      test = 'this (needs) parenthesizing'
      result = '(this \(needs\) parenthesizing)'
      paren(test).should == result
    end
    
  end
  
  
  describe "bracketizing phrases" do
    it "should bracketize a phrase" do
      test = 'this.needs bracketizing'
      result = '<this.needs bracketizing>'
      bracket(test).should == result
    end

    it "should properly bracketize a string, and escape properly" do
      test = 'this needs <escaping'
      result = '<this needs \<escaping>'
      bracket(test).should == result
    end

    it "should properly bracketize a string, and escape properly (other way)" do
      test = 'this needs >escaping'
      result = '<this needs \>escaping>'
      bracket(test).should == result
    end

    it "should properly bracketize a string, even if bracketized but not escaped properly" do
      test = '<this needs <escaping>'
      result = '<this needs \<escaping>'
      bracket(test).should == result
    end

    it "should properly bracketize a string, even if bracketized but not escaped properly (other way)" do
      test = '<this needs >escaping>'
      result = '<this needs \>escaping>'
      bracket(test).should == result
    end
    
    it "should bracketize correctly a phrase with an escaped brackets in it" do
      test = 'this needs \<bracketizing'
      result = '<this needs \<bracketizing>'
      bracket(test).should == result
    end
    
    it "should bracketize correctly a phrase with an escaped brackets in it (other way)" do
      test = 'this needs \>bracketizing'
      result = '<this needs \>bracketizing>'
      bracket(test).should == result
    end
    
    it "should bracketize correctly a phrase with an escaped backslash followed by an escaped brackets in it" do
      test = 'this needs \\\<bracketizing'
      result = '<this needs \\\<bracketizing>'
      bracket(test).should == result
    end
    
    it "should bracketize correctly a phrase with an escaped backslash followed by an escaped brackets in it (other way)" do
      test = 'this needs \\\>bracketizing'
      result = '<this needs \\\>bracketizing>'
      bracket(test).should == result
    end

    it "should bracketize correctly a phrase with a set of brackets" do
      test = 'this <needs> bracketizing'
      result = '<this \<needs\> bracketizing>'
      bracket(test).should == result
    end
    
  end

  describe "url escaping" do
    it "should have a wrapper on URI.escape" do
      uri_escape("@?@!").should == URI.escape("@?@!")
    end

    it "should have a wrapper on URI.unescape" do
      uri_parser = URI.const_defined?(:Parser) ? URI::Parser.new : URI
      uri_unescape("@?@!").should == uri_parser.unescape("@?@!")
    end
  end
  
end
