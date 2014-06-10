# encoding: utf-8
require 'spec_helper'

describe "SMTP Delivery Method" do

  before(:each) do
    # Reset all defaults back to an original state
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
  
  after(:each) do
    files = Dir.glob(File.join(Mail.delivery_method.settings[:location], '*'))
    files.each do |file|
      File.delete(file)
    end
  end
  
  describe "general usage" do
    tmpdir = File.expand_path('../../../../tmp/mail', __FILE__)

    it "should send an email to a file" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
      end
      
      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com'
        subject 'invalid RFC2822'
      end
      
      delivery = File.join(Mail.delivery_method.settings[:location], 'marcel@amont.com')
      
      expect(File.read(delivery)).to eq mail.encoded
    end

    it "should send multiple emails to multiple files" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
      end
      
      mail = Mail.deliver do
        from    'roger@moore.com'
        to      'marcel@amont.com, bob@me.com'
        subject 'invalid RFC2822'
      end
      
      delivery_one = File.join(Mail.delivery_method.settings[:location], 'marcel@amont.com')
      delivery_two = File.join(Mail.delivery_method.settings[:location], 'bob@me.com')
      
      expect(File.read(delivery_one)).to eq mail.encoded
      expect(File.read(delivery_two)).to eq mail.encoded
    end

    it "should only create files based on the addr_spec of the destination" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
      end
      
      Mail.deliver do
        from    'roger@moore.com'
        to      '"Long, stupid email address" <mikel@test.lindsaar.net>'
        subject 'invalid RFC2822'
      end
      delivery = File.join(Mail.delivery_method.settings[:location], 'mikel@test.lindsaar.net')
      expect(File.exists?(delivery)).to be_truthy
    end

    it "should use the base name of the file name to prevent file system traversal" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
      end
      
      Mail.deliver do
        from    'roger@moore.com'
        to      '../../../../../../../../../../../tmp/pwn'
        subject 'evil hacker'
      end

      delivery = File.join(Mail.delivery_method.settings[:location], 'pwn')
      expect(File.exists?(delivery)).to be_truthy
    end

    it "should raise an error if no sender is defined" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
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
        delivery_method :file, :location => tmpdir
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
  
end
