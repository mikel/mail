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
    
    expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail', 
                                              '-i -f "roger@test.lindsaar.net" --',
                                              '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"', 
                                              mail.encoded)
    mail.deliver!
  end

  it "should spawn a sendmail process" do
    Mail.defaults do
      delivery_method :sendmail
    end

    mail = Mail.new do
      from    'roger@test.lindsaar.net'
      to      'marcel@test.lindsaar.net, bob@test.lindsaar.net'
      subject 'invalid RFC2822'
    end

    expect(Mail::Sendmail).to receive(:popen).with('/usr/sbin/sendmail -i -f "roger@test.lindsaar.net" -- "marcel@test.lindsaar.net" "bob@test.lindsaar.net"')

    mail.deliver!
  end

  describe 'SMTP From' do

    it 'should explicitly pass an envelope From address to sendmail' do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to "to@test.lindsaar.net"
        from "from@test.lindsaar.net"
        subject 'Can\'t set the return-path'
        message_id "<1234@test.lindsaar.net>"
        body "body"

        smtp_envelope_from 'smtp_from@test.lindsaar.net'
      end

      expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail',
                                                '-i -f "smtp_from@test.lindsaar.net" --',
                                                '"to@test.lindsaar.net"', 
                                                mail.encoded)

      mail.deliver

    end

    it "should escape the From address" do
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

      expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail',
                                                '-i -f "\"from+suffix test\"@test.lindsaar.net" --',
                                                '"to@test.lindsaar.net"',
                                                mail.encoded)
      mail.deliver
    end
  end

  describe 'SMTP To' do

    it 'should explicitly pass envelope To addresses to sendmail' do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to "to@test.lindsaar.net"
        from "from@test.lindsaar.net"
        subject 'Can\'t set the return-path'
        message_id "<1234@test.lindsaar.net>"
        body "body"

        smtp_envelope_to 'smtp_to@test.lindsaar.net'
      end

      expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail',
                                                '-i -f "from@test.lindsaar.net" --',
                                                '"smtp_to@test.lindsaar.net"',
                                                mail.encoded)
      mail.deliver
    end

    it "should escape the To address" do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to '"to+suffix test"@test.lindsaar.net'
        from 'from@test.lindsaar.net'
        subject 'Can\'t set the return-path'
        message_id '<1234@test.lindsaar.net>'
        body 'body'
      end

      expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail',
                                                '-i -f "from@test.lindsaar.net" --',
                                                '"\"to+suffix test\"@test.lindsaar.net"',
                                                mail.encoded)
      mail.deliver
    end

    it "should quote the destinations to ensure leading -hyphen doesn't confuse sendmail" do
      Mail.defaults do
        delivery_method :sendmail
      end

      mail = Mail.new do
        to '-hyphen@test.lindsaar.net'
        from 'from@test.lindsaar.net'
      end

      expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail',
                                                '-i -f "from@test.lindsaar.net" --',
                                                '"-hyphen@test.lindsaar.net"',
                                                mail.encoded)
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
    
    expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail', 
                                              ' -f "from@test.lindsaar.net" --',
                                              '"marcel@test.lindsaar.net" "bob@test.lindsaar.net"', 
                                              mail.encoded)
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
    
    expect(Mail::Sendmail).to receive(:call).with('/usr/sbin/sendmail', 
                                              " -f \"\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com\" --",
                                              %("\\\"foo\\\\\\\"\\;touch /tmp/PWNED\\;\\\\\\\"\\\"@blah.com"), 
                                              mail.encoded)
    mail.deliver!
  end

  it "should raise an error if no sender is defined" do
    Mail.defaults do
      delivery_method :test
    end
    expect do
      Mail.deliver do
        to "to@somemail.com"
        subject "Email with no sender"
        body "body"
      end
    end.to raise_error('An SMTP From address is required to send a message. Set the message smtp_envelope_from, return_path, sender, or from address.')
  end

  it "should raise an error if no recipient if defined" do
    Mail.defaults do
      delivery_method :test
    end
    expect do
      Mail.deliver do
        from "from@somemail.com"
        subject "Email with no recipient"
        body "body"
      end
    end.to raise_error('An SMTP To address is required to send a message. Set the message smtp_envelope_to, to, cc, or bcc address.')
  end
end
