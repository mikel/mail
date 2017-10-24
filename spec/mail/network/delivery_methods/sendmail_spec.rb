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
    expect(described_class).to receive(:call).
      with('/usr/sbin/sendmail',
           '-i -f "roger@test.lindsaar.net" --',
           '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
           mail.encoded)

    mail.deliver!
  end

  it 'spawns a sendmail process' do
    expect(described_class).to receive(:popen).
      with('/usr/sbin/sendmail -i -f "roger@test.lindsaar.net" -- "marcel@test.lindsaar.net" "bob@test.lindsaar.net"')

    mail.deliver!
  end

  context 'SMTP From' do
    it 'explicitly passes an envelope From address to sendmail' do
      mail.smtp_envelope_from = 'smtp_from@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "smtp_from@test.lindsaar.net" --',
             '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end

    it 'escapes the From address' do
      mail.from = '"from+suffix test"@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "\"from+suffix test\"@test.lindsaar.net" --',
             '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end

    it 'does not escape ~ in From address' do
      mail.from = 'tilde~@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "tilde~@test.lindsaar.net" --',
             '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end
  end

  context 'SMTP To' do
    it 'explicitly passes envelope To addresses to sendmail' do
      mail.smtp_envelope_to = 'smtp_to@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "roger@test.lindsaar.net" --',
             '"smtp_to@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end

    it 'escapes the To address' do
      mail.to = '"to+suffix test"@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "roger@test.lindsaar.net" --',
             '"\"to+suffix test\"@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end

    it 'does not escape ~ in To address' do
      mail.to = 'tilde~@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "roger@test.lindsaar.net" --',
             '"tilde~@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end

    it 'quotes the destinations to ensure leading -hyphen doesn\'t confuse sendmail' do
      mail.to = '-hyphen@test.lindsaar.net'

      expect(described_class).to receive(:call).
        with('/usr/sbin/sendmail',
             '-i -f "roger@test.lindsaar.net" --',
             '"-hyphen@test.lindsaar.net"',
             mail.encoded)

      mail.deliver
    end
  end

  it 'still sends an email if the arguments setting have been set to nil' do
    Mail.defaults do
      delivery_method :sendmail, :arguments => nil
    end

    expect(described_class).to receive(:call).
      with('/usr/sbin/sendmail',
           ' -f "roger@test.lindsaar.net" --',
           '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
           mail.encoded)

    mail.deliver!
  end

  it 'escapes evil haxxor attempts' do
    Mail.defaults do
      delivery_method :sendmail, :arguments => nil
    end

    mail.from = '"foo\";touch /tmp/PWNED;\""@blah.com'
    mail.to   = '"foo\";touch /tmp/PWNED;\""@blah.com'

    expect(described_class).to receive(:call).
      with('/usr/sbin/sendmail',
           " -f \"\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com\" --",
           %("\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com"),
           mail.encoded)

    mail.deliver!
  end

  it 'raises an error if no sender is defined' do
    Mail.defaults do
      delivery_method :sendmail
    end

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
    Mail.defaults do
      delivery_method :sendmail
    end

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
