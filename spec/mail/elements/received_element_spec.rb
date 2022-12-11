# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::ReceivedElement do

  it "should raise an error if the input is nil" do
    received = Mail::ReceivedElement.new(nil)
    expect(received.info).to be_nil
    expect(received.date_time).to be_nil
  end

  it "should raise an error if the input is useless" do
    received_text  = '""""""""""""""""'
    expect { Mail::ReceivedElement.new(received_text) }.to raise_error(Mail::Field::ParseError)
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
