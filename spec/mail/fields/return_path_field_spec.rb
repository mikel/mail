require File.join(File.dirname(File.expand_path(__FILE__)), '..', '..', 'spec_helper')

describe Mail::ReturnPathField do
  it "should allow you to specify a field" do
    rp = Mail::ReturnPathField.new('Return-Path: mikel@test.lindsaar.net')
    rp.address.should == 'mikel@test.lindsaar.net'
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
    mail.return_path.should == "bounce@someemail.com"
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
    encoded_mail.return_path.should == "bounce@someemail.com"
  end
  
  
end
