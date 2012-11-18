# encoding: utf-8
require 'spec_helper'

require 'treetop/compiler'
Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/rfc2822_obsolete'))
Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/rfc2822'))
Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/address_lists'))

describe "AddressListsParser" do
  it "should parse an address" do
    text = 'Mikel Lindsaar <test@lindsaar.net>, Friends: test2@lindsaar.net, Ada <test3@lindsaar.net>;'
    a = Mail::AddressListsParser.new
    a.parse(text).should_not be_nil
  end
end
