require 'spec_helper'

describe Mail::EnvelopeFromElement do
  
  describe "parsing a from envelope string" do
    it "should parse a full field" do
      doing { Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net  Mon Aug  7 00:39:21 2009") }.should_not raise_error
    end

    it "should parse a full field with a double digit day" do
      doing { Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net  Mon Aug 17 00:39:21 2009") }.should_not raise_error
    end

    it "should parse a full field with a single space day" do
      doing { Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009") }.should_not raise_error
    end
  end

  describe "accessor methods" do
    it "should return the address" do
      envelope = Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      envelope.address.should eq "mikel@test.lindsaar.net"
    end

    it "should return the date_time" do
      envelope = Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      envelope.date_time.should eq ::DateTime.parse("Mon Aug 17 00:39:21 2009")
    end
  end

  describe 'formatting' do
    it 'should format delivery date using UNIX ctime style' do
      time = Time.now
      envelope = Mail::EnvelopeFromElement.new("mikel@test.lindsaar.net #{time.ctime}")
      envelope.to_s.should eq "mikel@test.lindsaar.net #{time.ctime}"
    end
  end

end
