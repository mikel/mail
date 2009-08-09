# encoding: utf-8
require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mail::CommonAddress do
  
  describe "address handling" do
  
    it "should give the addresses it is going to" do
      field = Mail::ToField.new("To", "test1@lindsaar.net")
      field.addresses.first.should == "test1@lindsaar.net"
    end
  
    it "should split up the address list into individual addresses" do
      field = Mail::ToField.new("To", "test1@lindsaar.net, test2@lindsaar.net")
      field.addresses.should == ["test1@lindsaar.net", "test2@lindsaar.net"]
    end
  
    it "should give the formatted addresses" do
      field = Mail::ToField.new("To", "Mikel <test1@lindsaar.net>, Bob <test2@lindsaar.net>")
      field.formatted.should == ["Mikel <test1@lindsaar.net>", "Bob <test2@lindsaar.net>"]
    end
  
    it "should handle groups as well" do
      field = Mail::ToField.new("To", "test1@lindsaar.net, group: test2@lindsaar.net, me@lindsaar.net;")
      field.addresses.should == ["test1@lindsaar.net", "test2@lindsaar.net", "me@lindsaar.net"]
    end

    it "should provide a list of groups" do
      field = Mail::ToField.new("To", "test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.group_names.should == ["My Group"]
    end

    it "should provide a list of addresses per group" do
      field = Mail::ToField.new("To", "test1@lindsaar.net, My Group: test2@lindsaar.net, me@lindsaar.net;")
      field.groups["My Group"].length.should == 2
      field.groups["My Group"].first.to_s.should == 'test2@lindsaar.net'
      field.groups["My Group"].last.to_s.should == 'me@lindsaar.net'
    end

  end
end
