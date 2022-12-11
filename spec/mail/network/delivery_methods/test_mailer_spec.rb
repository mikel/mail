# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe "Mail::TestMailer" do
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
      Mail::TestMailer.deliveries.clear
    end
  end

  it "should have no deliveries when first initiated" do
    Mail.defaults do
      delivery_method :test
    end
    expect(Mail::TestMailer.deliveries).to be_empty
  end

  it "should deliver an email to the Mail::TestMailer.deliveries array" do
    Mail.defaults do
      delivery_method :test
    end
    mail = Mail.new do
      to 'mikel@me.com'
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
    mail.deliver
    expect(Mail::TestMailer.deliveries.length).to eq 1
    expect(Mail::TestMailer.deliveries.first).to eq mail
  end

  it "should clear the deliveries when told to" do
    Mail.defaults do
      delivery_method :test
    end
    mail = Mail.new do
      to 'mikel@me.com'
      from 'you@you.com'
      subject 'testing'
      body 'hello'
    end
    mail.deliver
    expect(Mail::TestMailer.deliveries.length).to eq 1
    Mail::TestMailer.deliveries.clear
    expect(Mail::TestMailer.deliveries).to be_empty
  end

  it "should not raise errors if no sender is defined" do
    Mail.defaults do
      delivery_method :test
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
      delivery_method :test
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

  it "should save settings passed to initialize" do
    expect(Mail::TestMailer.new(:setting => true).settings).to include(:setting => true)
  end
end
