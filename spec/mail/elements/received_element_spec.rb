require 'spec_helper'

describe Mail::ReceivedElement do

  it "should parse a date" do
    received_text  = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    expect(doing { Mail::ReceivedElement.new(received_text) }).not_to raise_error
  end

  it "should raise an error if the input is useless" do
    received_text = nil
    expect(doing { Mail::ReceivedElement.new(received_text) }).to raise_error
  end

  it "should raise an error if the input is useless" do
    received_text  = '""""""""""""""""'
    expect(doing { Mail::ReceivedElement.new(received_text) }).to raise_error
  end
  
  it "should give back the date time" do
    received_text  = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    date_text = '10 May 2005 17:26:50 +0000 (GMT)'
    rec = Mail::ReceivedElement.new(received_text)
    expect(rec.date_time).to eq ::DateTime.parse(date_text)
  end
  
  it "should give back the info" do
    received_text  = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>; Tue, 10 May 2005 17:26:50 +0000 (GMT)'
    info_text = 'from localhost (localhost [127.0.0.1]) by xxx.xxxxx.com (Postfix) with ESMTP id 50FD3A96F for <xxxx@xxxx.com>'
    rec = Mail::ReceivedElement.new(received_text)
    expect(rec.info).to eq info_text
  end
  
end
