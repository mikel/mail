# encoding: utf-8
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
end

