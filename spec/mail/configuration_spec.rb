require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

describe Mail::Configuration do

  describe "network configurations" do
    it "should be a singleton for the whole class" do
      config1 = Mail::Configuration.instance
      config2 = Mail::Configuration.instance
      config1.should == config2
    end
    
    it "should provide itself from Mail.defaults" do
      config1 = Mail.defaults { smtp 'localhost' }
      config2 = Mail.defaults
      config1.should == config2
      config1.smtp.host.should == 'localhost'
    end
    
    it "should be available from the Mail.defaults method" do
      Mail.defaults { smtp 'myhost.com' }
      Mail.defaults.smtp.host.should == 'myhost.com'
    end
    
  end

  it "should configure sendmail" do
    Mail.defaults { sendmail "/usr/bin/sendmail" }
    Mail.defaults.delivery_method.should == Mail::Sendmail
    Mail.defaults.sendmail.path.should == "/usr/bin/sendmail"
  end
end
