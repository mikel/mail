# encoding: utf-8
require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

describe "Deliverable" do

  describe "general usage" do

    before(:each) do
      config = Mail.defaults do
        delivery_method :smtp
        smtp 'smtp.mockup.com', 587 do
          enable_tls
        end
      end
      MockSMTP.clear_deliveries
    end

    it "should send emails from given settings" do

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      MockSMTP.deliveries[0][0].should == mail.encoded
      MockSMTP.deliveries[0][1].should == mail.from
      MockSMTP.deliveries[0][2].should == mail.destinations
    end

    it "should be able to send itself" do
      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      mail.deliver!

      MockSMTP.deliveries[0][0].should == mail.encoded
      MockSMTP.deliveries[0][1].should == mail.from
      MockSMTP.deliveries[0][2].should == mail.destinations
    end

    it "should raise if the SMTP configuration is not set" do
      config = Mail.defaults do
        smtp ''
      end

      doing { @deliverable.new.deliver! }.should raise_error
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
      config = Mail.defaults do
        smtp 'smtp.mockup.com', 587 do
          enable_tls
        end
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
      config = Mail.defaults do
        smtp 'smtp.mockup.com', 587 do
          enable_tls
        end
      end

      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end

      doing { mail.deliver! }.should_not raise_error(TypeError)
    end
    
    it "should preserve the return path" do
      mail = Mail.deliver do
        to "to@someemail.com"
        from "from@someemail.com"
        subject "Can't set the return-path"
        return_path "bounce@someemail.com" 
        message_id "<1234@someemail.com>"
        body "body"
      end
      delivered_mail = Mail.new(MockSMTP.deliveries[0][0])
      delivered_mail.return_path.should == "bounce@someemail.com"
      delivered_mail.from.should == "from@someemail.com"
    end
    
  end
  
end
