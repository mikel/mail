# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe '.decode_base64' do
  it "handles unpadded base64 correctly" do
    decoded = Mail::Ruby19.decode_base64("YQ")
    expect(decoded).to eq "a"
  end
end
