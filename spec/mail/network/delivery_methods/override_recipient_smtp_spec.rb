# encoding: utf-8
require 'spec_helper'

describe 'override recipient SMTP delivery method' do
  it 'raises an error when :to option is missing' do
    doing do
      Mail.defaults do
        delivery_method :override_recipient_smtp
      end
    end.should raise_error(ArgumentError)
  end

  it 'supresses email delivery to, cc, and bcc fields' do
    Mail.defaults do
      delivery_method :override_recipient_smtp, :to => 'staging@example.com'
    end

    mail = Mail.deliver do
      from 'roger@example.com'
      to   'marcel@example.com'
      cc   'bob@example.com'
      bcc  'dan@example.com'
    end

    response = mail.deliver!

    response.to.should eq ['staging@example.com']
    response.cc.should eq []
    response.bcc.should eq []
    response.header['X-Override-To'].to_s.should eq '[marcel@example.com, staging@example.com]'
    response.header['X-Override-Cc'].to_s.should eq 'bob@example.com'
    response.header['X-Override-Bcc'].to_s.should eq 'dan@example.com'
  end

  it 'can accept an array as configuration' do
    Mail.defaults do
      delivery_method :override_recipient_smtp,
        :to => ['dan@example.com', 'harlow@example.com']
    end

    mail = Mail.deliver do
      from 'roger@example.com'
    end

    response = mail.deliver!

    response.to.should eq ['dan@example.com', 'harlow@example.com']
  end
end
