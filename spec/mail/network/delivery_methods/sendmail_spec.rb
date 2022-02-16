# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::Sendmail do
  let :mail do
    Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'some subject'
    end
  end

  before do
    Mail.defaults do
      delivery_method :sendmail
    end
  end

  it 'sends an email using sendmail' do
    expect(mail.delivery_method).to receive(:popen).
      with(%w[ /usr/sbin/sendmail -i
        -f roger@test.lindsaar.net
        -- marcel@test.lindsaar.net bob@test.lindsaar.net ])

    mail.deliver!
  end

  it 'spawns a sendmail process' do
    expect(mail.delivery_method).to receive(:popen).
      with(%w[ /usr/sbin/sendmail -i
        -f roger@test.lindsaar.net
        -- marcel@test.lindsaar.net bob@test.lindsaar.net ])

    mail.deliver!
  end

  context 'SMTP From' do
    it 'explicitly passes an envelope From address to sendmail' do
      expect(mail.delivery_method).to receive(:popen).
        with(%w[ /usr/sbin/sendmail -i
          -f smtp_from@test.lindsaar.net
          -- marcel@test.lindsaar.net bob@test.lindsaar.net ])

      mail.smtp_envelope_from = 'smtp_from@test.lindsaar.net'
      mail.deliver
    end

    it 'escapes the From address' do
      expect(mail.delivery_method).to receive(:popen).
        with([ '/usr/sbin/sendmail', '-i',
          '-f', '"from+suffix test"@test.lindsaar.net',
          '--', 'marcel@test.lindsaar.net', 'bob@test.lindsaar.net' ])

      mail.from = '"from+suffix test"@test.lindsaar.net'
      mail.deliver
    end

    it 'does not escape ~ in From address' do
      expect(mail.delivery_method).to receive(:popen).
        with(%w[ /usr/sbin/sendmail -i
          -f tilde~@test.lindsaar.net
          -- marcel@test.lindsaar.net bob@test.lindsaar.net ])

      mail.from = 'tilde~@test.lindsaar.net'
      mail.deliver
    end
  end

  context 'SMTP To' do
    it 'explicitly passes envelope To addresses to sendmail' do
      expect(mail.delivery_method).to receive(:popen).
        with(%w[ /usr/sbin/sendmail -i
          -f roger@test.lindsaar.net
          -- smtp_to@test.lindsaar.net ])

      mail.smtp_envelope_to = 'smtp_to@test.lindsaar.net'
      mail.deliver
    end

    it 'escapes the To address' do
      expect(mail.delivery_method).to receive(:popen).
        with([ '/usr/sbin/sendmail', '-i',
          '-f', 'roger@test.lindsaar.net',
          '--', '"to+suffix test"@test.lindsaar.net' ])

      mail.to = '"to+suffix test"@test.lindsaar.net'
      mail.deliver
    end

    it 'does not escape ~ in To address' do
      expect(mail.delivery_method).to receive(:popen).
        with(%w[ /usr/sbin/sendmail -i
          -f roger@test.lindsaar.net
          -- tilde~@test.lindsaar.net ])

      mail.to = 'tilde~@test.lindsaar.net'
      mail.deliver
    end

    it 'quotes the destinations to ensure leading -hyphen doesn\'t confuse sendmail' do
      expect(mail.delivery_method).to receive(:popen).
        with(%w[ /usr/sbin/sendmail -i
          -f roger@test.lindsaar.net
          -- -hyphen@test.lindsaar.net ])

      mail.to = '-hyphen@test.lindsaar.net'
      mail.deliver
    end
  end

  it 'still sends an email if the arguments setting have been set to nil' do
    expect(mail.delivery_method).to receive(:popen).
      with(%w[ /usr/sbin/sendmail
        -f roger@test.lindsaar.net
        -- marcel@test.lindsaar.net bob@test.lindsaar.net ])

    mail.delivery_method.settings[:arguments] = nil
    mail.deliver!
  end

  it 'escapes evil haxxor attempts' do
    evil = '"foo\";touch /tmp/PWNED;\""@blah.com'

    expect(mail.delivery_method).to receive(:popen).
      with([ '/usr/sbin/sendmail', '-i', '-f', evil, '--', evil ])

    mail.from = evil
    mail.to   = evil
    mail.deliver!
  end

  it 'raises on nonzero exitstatus' do
    command = %w[ /usr/sbin/sendmail -i -f roger@test.lindsaar.net -- marcel@test.lindsaar.net bob@test.lindsaar.net ]
    args = [ command, 'w+' ]
    args << { :err => :out }

    expect(IO).to receive(:popen).with(*args) { system 'false' }

    expect do
      mail.deliver
    end.to raise_error('Delivery failed with exitstatus 1: ["/usr/sbin/sendmail", "-i", "-f", "roger@test.lindsaar.net", "--", "marcel@test.lindsaar.net", "bob@test.lindsaar.net"]')
  end

  it 'raises an error if no sender is defined' do
    mail = Mail.new do
      to "to@somemail.com"
      subject "Email with no sender"
      body "body"
    end

    expect(mail.smtp_envelope_from).to be_nil

    expect do
      mail.deliver
    end.to raise_error('SMTP From address may not be blank: nil')
  end

  it 'raises an error if no recipient is defined' do
    mail = Mail.new do
      from "from@somemail.com"
      subject "Email with no recipient"
      body "body"
    end

    expect(mail.smtp_envelope_to).to eq([])

    expect do
      mail.deliver!
    end.to raise_error('SMTP To address may not be blank: []')
  end
end
