require 'spec_helper'

describe "Test Retriever" do

  before(:each) do
    Mail.defaults do
      retriever_method :test
    end
  end

  it "should have no emails initially" do
    expect(Mail.all).to be_empty
  end

  describe "all" do
    
    before do
      @emails = populate(15)
    end

    it "should return all emails without a block" do
      expect(Mail.all).to eq @emails
    end

    it "should return all emails with a block" do
      messages = []
      Mail.all { |message| messages << message }
      expect(messages).to eq @emails
    end

  end
  
  describe "find" do

    before do
      @emails = populate(15)
    end

    it "should handle the :count option" do
      expect(Mail.find(:count => :all)).to eq @emails
      expect(Mail.find(:count => 1)).to eq @emails.first
      expect(Mail.find(:count => 5)).to eq @emails[0, 5]
    end

    it "should handle the :order option" do
      expect(Mail.find(:order => :asc)).to eq @emails
      expect(Mail.find(:order => :desc)).to eq @emails.reverse
    end

    it "should handle the :what option" do
      expect(Mail.find(:what => :first)).to eq @emails
      expect(Mail.find(:what => :first, :count => 5)).to eq @emails[0, 5]
      expect(Mail.find(:what => :last)).to eq @emails
      expect(Mail.find(:what => :last, :count => 5)).to eq @emails[10, 5]
    end

    it "should handle the both of :what and :order option with :count => 1" do
      expect(Mail.find(:count => 1, :what => :last, :order => :asc)).to eq @emails.last
      expect(Mail.find(:count => 1, :what => :first, :order => :desc)).to eq @emails.first
    end

    it "should handle the :delete_after_find option" do
      expect(Mail.find(:delete_after_find => false)).to eq @emails
      expect(Mail.find(:delete_after_find => false)).to eq @emails
      expect(Mail.find(:delete_after_find => true)).to eq @emails
      expect(Mail.find(:delete_after_find => false)).to be_empty
    end

    it "should handle the both of :delete_after_find and :count option" do
      expect do
        expect(Mail.find(:count => 5, :delete_after_find => true).size).to eq(5)
      end.to change { Mail.all.size }.by(-5)
      expect do
        expect(Mail.find(:count => 5, :delete_after_find => true).size).to eq(5)
      end.to change { Mail.all.size }.by(-5)
    end

    it "should handle the both of :count and :delete_after_find option" do
      15.times do |idx|
        expect do
          expect(Mail.find(:count => 1, :delete_after_find => true)).to eq @emails[idx]
        end.to change { Mail.all.size }.by(-1)
      end
      expect(Mail.find(:count => 1, :delete_after_find => true)).to be_empty
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
      expect(Mail.all).to eq messages
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
