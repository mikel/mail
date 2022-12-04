# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe "mail" do
  
  it "should be able to be instantiated" do
    expect { Mail }.not_to raise_error
  end

  it "should be able to make a new email" do
    expect(Mail.new.class).to eq Mail::Message
  end

  it "should accept headers and body" do
    # Full tests in Message Spec
    message = Mail.new do
      from    'mikel@me.com'
      to      'mikel@you.com'
      subject 'Hello there Mikel'
      body    'This is a body of text'
    end
    expect(message.from).to      eq ['mikel@me.com']
    expect(message.to).to        eq ['mikel@you.com']
    expect(message.subject).to   eq 'Hello there Mikel'
    expect(message.body.to_s).to eq 'This is a body of text'
  end

  it "should read a file" do
    wrap_method = read_fixture('emails', 'plain_emails', 'raw_email.eml').to_s
    file_method = Mail.new(read_raw_fixture('emails', 'plain_emails', 'raw_email.eml')).to_s
    expect(wrap_method).to eq file_method
  end

  describe "delivery_interceptors" do

    class InterceptorAgentOne
      @@intercept = false
      def self.intercept=(val)
        @@intercept = val
      end
      def self.delivering_email(mail)
        if @@intercept
          mail.to = 'bob@example.com'
        end
      end
    end

    class InterceptorAgentTwo
      @@intercept = false
      def self.intercept=(val)
        @@intercept = val
      end
      def self.delivering_email(mail)
        if @@intercept
          mail.to = 'bob@example.com'
        end
      end
    end

    it "should return empty array if no interceptors have been registered" do
      expect(Mail.delivery_interceptors).to eq []
    end

    it "should return array of registered delivery interceptors" do
      Mail.register_interceptor(InterceptorAgentOne)
      expect(Mail.delivery_interceptors).to eq [InterceptorAgentOne]
      Mail.register_interceptor(InterceptorAgentTwo)
      expect(Mail.delivery_interceptors).to eq [InterceptorAgentOne, InterceptorAgentTwo]
      Mail.unregister_interceptor(InterceptorAgentOne)
      expect(Mail.delivery_interceptors).to eq [InterceptorAgentTwo]
    end

  end

end
