# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe 'AddressContainer' do
  it "should allow you to append an address to an address field result" do
    m = Mail.new("To: mikel@test.lindsaar.net")
    expect(m.to).to eq ['mikel@test.lindsaar.net']
    m.to << 'bob@test.lindsaar.net'
    expect(m.to).to eq ['mikel@test.lindsaar.net', 'bob@test.lindsaar.net']
  end

  it "should handle complex addresses correctly" do
    m = Mail.new("From: mikel@test.lindsaar.net")
    expect(m.from).to eq ['mikel@test.lindsaar.net']
    m.from << '"Ada Lindsaar" <ada@test.lindsaar.net>, bob@test.lindsaar.net'
    expect(m.from).to eq ['mikel@test.lindsaar.net', 'ada@test.lindsaar.net', 'bob@test.lindsaar.net']
  end
end
