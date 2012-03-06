# encoding: utf-8
require 'spec_helper'

describe "sendmail delivery agent" do
  
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
    end
  end

  it "should send an email using sendmail" do
    Mail.defaults do
      delivery_method :sendmail
    end
    
    mail = Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'invalid RFC2822'
    end
    
    Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail', 
                                              '-i -t -f "roger@test.lindsaar.net"', 
                                              'marcel@test.lindsaar.net bob@test.lindsaar.net', 
                                              mail)
    mail.deliver!
  end

  describe "return path" do

    it "should send an email with a return-path using sendmail" do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to "to@test.lindsaar.net"
        from "from@test.lindsaar.net"
        sender "sender@test.lindsaar.net"
        subject "Can't set the return-path"
        return_path "return@test.lindsaar.net"
        message_id "<1234@test.lindsaar.net>"
        body "body"
      end
      
      Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail',
                                                '-i -t -f "return@test.lindsaar.net"', 
                                                'to@test.lindsaar.net', 
                                                mail)
                                                
      mail.deliver

    end

    it "should use the sender address is no return path is specified" do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to "to@test.lindsaar.net"
        from "from@test.lindsaar.net"
        sender "sender@test.lindsaar.net"
        subject "Can't set the return-path"
        message_id "<1234@test.lindsaar.net>"
        body "body"
      end

      Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail',
                                                '-i -t -f "sender@test.lindsaar.net"', 
                                                'to@test.lindsaar.net', 
                                                mail)

      mail.deliver
    end
    
    it "should use the from address is no return path or sender are specified" do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to "to@test.lindsaar.net"
        from "from@test.lindsaar.net"
        subject "Can't set the return-path"
        message_id "<1234@test.lindsaar.net>"
        body "body"
      end

      Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail',
                                                '-i -t -f "from@test.lindsaar.net"', 
                                                'to@test.lindsaar.net', 
                                                mail)
      mail.deliver
    end

    it "should escape the return path address" do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to 'to@test.lindsaar.net'
        from '"from+suffix test"@test.lindsaar.net'
        subject 'Can\'t set the return-path'
        message_id '<1234@test.lindsaar.net>'
        body 'body'
      end

      Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail',
                                                '-i -t -f "\"from+suffix test\"@test.lindsaar.net"',
                                                'to@test.lindsaar.net',
                                                mail)
      mail.deliver
    end
  end

  it "should still send an email if the settings have been set to nil" do
    Mail.defaults do
      delivery_method :sendmail, :arguments => nil
    end
    
    mail = Mail.new do
      from    'from@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'invalid RFC2822'
    end
    
    Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail', 
                                              '-f "from@test.lindsaar.net"', 
                                              'marcel@test.lindsaar.net bob@test.lindsaar.net', 
                                              mail)
    mail.deliver!
  end

  it "should escape evil haxxor attemptes" do
    Mail.defaults do
      delivery_method :sendmail, :arguments => nil
    end
    
    mail = Mail.new do
      from    '"foo\";touch /tmp/PWNED;\""@blah.com'
      to      '"foo\";touch /tmp/PWNED;\""@blah.com'
      subject 'invalid RFC2822'
    end
    
    Mail::Sendmail.should_receive(:call).with('/usr/sbin/sendmail', 
                                              "-f \"\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com\"", 
                                              "\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com", 
                                              mail)
    mail.deliver!
  end
end
