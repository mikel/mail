# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe "SMTP Delivery Method" do

  before(:each) do
    MockSMTP.reset

    # Reset all defaults back to original state
    Mail.defaults { delivery_method :smtp, {} }
  end

  describe "general usage" do
    it "should send emails from given settings" do

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'

        smtp_envelope_from 'smtp_from'
        smtp_envelope_to 'smtp_to'
      end

      expect(MockSMTP.deliveries[0][0]).to eq mail.encoded
      expect(MockSMTP.deliveries[0][1]).to eq 'smtp_from'
      expect(MockSMTP.deliveries[0][2]).to eq %w(smtp_to)
    end

    it "should be able to send itself" do
      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      mail.deliver!

      expect(MockSMTP.deliveries[0][0]).to eq mail.encoded
      expect(MockSMTP.deliveries[0][1]).to eq mail.from[0]
      expect(MockSMTP.deliveries[0][2]).to eq mail.destinations
    end

    it "should be able to return actual SMTP protocol response" do
      Mail.defaults do
        delivery_method :smtp, :address => 'smtp.mockup.com', :port => 587, :return_response => true
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      response = mail.deliver!
      expect(response).to eq 'OK'

    end
  end

  describe "enabling tls" do

    def redefine_verify_none(new_value)
      OpenSSL::SSL.send(:remove_const, :VERIFY_NONE)
      OpenSSL::SSL.send(:const_set, :VERIFY_NONE, new_value)
    end

    it "should use OpenSSL::SSL::VERIFY_NONE if a context" do

      # config can't be setup until redefined
      redefine_verify_none(OpenSSL::SSL::SSLContext.new)
      Mail.defaults do
        delivery_method :smtp, :address => 'smtp.mockup.com', :port => 587
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      expect { mail.deliver! }.not_to raise_error
    end

    it "should ignore OpenSSL::SSL::VERIFY_NONE if it is 0" do

      # config can't be setup until redefined
      redefine_verify_none(0)
      Mail.defaults do
        delivery_method :smtp, :address => 'smtp.mockup.com', :port => 587
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      expect { mail.deliver! }.not_to raise_error
    end
  end

  describe "enabling ssl" do
    def redefine_verify_none(new_value)
      OpenSSL::SSL.send(:remove_const, :VERIFY_NONE)
      OpenSSL::SSL.send(:const_set, :VERIFY_NONE, new_value)
    end

    it "should use OpenSSL::SSL::VERIFY_NONE if a context" do

      # config can't be setup until redefined
      redefine_verify_none(OpenSSL::SSL::SSLContext.new)
      Mail.defaults do
        delivery_method :smtp, :address => 'smtp.mockup.com', :port => 587, :tls => true
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      expect { mail.deliver! }.not_to raise_error
    end

    it "should ignore OpenSSL::SSL::VERIFY_NONE if it is 0" do

      # config can't be setup until redefined
      redefine_verify_none(0)
      Mail.defaults do
        delivery_method :smtp, :address => 'smtp.mockup.com', :port => 587, :tls => true
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      expect { mail.deliver! }.not_to raise_error
    end

    it "should not set verify mode when none is given" do
      context = OpenSSL::SSL::SSLContext.new
      allow(Net::SMTP).to receive(:default_ssl_context).and_return(context)
      expect(context).to_not receive(:verify_mode=)

      Mail.defaults do
        delivery_method :smtp, :address => 'smtp.mockup.com', :port => 587, :tls => true
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      expect { mail.deliver! }.not_to raise_error
    end

    it "should set verify mode if one is given" do
      context = OpenSSL::SSL::SSLContext.new
      allow(Net::SMTP).to receive(:default_ssl_context).and_return(context)
      expect(context).to receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER).at_least(1)

      Mail.defaults do
        delivery_method :smtp,
                        :address => 'smtp.mockup.com',
                        :port => 587,
                        :tls => true,
                        :openssl_verify_mode => OpenSSL::SSL::VERIFY_PEER
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      expect { mail.deliver! }.not_to raise_error
    end
  end

  describe "enabling STARTTLS" do
    it 'should default to automatically detecting STARTTLS' do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
      end

      message.deliver!

      expect(MockSMTP.starttls).to eq :auto
    end

    it 'should allow forcing STARTTLS' do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        delivery_method :smtp, { :enable_starttls => true }
      end

      message.deliver!

      expect(MockSMTP.starttls).to eq :always
    end

    it 'should allow forcing STARTTLS via enable_starttls: :always (overriding :enable_starttls_auto)' do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        delivery_method :smtp, { :enable_starttls => :always,
                                 :enable_starttls_auto => true }
      end

      message.deliver!

      expect(MockSMTP.starttls).to eq :always
    end

    it 'should allow detecting STARTTLS via enable_starttls: :auto (overriding :enable_starttls_auto)' do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        delivery_method :smtp, { :enable_starttls => :auto,
                                 :enable_starttls_auto => false }
      end

      message.deliver!

      expect(MockSMTP.starttls).to eq :auto
    end

    it 'should allow disabling automatic STARTTLS' do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        delivery_method :smtp, { :enable_starttls => false }
      end

      message.deliver!

      expect(MockSMTP.starttls).to eq false
    end

    it 'raises when setting STARTTLS with tls' do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        delivery_method :smtp, { :tls => true, :enable_starttls => :always }
      end

      expect {
        message.deliver!
      }.to raise_error(ArgumentError, /:enable_starttls and :tls are mutually exclusive/)
    end
  end

  describe "SMTP Envelope" do

    it "uses the envelope From and To addresses" do
      Mail.deliver do
        to "to@someemail.com"
        from "from@someemail.com"
        message_id "<1234@someemail.com>"
        body "body"

        smtp_envelope_to "smtp_to@someemail.com"
        smtp_envelope_from "smtp_from@someemail.com"
      end
      expect(MockSMTP.deliveries[0][1]).to eq 'smtp_from@someemail.com'
      expect(MockSMTP.deliveries[0][2]).to eq %w(smtp_to@someemail.com)
    end

    it "supports the null sender in the envelope from address" do
      Mail.deliver do
        to "to@someemail.com"
        from "from@someemail.com"
        message_id "<1234@someemail.com>"
        body "body"

        smtp_envelope_to "smtp_to@someemail.com"
        smtp_envelope_from Mail::Constants::NULL_SENDER
      end
      expect(MockSMTP.deliveries[0][1]).to eq '<>'
      expect(MockSMTP.deliveries[0][2]).to eq %w(smtp_to@someemail.com)
    end

    it "should raise an error if there is no envelope From address" do
      mail = Mail.new do
        to "to@somemail.com"
        subject "Email with no sender"
        body "body"
      end

      expect(mail.smtp_envelope_from).to be_nil

      expect do
        mail.deliver
      end.to raise_error(ArgumentError, 'SMTP From address may not be blank: nil')
    end

    it "should raise an error if no recipient is defined" do
      mail = Mail.new do
        from "from@somemail.com"
        subject "Email with no recipient"
        body "body"
      end

      expect(mail.smtp_envelope_to).to eq([])

      expect do
        mail.deliver
      end.to raise_error(ArgumentError, 'SMTP To address may not be blank: []')
    end

    it "should raise on SMTP injection via MAIL FROM newlines" do
      addr = "inject.from@example.com>\r\nDATA"

      mail = Mail.new do
        from addr
        to "to@somemail.com"
      end

      expect(mail.smtp_envelope_from).to eq addr

      expect do
        mail.deliver
      end.to raise_error(ArgumentError, "SMTP From address may not contain CR or LF line breaks: #{addr.inspect}")
    end

    it "should raise on SMTP injection via RCPT TO newlines" do
      addr = "inject.to@example.com>\r\nDATA"

      mail = Mail.new do
        from "from@somemail.com"
        to addr
      end

      expect(mail.smtp_envelope_to).to eq [addr]

      expect do
        mail.deliver
      end.to raise_error(ArgumentError, "SMTP To address may not contain CR or LF line breaks: #{addr.inspect}")
    end

    it "should raise on SMTP injection via MAIL FROM overflow" do
      addr = "inject.from@example.com#{'m' * 2000}"

      mail = Mail.new do
        from addr
        to "to@somemail.com"
      end

      expect(mail.smtp_envelope_from).to eq addr

      expect do
        mail.deliver
      end.to raise_error(ArgumentError, "SMTP From address may not exceed 2000 bytes: #{addr.inspect}")
    end

    it "should raise on SMTP injection via RCPT TO overflow" do
      addr = "inject.to@example.com#{'m' * 2000}"

      mail = Mail.new do
        from "from@somemail.com"
        to addr
      end

      expect(mail.smtp_envelope_to).to eq [addr]

      expect do
        mail.deliver
      end.to raise_error(ArgumentError, "SMTP To address may not exceed 2000 bytes: #{addr.inspect}")
    end
  end
end
