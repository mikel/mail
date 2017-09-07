# encoding: utf-8
# frozen_string_literal: true
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
      expect(File.exist?(delivery)).to be_truthy
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
      expect(File.exist?(delivery)).to be_truthy
    end

    it "should not raise errors if no sender is defined" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
      end

      mail = Mail.new do
        to "to@somemail.com"
        subject "Email with no sender"
        body "body"
      end

      expect(mail.smtp_envelope_from).to be_nil

      expect do
        mail.deliver
      end.to raise_error('SMTP From address may not be blank: nil')
    end

    it "should raise an error if no recipient if defined" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir
      end

      mail = Mail.new do
        from "from@somemail.com"
        subject "Email with no recipient"
        body "body"
      end

      expect(mail.smtp_envelope_to).to eq([])

      expect do
        mail.deliver
      end.to raise_error('SMTP To address may not be blank: []')
    end

    it "should use the present name of the file name to prevent file system traversal" do
      Mail.defaults do
        delivery_method :file, :location => tmpdir, :filename => "mail"
      end

      Mail.deliver do
        from    'roger@moore.com'
        to      'to@somemail.com'
        subject "Email with no sender"
        body    "body"
      end

      delivery = File.join(Mail.delivery_method.settings[:location], 'mail')
      expect(File.exist?(delivery)).to be_truthy
    end
  end
end
