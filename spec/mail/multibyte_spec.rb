# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe "multibyte/chars" do
  Chars = Mail::Multibyte::Chars

  it "should upcase" do
    chars = Chars.new('Laurent, où sont les tests ?')
    expect(chars.upcase).to eq("LAURENT, OÙ SONT LES TESTS ?")
  end

  it "should downcase" do
    chars = Chars.new('VĚDA A VÝZKUM')
    expect(chars.downcase).to eq("věda a výzkum")
  end

  if 'string'.respond_to?(:force_encoding)
    it "doesn't mutate input string encoding" do
      s = "ascii".force_encoding(Encoding::US_ASCII)
      chars = Chars.new(s)
      expect(s.encoding).to eq(Encoding::US_ASCII)
    end
  end
end
