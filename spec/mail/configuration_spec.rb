require 'spec_helper'

class MyTestDeliveryMethod
  attr_accessor :settings

  def initialize(values)
    self.settings = {}.merge!(values)
  end
end

describe Mail::Configuration do

  describe "network configurations" do

    it "defaults delivery_method to smtp" do
      # Need to clear out any prior configuration, as setting nil on the config
      # will not clear it.
      Mail::Configuration.instance.send(:initialize)
      Mail.defaults { delivery_method nil, { :address => 'some.host' } }
      expect(Mail.delivery_method.settings[:address]).to eq 'some.host'
    end

    it "should be available from the Mail.defaults method" do
      Mail.defaults { delivery_method :smtp, { :address => 'some.host' } }
      expect(Mail.delivery_method.settings[:address]).to eq 'some.host'
    end

    it "should configure sendmail" do
      Mail.defaults { delivery_method :sendmail, :location => "/usr/bin/sendmail" }
      expect(Mail.delivery_method.class).to eq Mail::Sendmail
      expect(Mail.delivery_method.settings[:location]).to eq "/usr/bin/sendmail"
    end

    it "should configure sendmail using a string" do
      Mail.defaults { delivery_method 'sendmail', :location => "/usr/bin/sendmail" }
      expect(Mail.delivery_method.class).to eq Mail::Sendmail
      expect(Mail.delivery_method.settings[:location]).to eq "/usr/bin/sendmail"
    end

    it "should configure exim" do
      Mail.defaults { delivery_method :exim, :location => "/usr/bin/exim" }
      expect(Mail.delivery_method.class).to eq Mail::Exim
      expect(Mail.delivery_method.settings[:location]).to eq "/usr/bin/exim"
    end

    it "should configure an open SMTP connection" do
      smtp = Net::SMTP.start('127.0.0.1', 25)
      Mail.defaults { delivery_method :smtp_connection, {:connection => smtp} }
      expect(Mail.delivery_method.class).to eq Mail::SMTPConnection
      expect(Mail.delivery_method.smtp).to eq smtp
    end

    it "should accept a plug-in delivery method" do
      Mail.defaults { delivery_method MyTestDeliveryMethod, { :option1 => "one", :option2 => "two" }}
      expect(Mail.delivery_method.class).to eq MyTestDeliveryMethod
      expect(Mail.delivery_method.settings[:option1]).to eq "one"
      expect(Mail.delivery_method.settings[:option2]).to eq "two"
    end

  end
end
