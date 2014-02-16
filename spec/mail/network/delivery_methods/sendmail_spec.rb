# encoding: utf-8
require 'spec_helper'

describe Mail::Sendmail do

  let(:from)    { 'roger@test.lindsaar.net' }
  let(:to)      { 'marcel@test.lindsaar.net, bob@test.lindsaar.net' }
  let(:subject) { 'some subject' }
  let(:mail)    { Mail.new({:from => from, :to => to, :subject => subject}) }

  before do
    # Reset all defaults back to original state
    Mail.defaults do
      delivery_method :smtp, { :address              => 'localhost',
                               :port                 => 25,
                               :domain               => 'localhost.localdomain',
                               :user_name            => nil,
                               :password             => nil,
                               :authentication       => nil,
                               :enable_starttls_auto => true }

      delivery_method :sendmail
    end
  end

  it 'sends an email using sendmail' do
    described_class.should_receive(:call)
      .with('/usr/sbin/sendmail',
            '-i -f "roger@test.lindsaar.net" --',
            '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
            mail.encoded)
    mail.deliver!
  end

  it 'spawns a sendmail process' do
    described_class.should_receive(:popen)
      .with('/usr/sbin/sendmail -i -f "roger@test.lindsaar.net" -- "marcel@test.lindsaar.net" "bob@test.lindsaar.net"')
    mail.deliver!
  end

  context 'SMTP From' do

    it 'explicitly passes an envelope From address to sendmail' do
      mail.smtp_envelope_from 'smtp_from@test.lindsaar.net'
      described_class.should_receive(:call)
        .with('/usr/sbin/sendmail',
              '-i -f "smtp_from@test.lindsaar.net" --',
              '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
              mail.encoded)
      mail.deliver
    end

    it 'escapes the From address' do
      mail.from '"from+suffix test"@test.lindsaar.net'
      described_class.should_receive(:call)
        .with('/usr/sbin/sendmail',
              '-i -f "\"from+suffix test\"@test.lindsaar.net" --',
              '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
              mail.encoded)
      mail.deliver
    end
  end

  context 'SMTP To' do

    it 'explicitly passes envelope To addresses to sendmail' do
      mail.smtp_envelope_to 'smtp_to@test.lindsaar.net'
      described_class.should_receive(:call)
        .with('/usr/sbin/sendmail',
              '-i -f "roger@test.lindsaar.net" --',
              '"smtp_to@test.lindsaar.net"',
              mail.encoded)
      mail.deliver
    end

    it 'escapes the To address' do
      mail.to '"to+suffix test"@test.lindsaar.net'
      described_class.should_receive(:call)
        .with('/usr/sbin/sendmail',
              '-i -f "roger@test.lindsaar.net" --',
              '"\"to+suffix test\"@test.lindsaar.net"',
              mail.encoded)
      mail.deliver
    end

    it 'quotes the destinations to ensure leading -hyphen doesn\'t confuse sendmail' do
      mail.to '-hyphen@test.lindsaar.net'
      described_class.should_receive(:call)
        .with('/usr/sbin/sendmail',
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

    described_class.should_receive(:call)
      .with('/usr/sbin/sendmail',
            ' -f "roger@test.lindsaar.net" --',
            '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"',
            mail.encoded)
    mail.deliver!
  end

  it 'escapes evil haxxor attempts' do
    Mail.defaults do
      delivery_method :sendmail, :arguments => nil
    end

    mail.from '"foo\";touch /tmp/PWNED;\""@blah.com'
    mail.to '"foo\";touch /tmp/PWNED;\""@blah.com'

    described_class.should_receive(:call)
      .with('/usr/sbin/sendmail',
            " -f \"\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com\" --",
            %("\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com"),
            mail.encoded)
    mail.deliver!
  end

  it 'raises an error if no sender is defined' do
    Mail.defaults do
      delivery_method :test
    end

    lambda do
      Mail.deliver do
        to 'to@somemail.com'
        subject 'Email with no sender'
        body 'body'
      end
    end.should raise_error('An SMTP From address is required to send a message. Set the message smtp_envelope_from, return_path, sender, or from address.')
  end

  it 'raises an error if no recipient is defined' do
    Mail.defaults do
      delivery_method :test
    end

    lambda do
      Mail.deliver do
        from 'from@somemail.com'
        subject 'Email with no recipient'
        body 'body'
      end
    end.should raise_error('An SMTP To address is required to send a message. Set the message smtp_envelope_to, to, cc, or bcc address.')
  end
end
