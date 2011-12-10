require 'spec_helper'

describe Mail::Configuration do

  describe "network configurations" do
    
    it "should be available from the Mail.defaults method" do
      Mail.defaults { delivery_method :smtp, { :address => 'some.host' } }
      Mail.delivery_method.settings[:address].should eql 'some.host'
    end

    it "should configure sendmail" do
      Mail.defaults { delivery_method :sendmail, :location => "/usr/bin/sendmail" }
      Mail.delivery_method.class.should eql Mail::Sendmail
      Mail.delivery_method.settings[:location].should eql "/usr/bin/sendmail"
    end
    
    it "should configure an open SMTP connection" do
      smtp = Net::SMTP.start('127.0.0.1', 25)
      Mail.defaults { delivery_method :smtp_connection, {:connection => smtp} }
      Mail.delivery_method.class.should eql Mail::SMTPConnection
      Mail.delivery_method.smtp.should eql smtp
    end
    
  end
end
