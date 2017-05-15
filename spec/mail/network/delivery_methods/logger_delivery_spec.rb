# encoding: utf-8
require 'spec_helper'

describe "Logger Delivery Method" do
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
end
