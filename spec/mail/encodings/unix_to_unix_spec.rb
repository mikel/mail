# encoding: utf-8
require 'spec_helper'

describe Mail::Encodings::UnixToUnix do
  def decode(str)
    Mail::Encodings::UnixToUnix.decode(str)
  end

  def encode(str)
    Mail::Encodings::UnixToUnix.encode(str)
  end

  it "decodes" do
    text = strip_heredoc(<<-TEXT)
      begin 644 Happy.txt
      M2&%P<'D@=&]D87D@9F]R('1O(&)E(&]N92!O9B!P96%C92!A;F0@<V5R96YE
      '('1I;64N"@``
      `
      end
    TEXT
    expect(decode(text)).to eq "Happy today for to be one of peace and serene time.\n"
  end

  it "encodes" do
    expect(encode("Happy today")).to eq "+2&%P<'D@=&]D87D`\n"
  end

  if RUBY_VERSION > "1.9"
    it "encodes / decodes non-ascii" do
      expect(encode("Happy ああr")).to eq "-2&%P<'D@XX&\"XX&\"<@``\n"
      expected = (RUBY_ENGINE == "jruby" ? "Happy ああr" : "Happy ああr".force_encoding("binary"))
      expect(decode("-2&%P<'D@XX&\"XX&\"<@``\n")).to eq expected
    end
  end

  it "can read itself" do
    expect(decode(encode("Happy today"))).to eq "Happy today"
    expect(encode(decode("+2&%P<'D@=&]D87D`\n"))).to eq "+2&%P<'D@=&]D87D`\n"
  end
end
