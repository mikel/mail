# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe "exim delivery agent" do
  let :mail do
    Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'some subject'
    end
  end

  before do
    Mail.defaults do
      delivery_method :exim
    end
  end

  it "should send an email using exim" do
    expect(mail.delivery_method).to receive(:popen).with(%w[ /usr/sbin/exim -i -t -f roger@test.lindsaar.net ])

    mail.deliver!
  end

  describe "return path" do
    it "should send an email with a return-path using exim" do
      expect(mail.delivery_method).to receive(:popen).with(%w[ /usr/sbin/exim -i -t -f return@test.lindsaar.net ])

      mail.return_path = "return@test.lindsaar.net"
      mail.sender = "sender@test.lindsaar.net"
      mail.deliver
    end

    it "should use the sender address is no return path is specified" do
      expect(mail.delivery_method).to receive(:popen).with(%w[ /usr/sbin/exim -i -t -f sender@test.lindsaar.net ])

      mail.sender = "sender@test.lindsaar.net"
      mail.deliver
    end

    it "should use the from address is no return path or sender are specified" do
      expect(mail.delivery_method).to receive(:popen).with(%w[ /usr/sbin/exim -i -t -f from@test.lindsaar.net ])

      mail.from = "from@test.lindsaar.net"
      mail.deliver
    end

    it "should escape the return path address" do
      expect(mail.delivery_method).to receive(:popen).with([ '/usr/sbin/exim', '-i', '-t', '-f', '"from+suffix test"@test.lindsaar.net' ])

      mail.from = '"from+suffix test"@test.lindsaar.net'
      mail.deliver
    end

    it 'should not escape ~ in return path address' do
      expect(mail.delivery_method).to receive(:popen).
        with(%w[ /usr/sbin/exim -i -t -f tilde~@test.lindsaar.net ])

      mail.from = 'tilde~@test.lindsaar.net'
      mail.deliver
    end
  end

  it "should still send an email if the settings have been set to nil" do
    expect(mail.delivery_method).to receive(:popen).with(%w[ /usr/sbin/exim -f roger@test.lindsaar.net ])

    mail.delivery_method.settings[:arguments] = nil
    mail.deliver!
  end

  it "should escape evil haxxor attemptes" do
    evil = '"foo\";touch /tmp/PWNED;\""@blah.com'

    expect(mail.delivery_method).to receive(:popen).with(
      [ '/usr/sbin/exim', '-i', '-t', '-f', evil ])

    mail.from = evil
    mail.deliver!
  end

  it "should raise an error if no sender is defined" do
    mail.from = nil

    expect(mail.smtp_envelope_from).to be_nil

    expect do
      mail.deliver
    end.to raise_error('SMTP From address may not be blank: nil')
  end

  it "should raise an error if no recipient if defined" do
    mail.to = nil

    expect(mail.smtp_envelope_to).to eq([])

    expect do
      mail.deliver
    end.to raise_error('SMTP To address may not be blank: []')
  end
end
