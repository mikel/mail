# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::CheckDeliveryParams do

  let(:from_addr) { 'from@example.com' }
  let(:to_addr)   { 'to@example.org' }

  let(:mail) {
    Mail.new(from: from_addr,
             to: to_addr,
             subject: 'Hello there Mikel',
             body: 'This is a body of text')
  }

  describe ".check" do
    it "returns the from, to array and encoded message in an array" do
      expect(Mail::CheckDeliveryParams.check(mail)).to eq([from_addr, [to_addr], mail.encoded])
    end

    it 'raises error if From is blank' do
      mail.from = nil
      expect {
        Mail::CheckDeliveryParams.check(mail)
      }.to raise_error(ArgumentError, "SMTP From address may not be blank: nil")
    end

    it 'raises error if To is blank' do
      mail.to = nil
      expect {
        Mail::CheckDeliveryParams.check(mail)
      }.to raise_error(ArgumentError, "SMTP To address may not be blank: []")
    end
  end

  describe '.check_from' do
    it "returns the from address" do
      expect(Mail::CheckDeliveryParams.check_from(mail.smtp_envelope_from)).to eq(from_addr)
    end

    it 'raises error if From is too long' do
      long_addr = "#{'bob'*682}@example.com"
      expect {
        Mail::CheckDeliveryParams.check_from(long_addr)
      }.to raise_error(ArgumentError, "SMTP From address may not exceed 2000 bytes: \"#{long_addr}\"")
    end
  end

  describe '.check_to' do
    it "returns the to address array" do
      expect(Mail::CheckDeliveryParams.check_to(mail.smtp_envelope_to)).to eq([to_addr])
    end

    it 'raises error if To is too long' do
      long_addr = "#{'bob'*682}@example.com"
      expect {
        Mail::CheckDeliveryParams.check_to(long_addr)
      }.to raise_error(ArgumentError, "SMTP To address may not exceed 2000 bytes: \"#{long_addr}\"")
    end
  end

  describe '.check_addr' do
    it "returns the address if it is not too long" do
      expect(Mail::CheckDeliveryParams.check_addr("From", mail.smtp_envelope_from)).to eq(mail.smtp_envelope_from)
    end

    it 'raises error if address is too long' do
      long_addr = "#{'bob'*682}@example.com"
      expect {
        Mail::CheckDeliveryParams.check_addr("To", long_addr)
      }.to raise_error(ArgumentError, "SMTP To address may not exceed 2000 bytes: \"#{long_addr}\"")
    end
  end

  describe '.validate_smtp_addr' do
    it "returns the address is not too long" do
      expect(Mail::CheckDeliveryParams.validate_smtp_addr(mail.smtp_envelope_from)).to eq(mail.smtp_envelope_from)
    end

    it 'returns error message if address contains LF' do
      long_addr = "bob\n@example.com"

      Mail::CheckDeliveryParams.validate_smtp_addr(long_addr) do |error_message|
        expect(error_message).to eq('may not contain CR or LF line breaks')
      end
    end

    it 'returns error message if address contains CR' do
      long_addr = "bob\r@example.com"

      Mail::CheckDeliveryParams.validate_smtp_addr(long_addr) do |error_message|
        expect(error_message).to eq('may not contain CR or LF line breaks')
      end
    end

    it 'returns error message if address is too long' do
      long_addr = "#{'bob'*682}@example.com"

      Mail::CheckDeliveryParams.validate_smtp_addr(long_addr) do |error_message|
        expect(error_message).to eq('may not exceed 2kB')
      end
    end
  end

  describe '.check_message' do
    it "ensures the message is not blank" do
      expect(Mail::CheckDeliveryParams.check_message(mail.encoded)).to eq(mail.encoded)
    end
  end
end
