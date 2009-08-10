require File.dirname(__FILE__) + '/../spec_helper'

describe Mail::Envelope do

  it "should initialize" do
    doing { Mail::Envelope.new('mikel@test.lindsaar.net Mon May  2 16:07:05 2005') }.should_not raise_error
  end

  it "should return the envelope from element tree" do
    envelope = Mail::Envelope.new('mikel@test.lindsaar.net Mon May  2 16:07:05 2005')
    envelope.tree.class.should == Treetop::Runtime::SyntaxNode
  end

  describe "accessor methods" do
    it "should return the address" do
      envelope = Mail::Envelope.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      envelope.from.should == "mikel@test.lindsaar.net"
    end

    it "should return the date_time" do
      envelope = Mail::Envelope.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      envelope.date.should == ::DateTime.parse("Mon Aug 17 00:39:21 2009")
    end
  end

end
