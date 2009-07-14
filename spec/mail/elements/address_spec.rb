require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::Address do

  it "should give it's format back on :to_s" do
    Mail::Address.new('test@lindsaar.net').to_s.should == 'test@lindsaar.net'
  end

  it "should give it's format back on :to_s" do
    Mail::Address.new('Mikel <test@lindsaar.net>').to_s.should == 'Mikel <test@lindsaar.net>'
  end

end
