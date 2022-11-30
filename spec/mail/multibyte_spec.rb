# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'
require 'mail/multibyte/chars'

RSpec.describe Mail::Multibyte::Chars do
  it "should upcase" do
    chars = described_class.new('Laurent, où sont les tests ?')
    expect(chars.upcase).to eq("LAURENT, OÙ SONT LES TESTS ?")
  end

  it "should downcase" do
    chars = described_class.new('VĚDA A VÝZKUM')
    expect(chars.downcase).to eq("věda a výzkum")
  end

  if 'string'.respond_to?(:force_encoding)
    it "doesn't mutate input string encoding" do
      s = 'ascii'.dup.force_encoding(Encoding::US_ASCII)
      described_class.new(s)
      expect(s.encoding).to eq(Encoding::US_ASCII)
    end
  end
end
