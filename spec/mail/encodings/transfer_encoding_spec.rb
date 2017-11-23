# frozen_string_literal: true
require 'spec_helper'

describe Mail::Encodings::TransferEncoding do

  it "should handle empty message_encoding" do
    expect(Mail::Encodings::TransferEncoding.negotiate("", '8bit', '')).to eq Mail::Encodings::EightBit
  end

end
