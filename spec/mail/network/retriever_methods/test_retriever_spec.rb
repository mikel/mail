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

  it "should return all emails" do
    emails = populate(15)
    Mail.all.should == emails
  end

  describe "find and options" do
    it "should handle the :count option" do
      emails = populate(15)
      Mail.find(:count => :all).should == emails
      Mail.find(:count => 1).should == emails.first
      Mail.find(:count => 5).should == emails[0, 5]
    end
  end


  private

  def populate(count)
    Mail::TestRetriever.emails = (1..count).map do
      Mail.new do
        to 'mikel@me.com'
        from 'you@you.com'
        subject 'testing'
        body 'hello'
      end
    end
  end

end
