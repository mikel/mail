require 'spec_helper'

describe "Test Retriever" do

  before(:each) do
    Mail.defaults do
      retriever_method :test
    end
  end

  it "should have no emails initially" do
    Mail.all.should be_empty
  end

  describe "all" do
    
    before do
      @emails = populate(15)
    end

    it "should return all emails without a block" do
      Mail.all.should eq @emails
    end

    it "should return all emails with a block" do
      messages = []
      Mail.all { |message| messages << message }
      messages.should eq @emails
    end

  end
  
  describe "find" do

    before do
      @emails = populate(15)
    end

    it "should handle the :count option" do
      Mail.find(:count => :all).should eq @emails
      Mail.find(:count => 1).should eq @emails.first
      Mail.find(:count => 5).should eq @emails[0, 5]
    end

    it "should handle the :order option" do
      Mail.find(:order => :asc).should eq @emails
      Mail.find(:order => :desc).should eq @emails.reverse
    end

    it "should handle the :what option" do
      Mail.find(:what => :first).should eq @emails
      Mail.find(:what => :first, :count => 5).should eq @emails[0, 5]
      Mail.find(:what => :last).should eq @emails
      Mail.find(:what => :last, :count => 5).should eq @emails[10, 5]
    end

    it "should handle the both of :what and :order option with :count => 1" do
      Mail.find(:count => 1, :what => :last, :order => :asc).should eq @emails.last
      Mail.find(:count => 1, :what => :first, :order => :desc).should eq @emails.first
    end

    it "should handle the :delete_after_find option" do
      Mail.find(:delete_after_find => false).should eq @emails
      Mail.find(:delete_after_find => false).should eq @emails
      Mail.find(:delete_after_find => true).should eq @emails
      Mail.find(:delete_after_find => false).should be_empty
    end

    it "should handle the both of :delete_after_find and :count option" do
      expect do
        Mail.find(:count => 5, :delete_after_find => true).should have(5).items
      end.to change { Mail.all.size }.by(-5)
      expect do
        Mail.find(:count => 5, :delete_after_find => true).should have(5).items
      end.to change { Mail.all.size }.by(-5)
    end

    it "should handle the both of :count and :delete_after_find option" do
      15.times do |idx|
        expect do
          Mail.find(:count => 1, :delete_after_find => true).should eq @emails[idx]
        end.to change { Mail.all.size }.by(-1)
      end
      Mail.find(:count => 1, :delete_after_find => true).should be_empty
    end

    it "should handle the :delete_after_find option with messages marked not for delete" do
      i = 0
      messages = []
      Mail.find(:delete_after_find => true) do |message|
        if i % 2
          message.mark_for_delete = false
          messages << message
        end
        i += 1
      end
      Mail.all.should eq messages
    end

  end


  private

  def populate(count)
    (1..count).map do
      Mail.new do
        to 'mikel@me.com'
        from 'you@you.com'
        subject 'testing'
        body 'hello'
      end
    end.tap do |emails|
      Mail::TestRetriever.emails = emails.dup
    end
  end

end
