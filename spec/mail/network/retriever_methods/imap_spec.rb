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
      MockIMAP.should be_disconnected

      messages = []
      Mail.all do |message|
        messages << message
      end
      messages.map { |m| m.raw_source }.sort.should == MockIMAP.examples.map { |m| m.attr['RFC822']}.sort

      MockIMAP.should be_disconnected
    end
    it "should get all emails without a given block" do
      MockIMAP.should be_disconnected

      messages = Mail.all
      messages.map { |m| m.raw_source }.sort.should == MockIMAP.examples.map { |m| m.attr['RFC822']}.sort

      MockIMAP.should be_disconnected
    end
    it "should get all emails and yield the imap, uid, and email when given a block of arity 3" do
      MockIMAP.should be_disconnected

      messages = []
      uids = []
      Mail.all do |message, imap, uid|
        MockIMAP.should === imap
        messages << message
        uids << uid
      end
      messages.map { |m| m.raw_source }.sort.should == MockIMAP.examples.map { |m| m.attr['RFC822']}.sort
      uids.sort.should == MockIMAP.examples.map { |m| m.number }.sort

      MockIMAP.should be_disconnected
    end
  end

  describe "find and options" do
    it "should handle the :count option" do
      messages = Mail.find(:count => :all, :what => :last, :order => :asc)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }

      message = Mail.find(:count => 1, :what => :last)
      message.raw_source.should == MockIMAP.examples.last.attr['RFC822']

      messages = Mail.find(:count => 2, :what => :last, :order => :asc)
      messages[0..1].map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }[-2..-1]
    end
    it "should handle the :what option" do
      messages = Mail.find(:count => :all, :what => :last)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }

      messages = Mail.find(:count => 2, :what => :first, :order => :asc)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }[0..1]
    end
    it "should handle the :order option" do
      messages = Mail.find(:order => :desc, :count => 5, :what => :last)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }[-5..-1].reverse

      messages = Mail.find(:order => :asc, :count => 5, :what => :last)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }[-5..-1]
    end
    it "should handle the :mailbox option" do
      messages = Mail.find(:mailbox => 'SOME-RANDOM-MAILBOX')

      MockIMAP.mailbox.should == 'SOME-RANDOM-MAILBOX'
    end
    it "should find the last 10 messages by default" do
      messages = Mail.find

      messages.size.should == 10
    end
    it "should search the mailbox 'INBOX' by default" do
      messages = Mail.find

      MockIMAP.mailbox.should == 'INBOX'
    end

    it "should handle the delete_after_find_option" do
      Mail.find(:delete_after_find => false)
      MockIMAP.examples.size.should == 20

      Mail.find(:delete_after_find => true)
      MockIMAP.examples.size.should == 10

      Mail.find(:delete_after_find => true) { |message| }
      MockIMAP.examples.size.should == 10
    end

    it "should handle the find_and_delete method" do
      Mail.find_and_delete(:count => 15)
      MockIMAP.examples.size.should == 5
    end
    
  end

  describe "last" do
    it "should find the last received messages" do
      messages = Mail.last(:count => 5)

      messages.should be_instance_of(Array)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822']}[-5..-1]
    end
    it "should find the last received message" do
      message = Mail.last

      message.raw_source.should == MockIMAP.examples.last.attr['RFC822']
    end
  end

  describe "first" do
    it "should find the first received messages" do
      messages = Mail.first(:count => 5)

      messages.should be_instance_of(Array)
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822']}[0..4]
    end
    it "should find the first received message" do
      message = Mail.first

      message.raw_source.should == MockIMAP.examples.first.attr['RFC822']
    end
  end

  describe "all" do
    it "should find all messages" do
      messages = Mail.all

      messages.size.should == MockIMAP.examples.size
      messages.map { |m| m.raw_source }.should == MockIMAP.examples.map { |m| m.attr['RFC822'] }
    end
  end

  describe "delete_all" do
    it "should delete all messages" do
      messages = Mail.all

      Net::IMAP.should_receive(:encode_utf7).once
      Mail.delete_all

      MockIMAP.examples.size.should == 0
    end
  end 

  describe "connection" do
    it "should raise an Error if no block is given" do
      lambda { Mail.connection { |m| raise ArgumentError.new } }.should raise_error
    end
    it "should yield the connection object to the given block" do
      Mail.connection do |connection|
        connection.should be_an_instance_of(MockIMAP)
      end
    end
  end

  describe "handling of options" do
    it "should set default options" do
      retrievable = Mail::IMAP.new({})
      options = retrievable.send(:validate_options, {})

      options[:count].should_not be_blank
      options[:count].should == 10

      options[:order].should_not be_blank
      options[:order].should == :asc

      options[:what].should_not be_blank
      options[:what].should == :first

      options[:mailbox].should_not be_blank
      options[:mailbox].should == 'INBOX'
    end
    it "should not replace given configuration" do
      retrievable = Mail::IMAP.new({})
      options = retrievable.send(:validate_options, {
        :mailbox => 'some/mail/box',
        :count => 2,
        :order => :asc,
        :what => :first
      })

      options[:count].should_not be_blank
      options[:count].should == 2

      options[:order].should_not be_blank
      options[:order].should == :asc

      options[:what].should_not be_blank
      options[:what].should == :first

      options[:mailbox].should_not be_blank
      options[:mailbox].should == 'some/mail/box'
    end
    it "should ensure utf7 conversion for mailbox names" do
      retrievable = Mail::IMAP.new({})

      Net::IMAP.stub!(:encode_utf7 => 'UTF7_STRING')
      options = retrievable.send(:validate_options, {
        :mailbox => 'UTF8_STRING'
      })
      options[:mailbox].should == 'UTF7_STRING'
    end
  end

  describe "error handling" do
    it "should finish the IMAP connection if an exception is raised" do 
      MockIMAP.should be_disconnected

      lambda { Mail.all { |m| raise ArgumentError.new } }.should raise_error

      MockIMAP.should be_disconnected
    end
  end
  
  describe "authentication mechanism" do
    before(:each) do
      @imap = MockIMAP.new
      MockIMAP.stub!(:new).and_return(@imap)
    end
    it "should be login by default" do
      @imap.should_not_receive(:authenticate)
      @imap.should_receive(:login).with('foo', 'secret')
      Mail.defaults do
        retriever_method :imap, {:user_name => 'foo', :password => 'secret'}
      end
      messages = Mail.find
    end
    it "should be changeable" do
      @imap.should_receive(:authenticate).with('CRAM-MD5', 'foo', 'secret')
      @imap.should_not_receive(:login)
      Mail.defaults do
        retriever_method :imap, {:authentication => 'CRAM-MD5', :user_name => 'foo', :password => 'secret'}
      end
      messages = Mail.find
    end
  end

end

