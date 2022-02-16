# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::Encodings::UnixToUnix do
  def decode(str)
    Mail::Encodings::UnixToUnix.decode(str)
  end

  def encode(str)
    Mail::Encodings::UnixToUnix.encode(str)
  end

  it "is registered as uuencode" do
    expect(Mail::Encodings.get_encoding('uuencode')).to eq(Mail::Encodings::UnixToUnix)
  end

  it "is registered as x-uuencode" do
    expect(Mail::Encodings.get_encoding('x-uuencode')).to eq(Mail::Encodings::UnixToUnix)
  end

  it "is registered as x-uue" do
    expect(Mail::Encodings.get_encoding('x-uue')).to eq(Mail::Encodings::UnixToUnix)
  end

  it "can transport itself" do
    expect(Mail::Encodings::UnixToUnix.can_transport?(Mail::Encodings::UnixToUnix)).to be_truthy
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

  it "encodes / decodes non-ascii" do
    expect(encode("Happy ああr")).to eq "-2&%P<'D@XX&\"XX&\"<@``\n"
    expect(decode("-2&%P<'D@XX&\"XX&\"<@``\n")).to eq "Happy ああr".dup.force_encoding("binary")
  end

  it "can read itself" do
    expect(decode(encode("Happy today"))).to eq "Happy today"
    expect(encode(decode("+2&%P<'D@=&]D87D`\n"))).to eq "+2&%P<'D@=&]D87D`\n"
  end
end
