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
    
  end
end
