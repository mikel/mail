# encoding: utf-8
require 'spec_helper'

describe "SMTP Delivery Method" do

  before(:each) do
    # Reset all defaults back to original state
    Mail.defaults do
      delivery_method :smtp, { :address              => "localhost",
                               :port                 => 25,
                               :domain               => 'localhost.localdomain',
                               :user_name            => nil,
                               :password             => nil,
                               :authentication       => nil,
                               :enable_starttls_auto => true,
                               :openssl_verify_mode  => nil,
                               :tls                  => nil,
                               :ssl                  => nil
                                }
    end
    MockSMTP.clear_deliveries
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

      expect(doing { mail.deliver! }).not_to raise_error
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

      expect(doing { mail.deliver! }).not_to raise_error
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

      expect(doing { mail.deliver! }).not_to raise_error
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

      expect(doing { mail.deliver! }).not_to raise_error
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

    it "should raise if there is no envelope From address" do
      expect do
        Mail.deliver do
          to "to@somemail.com"
          subject "Email with no sender"
          body "body"
        end
      end.to raise_error('An SMTP From address is required to send a message. Set the message smtp_envelope_from, return_path, sender, or from address.')
    end

    it "should raise an error if no recipient if defined" do
      expect do
        Mail.deliver do
          from "from@somemail.com"
          subject "Email with no recipient"
          body "body"
        end
      end.to raise_error('An SMTP To address is required to send a message. Set the message smtp_envelope_to, to, cc, or bcc address.')
    end
  end

end
