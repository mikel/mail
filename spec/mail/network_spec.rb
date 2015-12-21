# encoding: utf-8
require 'spec_helper'

class MyDelivery; def initialize(settings); end; end

class MyRetriever; def initialize(settings); end; end

describe "Mail" do

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

      retriever_method :pop3, { :address             => "localhost",
                                :port                => 110,
                                :user_name           => nil,
                                :password            => nil,
                                :enable_ssl          => true }
    end
  end

  describe "default delivery and retriever methods" do

    it "should set the delivery method" do
      Mail.defaults do
        delivery_method :smtp
      end
      expect(Mail.delivery_method.class).to eq Mail::SMTP
    end

    it "should default to settings for smtp" do
      expect(Mail.delivery_method.class).to eq Mail::SMTP
      expect(Mail.delivery_method.settings).to eql({:address              => "localhost",
                                                :port                 => 25,
                                                :domain               => 'localhost.localdomain',
                                                :user_name            => nil,
                                                :password             => nil,
                                                :authentication       => nil,
                                                :enable_starttls_auto => true,
                                                :openssl_verify_mode  => nil,
                                                :ssl                  => nil,
                                                :tls                  => nil })
    end

    it "should set the retriever method" do
      Mail.defaults do
        retriever_method :pop3
      end
      expect(Mail.retriever_method.class).to eq Mail::POP3
    end

    it "should default to settings for pop3" do
      expect(Mail.retriever_method.class).to eq Mail::POP3
      expect(Mail.retriever_method.settings).to eql({:address              => "localhost",
                                                 :port                 => 110,
                                                 :user_name            => nil,
                                                 :password             => nil,
                                                 :authentication       => nil,
                                                 :enable_ssl           => true  })
    end

    it "should allow us to overwrite anything we need on SMTP" do
      Mail.defaults do
        delivery_method :smtp, :port => 999
      end
      expect(Mail.delivery_method.settings[:address]).to eq 'localhost'
      expect(Mail.delivery_method.settings[:port]).to eq 999
    end

    it "should allow us to overwrite anything we need on POP3" do
      Mail.defaults do
        retriever_method :pop3, :address => 'foo.bar.com'
      end
      expect(Mail.retriever_method.settings[:address]).to eq 'foo.bar.com'
      expect(Mail.retriever_method.settings[:port]).to eq 110
    end

    it "should allow you to pass in your own delivery method" do
      Mail.defaults do
        delivery_method MyDelivery
      end
      expect(Mail.delivery_method.class).to eq MyDelivery
    end

    it "should ask the custom delivery agent for its settings" do
      mock_my_delivery = double(MyDelivery)
      expect(mock_my_delivery).to receive(:settings).and_return({:these_are => :settings})
      expect(MyDelivery).to receive(:new).and_return(mock_my_delivery)
      Mail.defaults do
        delivery_method MyDelivery
      end
      expect(Mail.delivery_method.settings).to eql({:these_are => :settings})
    end

    it "should allow you to pass in your own retriever method" do
      Mail.defaults do
        retriever_method MyRetriever
      end
      expect(Mail.retriever_method.class).to eq MyRetriever
    end

    it "should ask the custom retriever agent for its settings" do
      mock_my_retriever = double(MyRetriever)
      expect(mock_my_retriever).to receive(:settings).and_return({:these_are => :settings})
      expect(MyRetriever).to receive(:new).and_return(mock_my_retriever)
      Mail.defaults do
        retriever_method MyRetriever
      end
      expect(Mail.retriever_method.settings).to eql({:these_are => :settings})
    end

  end

  describe "instance delivery methods" do

    it "should copy the defaults defined by Mail.defaults" do
      mail = Mail.new
      expect(mail.delivery_method.class).to eq Mail::SMTP
    end

    it "should be able to change the delivery_method" do
      mail = Mail.new
      mail.delivery_method :file
      expect(mail.delivery_method.class).to eq Mail::FileDelivery
    end

    it "should be able to change the delivery_method and pass in settings" do
      mail = Mail.new
      tmpdir = File.expand_path('../../../tmp/mail', __FILE__)
      mail.delivery_method :file, :location => tmpdir
      expect(mail.delivery_method.class).to eq Mail::FileDelivery
      expect(mail.delivery_method.settings).to eql({:location => tmpdir})
    end

    it "should not change the default when it changes the delivery_method" do
      mail1 = Mail.new
      mail2 = Mail.new
      mail1.delivery_method :file
      expect(Mail.delivery_method.class).to eq Mail::SMTP
      expect(mail1.delivery_method.class).to eq Mail::FileDelivery
      expect(mail2.delivery_method.class).to eq Mail::SMTP
    end

    it "should not change the default settings when it changes the delivery_method settings" do
      mail1 = Mail.new
      mail2 = Mail.new
      mail1.delivery_method :smtp, :address => 'my.own.address'
      expect(Mail.delivery_method.settings[:address]).to eq 'localhost'
      expect(mail1.delivery_method.settings[:address]).to eq 'my.own.address'
      expect(mail2.delivery_method.settings[:address]).to eq 'localhost'
    end

  end

  describe "retrieving emails via POP3" do
    it "should retrieve all emails via POP3" do
      messages = Mail.all

      expect(messages).not_to be_empty
      for message in messages
        expect(message).to be_instance_of(Mail::Message)
      end
    end
  end

  describe "sending emails via SMTP" do

    before(:each) do
      # Set the delivery method to test as the default
      MockSMTP.clear_deliveries
    end

    it "should deliver a mail message" do
      message = Mail.deliver do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        # add_file 'New Header Image', '/somefile.png'
      end

      expect(MockSMTP.deliveries[0][0]).to eq message.encoded
      expect(MockSMTP.deliveries[0][1]).to eq "mikel@test.lindsaar.net"
      expect(MockSMTP.deliveries[0][2]).to eq ["ada@test.lindsaar.net"]
    end

    it "should deliver itself" do
      message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
        # add_file 'New Header Image', '/somefile.png'
      end

      message.deliver!

      expect(MockSMTP.deliveries[0][0]).to eq message.encoded
      expect(MockSMTP.deliveries[0][1]).to eq "mikel@test.lindsaar.net"
      expect(MockSMTP.deliveries[0][2]).to eq ["ada@test.lindsaar.net"]
    end

  end

  describe "deliveries" do

    class MyDeliveryMethod
      attr_accessor :settings
      def initialize(values = {}); end
      def deliver!(message); true; end
    end

    class MyObserver
      def self.delivered_email(message); end
    end

    class MyDeliveryHandler
      def deliver_mail(mail)
        postman = MyDeliveryMethod.new
        postman.deliver!(mail)
      end
    end

    class MyYieldingDeliveryHandler
      def deliver_mail(mail)
        yield
      end
    end

    before(:each) do
      @message = Mail.new do
        from 'mikel@test.lindsaar.net'
        to 'ada@test.lindsaar.net'
        subject 'Re: No way!'
        body 'Yeah sure'
      end
      @message.delivery_method :test
    end

    describe "adding to Mail.deliveries" do
      it "should add itself to the deliveries collection on mail on delivery" do
        expect { @message.deliver }.to change(Mail::TestMailer.deliveries, :size).by(1)
      end
    end

    describe "perform_deliveries" do
      it "should call deliver! on the delivery method by default" do
        delivery_agent = MyDeliveryMethod.new
        expect(@message).to receive(:delivery_method).and_return(delivery_agent)
        expect(delivery_agent).to receive(:deliver!).with(@message)
        @message.deliver
      end

      it "should not call deliver if perform deliveries is set to false" do
        @message.perform_deliveries = false
        delivery_agent = MyDeliveryMethod.new
        expect(@message).not_to receive(:delivery_method)
        expect(delivery_agent).not_to receive(:deliver!)
        @message.deliver
      end

      it "should add to the deliveries array if perform_deliveries is true" do
        @message.perform_deliveries = true
        expect { @message.deliver }.to change(Mail::TestMailer.deliveries, :size).by(1)
      end

      it "should not add to the deliveries array if perform_deliveries is false" do
        @message.perform_deliveries = false
        expect { @message.deliver }.not_to change(Mail::TestMailer.deliveries, :size)
      end
    end

    describe "observers" do
      it "should tell its observers that it was told to deliver an email" do
        Mail.register_observer(MyObserver)
        expect(MyObserver).to receive(:delivered_email).with(@message).once
        @message.deliver
      end

      it "should tell its observers that it was told to deliver an email even if perform_deliveries is false" do
        Mail.register_observer(MyObserver)
        @message.perform_deliveries = false
        expect(MyObserver).to receive(:delivered_email).with(@message).once
        @message.deliver
      end

      it "should tell its observers that it was told to deliver an email even if it is using a delivery_handler" do
        Mail.register_observer(MyObserver)
        @message.delivery_handler = MyYieldingDeliveryHandler.new
        @message.perform_deliveries = false
        expect(MyObserver).to receive(:delivered_email).with(@message).once
        @message.deliver
      end

    end

    describe "raise_delivery_errors" do
      it "should pass on delivery errors if raised" do
        delivery_agent = MyDeliveryMethod.new
        allow(@message).to receive(:delivery_method).and_return(delivery_agent)
        allow(delivery_agent).to receive(:deliver!).and_raise(StandardError)
        expect { @message.deliver }.to raise_error(StandardError)
      end

      it "should not pass on delivery errors if raised raise_delivery_errors is set to false" do
        delivery_agent = MyDeliveryMethod.new
        allow(@message).to receive(:delivery_method).and_return(delivery_agent)
        @message.raise_delivery_errors = false
        allow(delivery_agent).to receive(:deliver!).and_raise(StandardError)
        expect { @message.deliver }.not_to raise_error
      end

      it "should pass through Exceptions even when raise_delivery_errors is set to false" do
        delivery_agent = MyDeliveryMethod.new
        allow(@message).to receive(:delivery_method).and_return(delivery_agent)
        @message.raise_delivery_errors = false
        allow(delivery_agent).to receive(:deliver!).and_raise(Exception)
        expect { @message.deliver }.to raise_error(Exception)
      end
    end

    describe "delivery_handler" do

      it "should allow you to hand off performing the actual delivery to another object" do
        delivery_handler = MyYieldingDeliveryHandler.new
        expect(delivery_handler).to receive(:deliver_mail).with(@message).exactly(:once)
        @message.delivery_handler = delivery_handler
        @message.deliver
      end

      it "mail should be told to :deliver once and then :deliver! once by the delivery handler" do
        @message.delivery_handler = MyYieldingDeliveryHandler.new
        expect(@message).to receive(:do_delivery).exactly(:once)
        @message.deliver
      end

      it "mail only call its delivery_method once" do
        @message.delivery_handler = MyYieldingDeliveryHandler.new
        expect(@message).to receive(:delivery_method).exactly(:once).and_return(Mail::TestMailer.new({}))
        @message.deliver
      end

      it "mail should not catch any exceptions when using a delivery_handler" do
        @message.delivery_handler = MyYieldingDeliveryHandler.new
        expect(@message).to receive(:delivery_method).and_raise(Exception)
        expect { @message.deliver }.to raise_error(Exception)
      end

      it "mail should not modify the Mail.deliveries object if using a delivery_handler that does not append to deliveries" do
        @message.delivery_handler = MyDeliveryHandler.new
        expect { @message.deliver }.not_to change(Mail::TestMailer, :deliveries)
      end

      it "should be able to just yield and let mail do its thing" do
        @message.delivery_handler = MyYieldingDeliveryHandler.new
        expect(@message).to receive(:do_delivery).exactly(:once)
        @message.deliver
      end

    end

  end

end
