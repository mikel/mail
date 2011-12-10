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
      Mail.all.should eql @emails
    end

    it "should return all emails with a block" do
      messages = []
      Mail.all { |message| messages << message }
      messages.should eql @emails
    end

  end
  
  describe "find" do

    before do
      @emails = populate(15)
    end

    it "should handle the :count option" do
      Mail.find(:count => :all).should eql @emails
      Mail.find(:count => 1).should eql @emails.first
      Mail.find(:count => 5).should eql @emails[0, 5]
    end

    it "should handle the :order option" do
      Mail.find(:order => :asc).should eql @emails
      Mail.find(:order => :desc).should eql @emails.reverse
    end

    it "should handle the :what option" do
      Mail.find(:what => :first).should eql @emails
      Mail.find(:what => :first, :count => 5).should eql @emails[0, 5]
      Mail.find(:what => :last).should eql @emails
      Mail.find(:what => :last, :count => 5).should eql @emails[10, 5]
    end

    it "should handle the :delete_after_find option" do
      Mail.find(:delete_after_find => false).should eql @emails
      Mail.find(:delete_after_find => false).should eql @emails
      Mail.find(:delete_after_find => true).should eql @emails
      Mail.find(:delete_after_find => false).should be_empty
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
      Mail.all.should eql messages
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
