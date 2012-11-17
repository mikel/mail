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
      end

      MockSMTP.deliveries[0][0].should eq mail.encoded
      MockSMTP.deliveries[0][1].should eq mail.from[0]
      MockSMTP.deliveries[0][2].should eq mail.destinations
    end

    it "should be able to send itself" do
      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      mail.deliver!

      MockSMTP.deliveries[0][0].should eq mail.encoded
      MockSMTP.deliveries[0][1].should eq mail.from[0]
      MockSMTP.deliveries[0][2].should eq mail.destinations
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
      response.should eq 'OK'
      
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

      doing { mail.deliver! }.should_not raise_error(TypeError)
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

      doing { mail.deliver! }.should_not raise_error(TypeError)
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

      doing { mail.deliver! }.should_not raise_error(TypeError)
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

      doing { mail.deliver! }.should_not raise_error(TypeError)
    end
  end
  
  describe "return path" do

    it "should use the return path if specified" do
      Mail.deliver do
        to "to@someemail.com"
        from "from@someemail.com"
        sender "sender@test.lindsaar.net"
        subject "Can't set the return-path"
        return_path "bounce@someemail.com" 
        message_id "<1234@someemail.com>"
        body "body"
      end
      MockSMTP.deliveries[0][1].should eq "bounce@someemail.com"
    end

    it "should use the sender address is no return path is specified" do
      Mail.deliver do
        to "to@someemail.com"
        from "from@someemail.com"
        sender "sender@test.lindsaar.net"
        subject "Can't set the return-path"
        message_id "<1234@someemail.com>"
        body "body"
      end
      MockSMTP.deliveries[0][1].should eq "sender@test.lindsaar.net"
    end
    
    it "should use the from address is no return path or sender is specified" do
      Mail.deliver do
        to "to@someemail.com"
        from "from@someemail.com"
        subject "Can't set the return-path"
        message_id "<1234@someemail.com>"
        body "body"
      end
      MockSMTP.deliveries[0][1].should eq "from@someemail.com"
    end

    it "should raise an error if no sender is defined" do
      lambda do
        Mail.deliver do
          to "to@somemail.com"
          subject "Email with no sender"
          body "body"
        end
       end.should raise_error('A sender (Return-Path, Sender or From) required to send a message')
    end

    it "should raise an error if no recipient if defined" do
      lambda do
        Mail.deliver do
          from "from@somemail.com"
          subject "Email with no recipient"
          body "body"
        end
       end.should raise_error('At least one recipient (To, Cc or Bcc) is required to send a message')
    end
  end
  
end
