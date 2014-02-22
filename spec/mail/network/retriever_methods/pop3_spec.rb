# encoding: utf-8
require 'spec_helper'

describe "POP3 Retriever" do
  
  before(:each) do
    # Reset all defaults back to original state
    Mail.defaults do
      retriever_method :pop3, { :address             => "localhost",
                                :port                => 995,
                                :user_name           => nil,
                                :password            => nil,
                                :enable_ssl          => true }
    end
  end


  describe "find with and without block" do
  
    it "should find all emails with a given block" do
      expect(MockPOP3).not_to be_started
      
      messages = []
      Mail.all do |message|
        messages << message
      end
      
      expect(messages.map { |m| m.raw_source }.sort).to eq MockPOP3.popmails.map { |p| p.pop }.sort
      expect(MockPOP3).not_to be_started
    end
    
    it "should get all emails without a given block" do
      expect(MockPOP3).not_to be_started
      
      messages = []
      Mail.all do |message|
        messages << message
      end
      
      expect(messages.map { |m| m.raw_source }.sort).to eq MockPOP3.popmails.map { |p| p.pop }.sort
      expect(MockPOP3).not_to be_started
    end
  
  end

  describe "find and options" do
    
    it "should handle the :count option" do
      messages = Mail.find(:count => :all, :what => :last, :order => :asc)
      expect(messages.map { |m| m.raw_source }.sort).to eq MockPOP3.popmails.map { |p| p.pop }
      
      message = Mail.find(:count => 1, :what => :last)
      expect(message.raw_source).to eq MockPOP3.popmails.map { |p| p.pop }.last
      
      messages = Mail.find(:count => 2, :what => :last, :order => :asc)
      expect(messages[0..1].collect {|m| m.raw_source}).to eq MockPOP3.popmails.map { |p| p.pop }[-2..-1]
    end
    
    it "should handle the :what option" do
      messages = Mail.find(:count => :all, :what => :last)
      expect(messages.map { |m| m.raw_source }.sort).to eq MockPOP3.popmails.map { |p| p.pop }
      
      messages = Mail.find(:count => 2, :what => :first, :order => :asc)
      expect(messages.map { |m| m.raw_source }).to eq MockPOP3.popmails.map { |p| p.pop }[0..1]
    end
    
    it "should handle the :order option" do
      messages = Mail.find(:order => :desc, :count => 5, :what => :last)
      expect(messages.map { |m| m.raw_source }).to eq MockPOP3.popmails.map { |p| p.pop }[-5..-1].reverse
      
      messages = Mail.find(:order => :asc, :count => 5, :what => :last)
      expect(messages.map { |m| m.raw_source }).to eq MockPOP3.popmails.map { |p| p.pop }[-5..-1]
    end
    
    it "should find the last 10 messages by default" do
      messages = Mail.find
      
      expect(messages.size).to eq 10
    end

    it "should handle the delete_after_find option" do
      Mail.find(:delete_after_find => false)
      MockPOP3.popmails.each { |message| expect(message).not_to be_deleted }

      Mail.find(:delete_after_find => true)
      MockPOP3.popmails.first(10).each { |message| expect(message).to be_deleted }
      MockPOP3.popmails.last(10).each { |message| expect(message).not_to be_deleted }

      Mail.find(:delete_after_find => true) { |message| }
      MockPOP3.popmails.first(10).each { |message| expect(message).to be_deleted }
      MockPOP3.popmails.last(10).each { |message| expect(message).not_to be_deleted }
    end

    it "should handle the find_and_delete method" do
      Mail.find_and_delete(:count => 15)
      MockPOP3.popmails.first(15).each { |message| expect(message).to be_deleted }
      MockPOP3.popmails.last(5).each { |message| expect(message).not_to be_deleted }
    end
    
  end
  
  describe "last" do
    
    it "should find the last received messages" do
      messages = Mail.last(:count => 5)
      
      expect(messages).to be_instance_of(Array)
      expect(messages.map { |m| m.raw_source }).to eq MockPOP3.popmails.map { |p| p.pop }[-5..-1]
    end
    
    it "should find the last received message" do
      message = Mail.last
      
      expect(message).to be_instance_of(Mail::Message)
      expect(message.raw_source).to eq MockPOP3.popmails.last.pop
    end
    
  end
  
  describe "first" do
    
    it "should find the first received messages" do
      messages = Mail.first(:count => 5)
      
      expect(messages).to be_instance_of(Array)
      expect(messages.map { |m| m.raw_source }).to eq MockPOP3.popmails.map { |p| p.pop }[0..4]
    end
    
    it "should find the first received message" do
      message = Mail.first
      
      expect(message).to be_instance_of(Mail::Message)
      expect(message.raw_source).to eq MockPOP3.popmails.first.pop
    end
    
  end
  
  describe "all" do
    
    it "should find all messages" do
      messages = Mail.all
      
      expect(messages.size).to eq MockPOP3.popmails.size
      expect(messages.map { |m| m.raw_source }).to eq MockPOP3.popmails.map { |p| p.pop }
    end
    
  end
  
  describe "delete_all" do
    it "should delete all mesages" do
      Mail.all
      Mail.delete_all
    
      expect(MockPOP3.popmails.size).to eq 0
    end
  end
  
  describe "connection" do
    it "should raise an Error if no block is given" do
      expect { Mail.connection { |m| raise ArgumentError.new } }.to raise_error
    end
    it "should yield the connection object to the given block" do
      Mail.connection do |connection|
        expect(connection).to be_an_instance_of(MockPOP3)
      end
    end
  end

  describe "handling of options" do
    
    it "should set default options" do
      retrievable = Mail::POP3.new({})
      options = retrievable.send(:validate_options, {})
      
      expect(options[:count]).not_to be_blank
      expect(options[:count]).to eq 10
      
      expect(options[:order]).not_to be_blank
      expect(options[:order]).to eq :asc
      
      expect(options[:what]).not_to be_blank
      expect(options[:what]).to eq :first
    end
    
    it "should not replace given configuration" do
      retrievable = Mail::POP3.new({})
      options = retrievable.send(:validate_options, {
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
    end
    
  end

  describe "error handling" do
  
    it "should finish the POP3 connection is an exception is raised" do
      expect(MockPOP3).not_to be_started
      
      expect(doing do
        Mail.all { |m| raise ArgumentError.new }
      end).to raise_error
      
      expect(MockPOP3).not_to be_started
    end
    
  end

end
