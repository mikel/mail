require 'spec_helper'

describe Mail::ReceivedElement do

  it "should parse a date" do
    received_text  = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    doing { Mail::ReceivedElement.new(received_text) }.should_not raise_error
  end

  it "should raise an error if the input is useless" do
    received_text = nil
    doing { Mail::ReceivedElement.new(received_text) }.should raise_error
  end

  it "should raise an error if the input is useless" do
    received_text  = '""""""""""""""""'
    doing { Mail::ReceivedElement.new(received_text) }.should raise_error
  end
  
  it "should give back the date time" do
    received_text  = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    date_text = '10 May 2005 17:26:50 +0000 (GMT)'
    rec = Mail::ReceivedElement.new(received_text)
    rec.date_time.should == ::DateTime.parse(date_text)
  end
  
  it "should give back the info" do
    received_text  = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    info_text = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>'
    rec = Mail::ReceivedElement.new(received_text)
    rec.info.should == info_text
  end
  
end
