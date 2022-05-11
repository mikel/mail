# encoding: utf-8
require 'spec_helper'
require 'logger'
require 'stringio'

RSpec.describe "Logger Delivery Method" do
  before(:each) do
    # Reset all defaults back to original state
    Mail.defaults do
      delivery_method :smtp,
        :address              => "localhost",
        :port                 => 25,
        :domain               => 'localhost.localdomain',
        :user_name            => nil,
        :password             => nil,
        :authentication       => nil,
        :enable_starttls_auto => true
    end
  end

  let(:mail) do
    Mail.new do
      from    'dschrute@dm.com'
      to      'mscarn@dm.com'
      subject 'Beet Bandit'
    end
  end

  it "sends an email to $stdout with 'info' severity by default" do
    Mail.defaults do
      delivery_method :logger
    end

    logger = mail.delivery_method.logger

    expect(logger).to receive(:log).with(Logger::INFO) { mail.encoded }

    mail.deliver!
  end

  it "can be configured with a custom logger and severity" do
    custom_logger = double("custom_logger")

    Mail.defaults do
      delivery_method :logger, :logger => custom_logger, :severity => :debug
    end

    expect(custom_logger).to receive(:log).with(Logger::DEBUG) { mail.encoded }

    mail.deliver!
  end

  describe "sender and recipient validation" do
    it "should not raise errors if no sender is defined" do
      Mail.defaults do
        delivery_method :logger, :logger => Logger.new(StringIO.new)
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

    it "should raise an error if no recipient if defined" do
      Mail.defaults do
        delivery_method :logger, :logger => Logger.new(StringIO.new)
      end

      mail = Mail.new do
        from "from@somemail.com"
        subject "Email with no recipient"
        body "body"
      end

      expect(mail.smtp_envelope_to).to eq([])

      expect do
        mail.deliver
      end.to raise_error('SMTP To address may not be blank: []')
    end
  end
end
