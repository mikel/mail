require File.dirname(__FILE__) + '/../../../spec_helper'

Treetop.load(File.dirname(__FILE__) + '/../../../../lib/mail/fields/parsers/common')
Treetop.load(File.dirname(__FILE__) + '/../../../../lib/mail/fields/parsers/address_list')

describe 'Addres List parser' do
  it "should parse an address list" do
    a = Mail::AddressListParser.new
    doing { a.parse('test@lindsaar.net') }.should_not raise_error
  end

  it "should give the address passed in" do
    a = Mail::AddressListParser.new
    parse_text  = 'test@lindsaar.net'
    result      = ['test@lindsaar.net']
    a.parse(parse_text).addresses.should == result
  end
  
  it "should give the addresses passed in" do
    a = Mail::AddressListParser.new
    parse_text  = 'test@lindsaar.net, test2@lindsaar.net'
    result      = ['test@lindsaar.net', 'test2@lindsaar.net']
    a.parse(parse_text).addresses.should == result
  end
  
  it "should give back the display name" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
    result.display_names.should == ['Mikel Lindsaar']
  end
  
  it "should give back the display names" do
    a = Mail::AddressListParser.new
    parse_text  = 'Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>'
    result      = ['Mikel Lindsaar', 'Ada Lindsaar']
    a.parse(parse_text).display_names.should == result
  end
  
  it "should give back the local part" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
    result.local_names.should == ['test']
  end
  
  it "should give back the local part" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>')
    result.local_names.should == ['test', 'test2']
  end
  
  it "should give back the domain" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
    result.domain_names.should == ['lindsaar.net']
  end
  
  it "should give back the domain" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>')
    result.domain_names.should == ['lindsaar.net', 'me.com']
  end
  
  it "should give back the formated address" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
    result.format.should == ['Mikel Lindsaar <test@lindsaar.net>']
  end
  
  it "should give back the formated address" do
    a = Mail::AddressListParser.new
    result = a.parse('Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>')
    result.format.should == ['Mikel Lindsaar <test@lindsaar.net>', 'Ada Lindsaar <test2@me.com>']
  end
  
end
