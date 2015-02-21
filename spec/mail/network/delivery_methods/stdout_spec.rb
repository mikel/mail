# encoding: utf-8
require 'spec_helper'

describe "Stdout Delivery Method" do

  before(:each) do
    # Reset all defaults back to original state
    Mail.defaults do
      delivery_method :smtp, { :address              => "localhost",
                               :port                 => 25,
                               :domain               => 'localhost.localdomain',
                               :user_name            => nil,
                               :password             => nil,
                               :authentication       => nil,
                               :enable_starttls_auto => true  }
    end
  end

  let(:mail) do
    Mail.new do
      from    'dschrute@dm.com'
      to      'mscarn@dm.com'
      subject 'Beet Bandit'
    end
  end

  it "sends an email to STDOUT with 'info' severity by default" do
    Mail.defaults do
      delivery_method :stdout
    end

    logger = mail.delivery_method.settings.fetch(:logger)

    expect(logger).to receive(:info).with(mail.encoded)

    mail.deliver!
  end

  it "can be configured with a custom logger" do
    custom_logger = double("custom_logger")

    Mail.defaults do
      delivery_method :stdout, { :logger => custom_logger }
    end

    expect(custom_logger).to receive(:info).with(mail.encoded)

    mail.deliver!
  end

  it "can be configured with a custom logger severity" do
    custom_logger = double("custom_logger")

    Mail.defaults do
      delivery_method :stdout, { :logger => custom_logger, :severity => :debug }
    end

    expect(custom_logger).to receive(:debug).with(mail.encoded)

    mail.deliver!
  end

end
