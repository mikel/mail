require 'spec_helper'

describe Mail::EnvelopeFromElement do
  
  describe "parsing a from envelope string" do
    it "should parse a full field" do
      Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net  Mon Aug  7 00:39:21 2009").tree.should_not be_nil
    end

    it "should parse a full field with a double digit day" do
      Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net  Mon Aug 17 00:39:21 2009").tree.should_not be_nil
    end

    it "should parse a full field with a single space day" do
      Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009").tree.should_not be_nil
    end
  end

  describe "accessor methods" do
    it "should return the address" do
      envelope = Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      envelope.address.should == "mikel@test.lindsaar.net"
    end

    it "should return the date_time" do
      envelope = Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      envelope.date_time.should == ::DateTime.parse("Mon Aug 17 00:39:21 2009")
    end
  end

end
