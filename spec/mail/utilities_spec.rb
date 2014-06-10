# encoding: utf-8
require 'spec_helper'

describe "Utilities Module" do

  include Mail::Utilities

  describe "token safe" do
    
    describe "checking" do
      it "should return true if a string is token safe" do
        expect(token_safe?('.abc')).to be_truthy
      end

      it "should return false if a string is token safe" do
        expect(token_safe?('?=abc')).to be_falsey
      end

      it "should work with mb_chars" do
        expect(token_safe?('.abc'.mb_chars)).to be_truthy
        expect(token_safe?('?=abc'.mb_chars)).to be_falsey
      end
    end

    describe "quoting" do
      it "should return true if a string is token safe" do
        expect(quote_token('.abc')).to eq '.abc'
      end

      it "should return false if a string is token safe" do
        expect(quote_token('?=abc')).to eq '"?=abc"'
      end

      it "should work with mb_chars" do
        expect(quote_token('.abc'.mb_chars)).to eq '.abc'
        expect(quote_token('?=abc'.mb_chars)).to eq '"?=abc"'
      end
    end

  end

  describe "atom safe" do
    
    describe "checking" do
      it "should return true if a string is token safe" do
        expect(atom_safe?('?=abc')).to be_truthy
      end

      it "should return false if a string is token safe" do
        expect(atom_safe?('.abc')).to be_falsey
      end

      it "should work with mb_chars" do
        expect(atom_safe?('?=abc'.mb_chars)).to be_truthy
        expect(atom_safe?('.abc'.mb_chars)).to be_falsey
      end
    end

    describe "quoting" do
      it "should return true if a string is token safe" do
        expect(quote_atom('?=abc')).to eq '?=abc'
      end

      it "should return false if a string is token safe" do
        expect(quote_atom('.abc')).to eq '".abc"'
      end

      it "should work with mb_chars" do
        expect(quote_atom('?=abc'.mb_chars)).to eq '?=abc'
        expect(quote_atom('.abc'.mb_chars)).to eq '".abc"'
      end

      it "should work with mb_chars" do
        expect(quote_atom('?=abc'.mb_chars)).to eq '?=abc'
        expect(quote_atom('.abc'.mb_chars)).to eq '".abc"'
      end
      
      it "should quote white space" do
        expect(quote_atom('ab abc'.mb_chars)).to eq '"ab abc"'
        expect(quote_atom("a\sb\ta\r\nbc".mb_chars)).to eq %{"a\sb\ta\r\nbc"}
      end
    end

  end

  if RUBY_VERSION >= '1.9'
    describe "quoting phrases" do
      describe "given a non-unsafe string" do
        it "should not change the encoding" do
          input_str = "blargh"
          input_str_encoding = input_str.encoding

          quote_phrase(input_str)

          expect(input_str.encoding).to eq input_str_encoding
        end
      end

      describe "given an unsafe string" do
        it "should not change the encoding" do
          input_str = "Bjørn"
          input_str_encoding = input_str.encoding

          quote_phrase(input_str)

          expect(input_str.encoding).to eq input_str_encoding
        end
      end
    end
  end

  describe "escaping parenthesies" do
    it "should escape parens" do
      test = 'This is not (escaped)'
      result = 'This is not \(escaped\)'
      expect(escape_paren(test)).to eq result
    end

    it "should not double escape parens" do
      test = 'This is not \(escaped\)'
      result = 'This is not \(escaped\)'
      expect(escape_paren(test)).to eq result
    end

    it "should escape all parens" do
      test = 'This is not \()escaped(\)'
      result = 'This is not \(\)escaped\(\)'
      expect(escape_paren(test)).to eq result
    end
    
  end
  
  describe "unescaping parenthesis" do

    it "should work" do
      test = '(This is a string)'
      result = 'This is a string'
      expect(unparen(test)).to eq result
    end

    it "should work without parens" do
      test = 'This is a string'
      result = 'This is a string'
      expect(unparen(test)).to eq result
    end

    it "should work using ActiveSupport mb_chars" do
      test = '(This is a string)'.mb_chars
      result = 'This is a string'
      expect(unparen(test)).to eq result
    end

    it "should work without parens using ActiveSupport mb_chars" do
      test = 'This is a string'.mb_chars
      result = 'This is a string'
      expect(unparen(test)).to eq result
    end

  end
  
  describe "unescaping brackets" do

    it "should work" do
      test = '<This is a string>'
      result = 'This is a string'
      expect(unbracket(test)).to eq result
    end

    it "should work without brackets" do
      test = 'This is a string'
      result = 'This is a string'
      expect(unbracket(test)).to eq result
    end

    it "should work using ActiveSupport mb_chars" do
      test = '<This is a string>'.mb_chars
      result = 'This is a string'
      expect(unbracket(test)).to eq result
    end

    it "should work without parens using ActiveSupport mb_chars" do
      test = 'This is a string'.mb_chars
      result = 'This is a string'
      expect(unbracket(test)).to eq(result)
    end

  end
  
  describe "quoting phrases" do
    it "should quote a phrase if it is unsafe" do
      test = 'this.needs quoting'
      result = '"this.needs quoting"'
      expect(dquote(test)).to eq result
    end

    it "should properly quote a string, even if quoted but not escaped properly" do
      test = '"this needs "escaping"'
      result = '"this needs \"escaping"'
      expect(dquote(test)).to eq result
    end
    
    it "should quote correctly a phrase with an escaped quote in it" do
      test = 'this needs \"quoting'
      result = '"this needs \\\\\\"quoting"'
      expect(dquote(test)).to eq result
    end
    
    it "should quote correctly a phrase with an escaped backslash followed by an escaped quote in it" do
      test = 'this needs \\\"quoting'
      result = '"this needs \\\\\\\\\\"quoting"'
      expect(dquote(test)).to eq result
    end
  end

  describe "unquoting phrases" do
    it "should remove quotes from the edge" do
      expect(unquote('"This is quoted"')).to eq 'This is quoted'
    end

    it "should remove backslash escaping from quotes" do
      expect(unquote('"This is \\"quoted\\""')).to eq 'This is "quoted"'
    end

    it "should remove backslash escaping from any char" do
      expect(unquote('"This is \\quoted"')).to eq 'This is quoted'
    end

    it "should be able to handle unquoted strings" do
      expect(unquote('This is not quoted')).to eq 'This is not quoted'
    end

    it "should preserve backslashes in unquoted strings" do
      expect(unquote('This is not \"quoted')).to eq 'This is not \"quoted'
    end

    it "should be able to handle unquoted quotes" do
      expect(unquote('"This is "quoted"')).to eq 'This is "quoted'
    end
  end
  
  
  describe "parenthesizing phrases" do
    it "should parenthesize a phrase" do
      test = 'this.needs parenthesizing'
      result = '(this.needs parenthesizing)'
      expect(paren(test)).to eq result
    end

    it "should properly parenthesize a string, and escape properly" do
      test = 'this needs (escaping'
      result = '(this needs \(escaping)'
      expect(paren(test)).to eq result
    end

    it "should properly parenthesize a string, and escape properly (other way)" do
      test = 'this needs )escaping'
      result = '(this needs \)escaping)'
      expect(paren(test)).to eq result
    end

    it "should properly parenthesize a string, even if parenthesized but not escaped properly" do
      test = '(this needs (escaping)'
      result = '(this needs \(escaping)'
      expect(paren(test)).to eq result
    end

    it "should properly parenthesize a string, even if parenthesized but not escaped properly (other way)" do
      test = '(this needs )escaping)'
      result = '(this needs \)escaping)'
      expect(paren(test)).to eq result
    end
    
    it "should parenthesize correctly a phrase with an escaped parentheses in it" do
      test = 'this needs \(parenthesizing'
      result = '(this needs \(parenthesizing)'
      expect(paren(test)).to eq result
    end
    
    it "should parenthesize correctly a phrase with an escaped parentheses in it (other way)" do
      test = 'this needs \)parenthesizing'
      result = '(this needs \)parenthesizing)'
      expect(paren(test)).to eq result
    end
    
    it "should parenthesize correctly a phrase with an escaped backslash followed by an escaped parentheses in it" do
      test = 'this needs \\\(parenthesizing'
      result = '(this needs \\\(parenthesizing)'
      expect(paren(test)).to eq result
    end
    
    it "should parenthesize correctly a phrase with an escaped backslash followed by an escaped parentheses in it (other way)" do
      test = 'this needs \\\)parenthesizing'
      result = '(this needs \\\)parenthesizing)'
      expect(paren(test)).to eq result
    end

    it "should parenthesize correctly a phrase with a set of parentheses" do
      test = 'this (needs) parenthesizing'
      result = '(this \(needs\) parenthesizing)'
      expect(paren(test)).to eq result
    end
    
  end
  
  
  describe "bracketizing phrases" do
    it "should bracketize a phrase" do
      test = 'this.needs bracketizing'
      result = '<this.needs bracketizing>'
      expect(bracket(test)).to eq result
    end

    it "should properly bracketize a string, and escape properly" do
      test = 'this needs <escaping'
      result = '<this needs \<escaping>'
      expect(bracket(test)).to eq result
    end

    it "should properly bracketize a string, and escape properly (other way)" do
      test = 'this needs >escaping'
      result = '<this needs \>escaping>'
      expect(bracket(test)).to eq result
    end

    it "should properly bracketize a string, even if bracketized but not escaped properly" do
      test = '<this needs <escaping>'
      result = '<this needs \<escaping>'
      expect(bracket(test)).to eq result
    end

    it "should properly bracketize a string, even if bracketized but not escaped properly (other way)" do
      test = '<this needs >escaping>'
      result = '<this needs \>escaping>'
      expect(bracket(test)).to eq result
    end
    
    it "should bracketize correctly a phrase with an escaped brackets in it" do
      test = 'this needs \<bracketizing'
      result = '<this needs \<bracketizing>'
      expect(bracket(test)).to eq result
    end
    
    it "should bracketize correctly a phrase with an escaped brackets in it (other way)" do
      test = 'this needs \>bracketizing'
      result = '<this needs \>bracketizing>'
      expect(bracket(test)).to eq result
    end
    
    it "should bracketize correctly a phrase with an escaped backslash followed by an escaped brackets in it" do
      test = 'this needs \\\<bracketizing'
      result = '<this needs \\\<bracketizing>'
      expect(bracket(test)).to eq result
    end
    
    it "should bracketize correctly a phrase with an escaped backslash followed by an escaped brackets in it (other way)" do
      test = 'this needs \\\>bracketizing'
      result = '<this needs \\\>bracketizing>'
      expect(bracket(test)).to eq result
    end

    it "should bracketize correctly a phrase with a set of brackets" do
      test = 'this <needs> bracketizing'
      result = '<this \<needs\> bracketizing>'
      expect(bracket(test)).to eq result
    end
    
  end

  describe "url escaping" do
    uri_parser = URI.const_defined?(:Parser) ? URI::Parser.new : URI

    it "should have a wrapper on URI.escape" do
      expect(uri_escape("@?@!")).to eq uri_parser.escape("@?@!")
    end

    it "should have a wrapper on URI.unescape" do
      expect(uri_unescape("@?@!")).to eq uri_parser.unescape("@?@!")
    end
  end
  
end
