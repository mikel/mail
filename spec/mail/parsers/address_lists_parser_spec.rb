#require File.dirname(__FILE__) + '/../../spec_helper'
#
#Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/obsolete'))
#Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/common'))
#Treetop.load(File.join(MAIL_ROOT, 'lib/mail/parsers/address_lists'))
#
#describe 'Address Lists parser' do
#  
#  describe "functionality" do
#  
#    it "should parse an address list" do
#      a = Mail::AddressListsParser.new
#      doing { a.parse('test@lindsaar.net') }.should_not raise_error
#    end
#
#    it "should give the address passed in" do
#      a = Mail::AddressListsParser.new
#      parse_text  = 'test@lindsaar.net'
#      result      = ['test@lindsaar.net']
#      a.parse(parse_text).addresses.should == result
#    end
#  
#    it "should give the addresses passed in" do
#      a = Mail::AddressListsParser.new
#      parse_text  = 'test@lindsaar.net, test2@lindsaar.net'
#      result      = ['test@lindsaar.net', 'test2@lindsaar.net']
#      a.parse(parse_text).addresses.should == result
#    end
#  
#    it "should give back the display name" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
#      result.display_names.should == ['Mikel Lindsaar']
#    end
#  
#    it "should give back the display names" do
#      a = Mail::AddressListsParser.new
#      parse_text  = 'Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>'
#      result      = ['Mikel Lindsaar', 'Ada Lindsaar']
#      a.parse(parse_text).display_names.should == result
#    end
#  
#    it "should give back the local part" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
#      result.local_names.should == ['test']
#    end
#  
#    it "should give back the local part" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>')
#      result.local_names.should == ['test', 'test2']
#    end
#  
#    it "should give back the domain" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
#      result.domain_names.should == ['lindsaar.net']
#    end
#  
#    it "should give back the domain" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>')
#      result.domain_names.should == ['lindsaar.net', 'me.com']
#    end
#  
#    it "should give back the formated address" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>')
#      result.format.should == ['Mikel Lindsaar <test@lindsaar.net>']
#    end
#  
#    it "should give back the formated address" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('Mikel Lindsaar <test@lindsaar.net>, Ada Lindsaar <test2@me.com>')
#      result.format.should == ['Mikel Lindsaar <test@lindsaar.net>', 'Ada Lindsaar <test2@me.com>']
#    end
#  
#    it "should handle an address without a domain" do
#      a = Mail::AddressListsParser.new
#      result = a.parse('mikel')
#      result.addresses.should == ['mikel']
#    end
#  
#  end
#  
#  describe "exhaustive testing" do
#    it "should handle all OK local parts" do
#      [ [ 'aamine',         'aamine'        ],
#        [ '"Minero Aoki"',  '"Minero Aoki"' ],
#        [ '"!@#$%^&*()"',   '"!@#$%^&*()"'  ],
#        [ 'a.b.c',          'a.b.c'         ]
#
#      ].each do |(words, ok)|
#        a = Mail::AddressListsParser.new.parse(words)
#        a.local_names.first.should == ok
#      end
#    end
#
#    it "should handle all OK domains" do
#      [ [ 'loveruby.net',          'loveruby.net'    ],
#        [ '"love ruby".net',       '"love ruby".net' ],
#        [ 'a."love ruby".net',     'a."love ruby".net' ],
#        [ '"!@#$%^&*()"',          '"!@#$%^&*()"'    ],
#        [ '[192.168.1.1]',         '[192.168.1.1]'   ]
#
#      ].each do |(words, ok)|
#        a = Mail::AddressListsParser.new.parse(%Q|me@#{words}|)
#        a.domain_names.should == [ok]
#      end
#    end
#  end
#  
#end
#