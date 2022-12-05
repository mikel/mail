# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::Encodings::TransferEncoding do
  it "accepts blank message_encoding" do
    expect(described_class.negotiate('', '7bit', '')).to eq Mail::Encodings::SevenBit
    expect(described_class.negotiate('', '8bit', '')).to eq Mail::Encodings::EightBit
  end
end
