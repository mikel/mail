# encoding: utf-8
# frozen_string_literal: true
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
        expect(token_safe?(Mail::Multibyte.mb_chars('.abc'))).to be_truthy
        expect(token_safe?(Mail::Multibyte.mb_chars('?=abc'))).to be_falsey
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
        expect(quote_token(Mail::Multibyte.mb_chars('.abc'))).to eq '.abc'
        expect(quote_token(Mail::Multibyte.mb_chars('?=abc'))).to eq '"?=abc"'
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
        expect(atom_safe?(Mail::Multibyte.mb_chars('?=abc'))).to be_truthy
        expect(atom_safe?(Mail::Multibyte.mb_chars('.abc'))).to be_falsey
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
        expect(quote_atom(Mail::Multibyte.mb_chars('?=abc'))).to eq '?=abc'
        expect(quote_atom(Mail::Multibyte.mb_chars('.abc'))).to eq '".abc"'
      end

      it "should quote mb_chars white space" do
        expect(quote_atom(Mail::Multibyte.mb_chars('ab abc'))).to eq '"ab abc"'
        expect(quote_atom(Mail::Multibyte.mb_chars("a\sb\ta\r\nbc"))).to eq %{"a\sb\ta\r\nbc"}
      end
    end
  end

  describe "quoting phrases" do
    it "doesn't mutate original string" do
      input_str = "blargh".freeze
      expect { quote_phrase(input_str) }.not_to raise_error
    end

    describe "given a non-unsafe string" do
      it "should not change the encoding" do
        input_str = "blargh"
        input_str_encoding = input_str.encoding

        result = quote_phrase(input_str)

        expect(result.encoding).to eq input_str_encoding
      end
    end

    describe "given an unsafe string" do
      it "should not change the encoding" do
        input_str = "Bjørn"
        input_str_encoding = input_str.encoding

        result = quote_phrase(input_str)

        expect(result.encoding).to eq input_str_encoding
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

    it "should work using Multibyte.mb_chars" do
      test = Mail::Multibyte.mb_chars('(This is a string)')
      result = 'This is a string'
      expect(unparen(test)).to eq result
    end

    it "should work without parens using Multibyte.mb_chars" do
      test = Mail::Multibyte.mb_chars('This is a string')
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

    it "should work using Multibyte.mb_chars" do
      test = Mail::Multibyte.mb_chars('<This is a string>')
      result = 'This is a string'
      expect(unbracket(test)).to eq result
    end

    it "should work without parens using Multibyte.mb_chars" do
      test = Mail::Multibyte.mb_chars('This is a string')
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

  describe "unescaping phrases" do
    it "should not modify a string with no backslashes" do
      expect(unescape('This is a string')).to eq 'This is a string'
    end

    it "should not modify a quoted string with no backslashes" do
      expect(unescape('"This is a string"')).to eq '"This is a string"'
    end

    it "should remove backslash escaping from a string" do
      expect(unescape('This is \"a string\"')).to eq 'This is "a string"'
    end

    it "should remove backslash escaping from a quoted string" do
      expect(unescape('"This is \"a string\""')).to eq '"This is "a string""'
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
    uri_parser = Mail::Utilities.uri_parser

    it "should have a wrapper on URI.escape" do
      expect(uri_escape("@?@!")).to eq uri_parser.escape("@?@!")
    end

    it "should have a wrapper on URI.unescape" do
      expect(uri_unescape("@?@!")).to eq uri_parser.unescape("@?@!")
    end
  end


  describe "blank method" do
    it "should say nil is blank" do
      expect(Mail::Utilities.blank?(nil)).to be_truthy
    end

    it "should say false is blank" do
      expect(Mail::Utilities.blank?(false)).to be_truthy
    end

    it "should say true is not blank" do
      expect(Mail::Utilities.blank?(true)).not_to be_truthy
    end

    it "should say an empty array is blank" do
      expect(Mail::Utilities.blank?([])).to be_truthy
    end

    it "should say an empty hash is blank" do
      expect(Mail::Utilities.blank?({})).to be_truthy
    end

    it "should say an empty string is blank" do
      expect(Mail::Utilities.blank?('')).to be_truthy
      expect(Mail::Utilities.blank?(" ")).to be_truthy
      a = ' ' * 1000
      expect(Mail::Utilities.blank?(a)).to be_truthy
      expect(Mail::Utilities.blank?("\t \n\n")).to be_truthy
    end
  end

  describe "not blank method" do
    it "should say a number is not blank" do
      expect(Mail::Utilities.blank?(1)).not_to be_truthy
    end

    it "should say a valueless hash is not blank" do
      expect(Mail::Utilities.blank?({:one => nil, :two => nil})).not_to be_truthy
    end

    it "should say a hash containing an empty hash is not blank" do
      expect(Mail::Utilities.blank?({:key => {}})).not_to be_truthy
    end
  end

  describe "to_lf" do
    it "converts single CR" do
      expect(Mail::Utilities.to_lf("\r")).to eq "\n"
    end

    it "converts multiple CR" do
      expect(Mail::Utilities.to_lf("\r\r")).to eq "\n\n"
    end

    it "converts single CRLF" do
      expect(Mail::Utilities.to_lf("\r\n")).to eq "\n"
    end

    it "converts multiple CRLF" do
      expect(Mail::Utilities.to_lf("\r\n\r\n")).to eq "\n\n"
    end

    it "leaves LF intact" do
      expect(Mail::Utilities.to_lf("\n\n")).to eq "\n\n"
    end

    it "converts mixed line endings" do
      expect(Mail::Utilities.to_lf("\r \n\r\n")).to eq "\n \n\n"
    end

    it "should handle japanese characters" do
      string = "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
      expect(Mail::Utilities.binary_unsafe_to_lf(string)).to eq "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\n\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\n\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\n\n"
    end

    describe "on NilClass" do
      it "returns an empty string" do
        expect(Mail::Utilities.to_lf(nil)).to eq ''
      end
    end

    describe "on String subclasses" do
      it "returns Strings" do
        klass = Class.new(String)
        string = klass.new('')
        expect(Mail::Utilities.to_lf(string)).to be_an_instance_of(String)
      end
    end
  end

  describe "to_crlf" do
    it "converts single LF" do
      expect(Mail::Utilities.to_crlf("\n")).to eq "\r\n"
    end

    it "converts multiple LF" do
      expect(Mail::Utilities.to_crlf("\n\n")).to eq "\r\n\r\n"
    end

    it "converts single CR" do
      expect(Mail::Utilities.to_crlf("\r")).to eq "\r\n"
    end

    it "preserves single CRLF" do
      expect(Mail::Utilities.to_crlf("\r\n")).to eq "\r\n"
    end

    it "preserves multiple CRLF" do
      expect(Mail::Utilities.to_crlf("\r\n\r\n")).to eq "\r\n\r\n"
    end

    it "converts mixed line endings" do
      expect(Mail::Utilities.to_crlf("\r \n\r\n")).to eq "\r\n \r\n\r\n"
    end

    it "should handle japanese characters" do
      string = "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
      expect(Mail::Utilities.binary_unsafe_to_crlf(string)).to eq "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
    end

    describe "on NilClass" do
      it "returns an empty string" do
        expect(Mail::Utilities.to_crlf(nil)).to eq ''
      end
    end

    describe "on String subclasses" do
      it "returns Strings" do
        klass = Class.new(String)
        string = klass.new('')
        expect(Mail::Utilities.to_crlf(string)).to be_an_instance_of(String)
      end
    end
  end
end
