# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'spec_helper')

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
      Mail.delivery_method.class.should == Mail::SMTP
    end
    
    it "should default to settings for smtp" do
      Mail.delivery_method.class.should == Mail::SMTP
      Mail.delivery_method.settings.should == { :address              => "localhost",
                                                :port                 => 25,
                                                :domain               => 'localhost.localdomain',
                                                :user_name            => nil,
                                                :password             => nil,
                                                :authentication       => nil,
                                                :enable_starttls_auto => true  }
    end

    it "should set the retriever method" do
      Mail.defaults do
        retriever_method :pop3
      end
      Mail.retriever_method.class.should == Mail::POP3
    end

    it "should default to settings for pop3" do
      Mail.retriever_method.class.should == Mail::POP3
      Mail.retriever_method.settings.should == { :address              => "localhost",
                                                 :port                 => 110,
                                                 :user_name            => nil,
                                                 :password             => nil,
                                                 :authentication       => nil,
                                                 :enable_ssl           => true  }
    end

    it "should allow us to overwrite anything we need on SMTP" do
      Mail.defaults do
        delivery_method :smtp, :port => 999
      end
      Mail.delivery_method.settings[:address].should == 'localhost'
      Mail.delivery_method.settings[:port].should == 999
    end

    it "should allow us to overwrite anything we need on POP3" do
      Mail.defaults do
        retriever_method :pop3, :address => 'foo.bar.com'
      end
      Mail.retriever_method.settings[:address].should == 'foo.bar.com'
      Mail.retriever_method.settings[:port].should == 110
    end

    it "should allow you to pass in your own delivery method" do
      Mail.defaults do
        delivery_method MyDelivery
      end
      Mail.delivery_method.class.should == MyDelivery
    end

    it "should ask the custom delivery agent for it's settings" do
      mock_my_delivery = mock(MyDelivery)
      mock_my_delivery.should_receive(:settings).and_return({:these_are => :settings})
      MyDelivery.should_receive(:new).and_return(mock_my_delivery)
      Mail.defaults do
        delivery_method MyDelivery
      end
      Mail.delivery_method.settings.should == {:these_are => :settings}
    end

    it "should allow you to pass in your own retriever method" do
      Mail.defaults do
        retriever_method MyRetriever
      end
      Mail.retriever_method.class.should == MyRetriever
    end

    it "should ask the custom retriever agent for it's settings" do
      mock_my_retriever = mock(MyRetriever)
      mock_my_retriever.should_receive(:settings).and_return({:these_are => :settings})
      MyRetriever.should_receive(:new).and_return(mock_my_retriever)
      Mail.defaults do
        retriever_method MyRetriever
      end
      Mail.retriever_method.settings.should == {:these_are => :settings}
    end

  end

  describe "instance delivery methods" do
    
    it "should copy the defaults defined by Mail.defaults" do
      mail = Mail.new
      mail.delivery_method.class.should == Mail::SMTP
    end
  
    it "should be able to change the delivery_method" do
      mail = Mail.new
      mail.delivery_method :file
      mail.delivery_method.class.should == Mail::FileDelivery
    end

    it "should be able to change the delivery_method and pass in settings" do
      mail = Mail.new
      mail.delivery_method :file, :location => '/tmp'
      mail.delivery_method.class.should == Mail::FileDelivery
      mail.delivery_method.settings.should == {:location => '/tmp'}
    end
  
    it "should not change the default when it changes the delivery_method" do
      mail1 = Mail.new
      mail2 = Mail.new
      mail1.delivery_method :file
      Mail.delivery_method.class.should == Mail::SMTP
      mail1.delivery_method.class.should == Mail::FileDelivery
      mail2.delivery_method.class.should == Mail::SMTP
    end
  
    it "should not change the default settings when it changes the delivery_method settings" do
      mail1 = Mail.new
      mail2 = Mail.new
      mail1.delivery_method :smtp, :address => 'my.own.address'
      Mail.delivery_method.settings[:address].should == 'localhost'
      mail1.delivery_method.settings[:address].should == 'my.own.address'
      mail2.delivery_method.settings[:address].should == 'localhost'
    end

  end
  
  describe "retrieving emails via POP3" do
    it "should retrieve all emails via POP3" do
      messages = Mail.all

      messages.should_not be_empty
      for message in messages
        message.should be_instance_of(Mail::Message)
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

      MockSMTP.deliveries[0][0].should == message.encoded
      MockSMTP.deliveries[0][1].should == "mikel@test.lindsaar.net"
      MockSMTP.deliveries[0][2].should == ["ada@test.lindsaar.net"]
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

      MockSMTP.deliveries[0][0].should == message.encoded
      MockSMTP.deliveries[0][1].should == "mikel@test.lindsaar.net"
      MockSMTP.deliveries[0][2].should == ["ada@test.lindsaar.net"]
    end
    
  end
  
end
