require 'spec_helper'

describe Mail::Configuration do

  describe "network configurations" do
    
    it "should be available from the Mail.defaults method" do
      Mail.defaults { delivery_method :smtp, { :address => 'some.host' } }
      Mail.delivery_method.settings[:address].should == 'some.host'
    end

    it "should configure sendmail" do
      Mail.defaults { delivery_method :sendmail, :location => "/usr/bin/sendmail" }
      Mail.delivery_method.class.should == Mail::Sendmail
      Mail.delivery_method.settings[:location].should == "/usr/bin/sendmail"
    end
    
    it "should configure an open SMTP connection" do
      smtp = Net::SMTP.start('127.0.0.1', 25)
      Mail.defaults { delivery_method :smtp_connection, {:connection => smtp} }
      Mail.delivery_method.class.should == Mail::SMTPConnection
      Mail.delivery_method.smtp.should == smtp
    end

    it "should accept a plug-in delivery method" do
      class MyDeliveryMethod
        attr_accessor :settings

        def initialize(values)
          self.settings = {}.merge!(values)
        end
      end

      Mail.defaults { delivery_method MyDeliveryMethod, { :option1 => "one", :option2 => "two" }}
      Mail.delivery_method.class.should == MyDeliveryMethod
      Mail.delivery_method.settings[:option1].should == "one"
      Mail.delivery_method.settings[:option2].should == "two"
    end
    
  end
end
