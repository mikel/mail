require 'spec_helper'

describe Mail::MessageIdsElement do

  it "should parse a message_id" do
    msg_id_text  = '<1234@test.lindsaar.net>'
    expect(doing { Mail::MessageIdsElement.new(msg_id_text) }).not_to raise_error
  end

  it "should parse multiple message_ids" do
    msg_id_text  = '<1234@test.lindsaar.net> <1234@test.lindsaar.net>'
    expect(doing { Mail::MessageIdsElement.new(msg_id_text) }).not_to raise_error
  end

  it "should raise an error if the input is useless" do
    msg_id_text = nil
    expect(doing { Mail::MessageIdsElement.new(msg_id_text) }).to raise_error
  end

  it "should raise an error if the input is useless" do
    msg_id_text  = '""""""""""""""""'
    expect(doing { Mail::MessageIdsElement.new(msg_id_text) }).to raise_error
  end

  it "should respond to message_ids" do
    msg_id_text  = '<1234@test.lindsaar.net> <1234@test.lindsaar.net>'
    msg_ids = Mail::MessageIdsElement.new(msg_id_text)
    expect(msg_ids.message_ids).to eq ['1234@test.lindsaar.net', '1234@test.lindsaar.net']
  end

  it "should respond to message_id" do
    msg_id_text  = '<1234@test.lindsaar.net>'
    msg_ids = Mail::MessageIdsElement.new(msg_id_text)
    expect(msg_ids.message_id).to eq '1234@test.lindsaar.net'
  end
  
  it "should not fail to parse a message id with dots in it" do
    text = "<4afb664ca3078_48dc..fdbe32b865532b@ax-desktop.mail>"
    m = Mail::MessageIdsElement.new(text)
    expect(m.message_id).to eq "4afb664ca3078_48dc..fdbe32b865532b@ax-desktop.mail"
  end

end
