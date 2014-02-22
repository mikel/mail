require 'spec_helper'

describe Mail::ReturnPathField do
  it "should allow you to specify a field" do
    rp = Mail::ReturnPathField.new('Return-Path: mikel@test.lindsaar.net')
    expect(rp.address).to eq 'mikel@test.lindsaar.net'
  end
  
  it "should encode the addr_spec in <>" do
    rp = Mail::ReturnPathField.new('Return-Path: mikel@test.lindsaar.net')
    expect(rp.encoded).to eq "Return-Path: <mikel@test.lindsaar.net>\r\n"
  end

  it "should accept <>" do
    rp = Mail::ReturnPathField.new('<>')
    expect(rp.encoded).to eq "Return-Path: <>\r\n"
  end
  
  it "should set the return path" do
    mail = Mail.new do
      to "to@someemail.com"
      from "from@someemail.com"
      subject "Can't set the return-path"
      return_path "bounce@someemail.com" 
      message_id "<1234@someemail.com>"
      body "body"
    end
    expect(mail.return_path).to eq "bounce@someemail.com"
  end
  
  it "should set the return path" do
    mail = Mail.new do
      to "to@someemail.com"
      from "from@someemail.com"
      subject "Can't set the return-path"
      return_path "bounce@someemail.com" 
      message_id "<1234@someemail.com>"
      body "body"
    end
    encoded_mail = Mail.new(mail.encoded)
    expect(encoded_mail.return_path).to eq "bounce@someemail.com"
  end
  
  it "should wrap the return path addr_spec in <>" do
    mail = Mail.new do
      to "to@someemail.com"
      from "from@someemail.com"
      subject "Can't set the return-path"
      return_path "bounce@someemail.com" 
      message_id "<1234@someemail.com>"
      body "body"
    end
    expect(mail.encoded).to match(/<bounce@someemail\.com>/)
  end
  
  
end
