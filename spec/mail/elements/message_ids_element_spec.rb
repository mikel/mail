require File.dirname(__FILE__) + '/../../spec_helper'

describe Mail::MessageIdsElement do

  it "should parse a message_id" do
    msg_id_text  = '<1234@test.lindsaar.net>'
    doing { Mail::MessageIdsElement.new(msg_id_text) }.should_not raise_error
  end

  it "should parse multiple message_ids" do
    msg_id_text  = '<1234@test.lindsaar.net> <1234@test.lindsaar.net>'
    doing { Mail::MessageIdsElement.new(msg_id_text) }.should_not raise_error
  end

  it "should raise an error if the input is useless" do
    msg_id_text = nil
    doing { Mail::MessageIdsElement.new(msg_id_text) }.should raise_error
  end

  it "should raise an error if the input is useless" do
    msg_id_text  = '""""""""""""""""'
    doing { Mail::MessageIdsElement.new(msg_id_text) }.should raise_error
  end

  it "should respond to message_ids" do
    msg_id_text  = '<1234@test.lindsaar.net> <1234@test.lindsaar.net>'
    msg_ids = Mail::MessageIdsElement.new(msg_id_text)
    msg_ids.message_ids.should == ['1234@test.lindsaar.net', '1234@test.lindsaar.net']
  end

  it "should respond to message_id" do
    msg_id_text  = '<1234@test.lindsaar.net>'
    msg_ids = Mail::MessageIdsElement.new(msg_id_text)
    msg_ids.message_id.should == '1234@test.lindsaar.net'
  end

end
