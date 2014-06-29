# encoding: utf-8
require 'spec_helper'

describe "IMAP Retriever" do

  before(:each) do
    Mail.defaults do
      retriever_method :imap, { :address    => 'localhost',
                                :port       => 993,
                                :user_name  => nil,
                                :password   => nil,
                                :enable_ssl => true }
    end
  end

  describe "find with and without block" do
    it "should find all emails with a given block" do
      expect(MockIMAP).to be_disconnected

      messages = []
      Mail.all do |message|
        messages << message
      end
      expect(messages.map { |m| m.raw_source }.sort).to eq MockIMAP.examples.map { |m| m.attr['RFC822']}.sort

      expect(MockIMAP).to be_disconnected
    end
    it "should get all emails without a given block" do
      expect(MockIMAP).to be_disconnected

      messages = Mail.all
      expect(messages.map { |m| m.raw_source }.sort).to eq MockIMAP.examples.map { |m| m.attr['RFC822']}.sort

      expect(MockIMAP).to be_disconnected
    end
    it "should get all emails and yield the imap, uid, and email when given a block of arity 3" do
      expect(MockIMAP).to be_disconnected

      messages = []
      uids = []
      Mail.all do |message, imap, uid|
        expect(MockIMAP).to be === imap
        messages << message
        uids << uid
      end
      expect(messages.map { |m| m.raw_source }.sort).to eq MockIMAP.examples.map { |m| m.attr['RFC822']}.sort
      expect(uids.sort).to eq MockIMAP.examples.map { |m| m.number }.sort

      expect(MockIMAP).to be_disconnected
    end
  end

  describe "find and options" do
    it "should handle the :count option" do
      messages = Mail.find(:count => :all, :what => :last, :order => :asc)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }

      message = Mail.find(:count => 1, :what => :last)
      expect(message.raw_source).to eq MockIMAP.examples.last.attr['RFC822']

      messages = Mail.find(:count => 2, :what => :last, :order => :asc)
      expect(messages[0..1].map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }[-2..-1]
    end
    it "should handle the :what option" do
      messages = Mail.find(:count => :all, :what => :last)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }

      messages = Mail.find(:count => 2, :what => :first, :order => :asc)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }[0..1]
    end
    it "should handle the :order option" do
      messages = Mail.find(:order => :desc, :count => 5, :what => :last)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }[-5..-1].reverse

      messages = Mail.find(:order => :asc, :count => 5, :what => :last)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }[-5..-1]
    end
    it "should handle the :mailbox option" do
      Mail.find(:mailbox => 'SOME-RANDOM-MAILBOX')

      expect(MockIMAP.mailbox).to eq 'SOME-RANDOM-MAILBOX'
    end
    it "should handle the :uid option" do
      messages = Mail.find(:uid => 1)

      expect(messages[0].raw_source).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }[1]
    end
    it "should find the last 10 messages by default" do
      messages = Mail.find

      expect(messages.size).to eq 10
    end
    it "should search the mailbox 'INBOX' by default" do
      Mail.find

      expect(MockIMAP.mailbox).to eq 'INBOX'
    end

    it "should handle the delete_after_find_option" do
      Mail.find(:delete_after_find => false)
      expect(MockIMAP.examples.size).to eq 20

      Mail.find(:delete_after_find => true)
      expect(MockIMAP.examples.size).to eq 10

      Mail.find(:delete_after_find => true) { |message| }
      expect(MockIMAP.examples.size).to eq 10
    end

    it "should handle the find_and_delete method" do
      Mail.find_and_delete(:count => 15)
      expect(MockIMAP.examples.size).to eq 5
    end

  end

  describe "last" do
    it "should find the last received messages" do
      messages = Mail.last(:count => 5)

      expect(messages).to be_instance_of(Array)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822']}[-5..-1]
    end
    it "should find the last received message" do
      message = Mail.last

      expect(message.raw_source).to eq MockIMAP.examples.last.attr['RFC822']
    end
  end

  describe "first" do
    it "should find the first received messages" do
      messages = Mail.first(:count => 5)

      expect(messages).to be_instance_of(Array)
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822']}[0..4]
    end
    it "should find the first received message" do
      message = Mail.first

      expect(message.raw_source).to eq MockIMAP.examples.first.attr['RFC822']
    end
  end

  describe "all" do
    it "should find all messages" do
      messages = Mail.all

      expect(messages.size).to eq MockIMAP.examples.size
      expect(messages.map { |m| m.raw_source }).to eq MockIMAP.examples.map { |m| m.attr['RFC822'] }
    end
  end

  describe "delete_all" do
    it "should delete all messages" do
      Mail.all

      expect(Net::IMAP).to receive(:encode_utf7).once
      Mail.delete_all

      expect(MockIMAP.examples.size).to eq 0
    end
  end

  describe "connection" do
    it "should raise an Error if no block is given" do
      expect { Mail.connection { |m| raise ArgumentError.new } }.to raise_error
    end
    it "should yield the connection object to the given block" do
      Mail.connection do |connection|
        expect(connection).to be_an_instance_of(MockIMAP)
      end
    end
  end

  describe "handling of options" do
    it "should set default options" do
      retrievable = Mail::IMAP.new({})
      options = retrievable.send(:validate_options, {})

      expect(options[:count]).not_to be_blank
      expect(options[:count]).to eq 10

      expect(options[:order]).not_to be_blank
      expect(options[:order]).to eq :asc

      expect(options[:what]).not_to be_blank
      expect(options[:what]).to eq :first

      expect(options[:mailbox]).not_to be_blank
      expect(options[:mailbox]).to eq 'INBOX'
    end
    it "should not replace given configuration" do
      retrievable = Mail::IMAP.new({})
      options = retrievable.send(:validate_options, {
        :mailbox => 'some/mail/box',
        :count => 2,
        :order => :asc,
        :what => :first
      })

      expect(options[:count]).not_to be_blank
      expect(options[:count]).to eq 2

      expect(options[:order]).not_to be_blank
      expect(options[:order]).to eq :asc

      expect(options[:what]).not_to be_blank
      expect(options[:what]).to eq :first

      expect(options[:mailbox]).not_to be_blank
      expect(options[:mailbox]).to eq 'some/mail/box'
    end
    it "should ensure utf7 conversion for mailbox names" do
      retrievable = Mail::IMAP.new({})

      expect(Net::IMAP).to receive(:encode_utf7) { 'UTF7_STRING' }
      options = retrievable.send(:validate_options, {
        :mailbox => 'UTF8_STRING'
      })
      expect(options[:mailbox]).to eq 'UTF7_STRING'
    end
  end

  describe "error handling" do
    it "should finish the IMAP connection if an exception is raised" do
      expect(MockIMAP).to be_disconnected

      expect { Mail.all { |m| raise ArgumentError.new } }.to raise_error

      expect(MockIMAP).to be_disconnected
    end
  end

  describe "authentication mechanism" do
    before(:each) do
      @imap = MockIMAP.new
      allow(MockIMAP).to receive(:new).and_return(@imap)
    end
    it "should be login by default" do
      expect(@imap).not_to receive(:authenticate)
      expect(@imap).to receive(:login).with('foo', 'secret')
      Mail.defaults do
        retriever_method :imap, {:user_name => 'foo', :password => 'secret'}
      end
      Mail.find
    end
    it "should be changeable" do
      expect(@imap).to receive(:authenticate).with('CRAM-MD5', 'foo', 'secret')
      expect(@imap).not_to receive(:login)
      Mail.defaults do
        retriever_method :imap, {:authentication => 'CRAM-MD5', :user_name => 'foo', :password => 'secret'}
      end
      Mail.find
    end
  end

end

