# encoding: utf-8
require 'spec_helper'

describe Mail::DateField do
  #    The origination date field consists of the field name "Date" followed
  #    by a date-time specification.
  # 
  # orig-date       =       "Date:" date-time CRLF
  # 
  #    The origination date specifies the date and time at which the creator
  #    of the message indicated that the message was complete and ready to
  #    enter the mail delivery system.  For instance, this might be the time
  #    that a user pushes the "send" or "submit" button in an application
  #    program.  In any case, it is specifically not intended to convey the
  #    time that the message is actually transported, but rather the time at
  #    which the human or other creator of the message has put the message
  #    into its final form, ready for transport.  (For example, a portable
  #    computer user who is not connected to a network might queue a message
  #    for delivery.  The origination date is intended to contain the date
  #    and time that the user queued the message, not the time when the user
  #    connected to the network to send the message.)

  describe "initialization" do

    it "should initialize" do
      doing { Mail::DateField.new("12 Aug 2009 00:00:02 GMT") }.should_not raise_error
    end

    it "should be able to tell the time" do
      Mail::DateField.new("12 Aug 2009 00:00:02 GMT").date_time.class.should == DateTime
    end

    it "should mix in the CommonAddress module" do
      Mail::DateField.included_modules.should include(Mail::CommonDate) 
    end

    it "should accept a string with the field name" do
      t = Mail::DateField.new('Date: 12 Aug 2009 00:00:02 GMT')
      t.name.should == 'Date'
      t.value.should == 'Wed, 12 Aug 2009 00:00:02 +0000'
      t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
    end

    it "should accept a string without the field name" do
      t = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      t.name.should == 'Date'
      t.value.should == 'Wed, 12 Aug 2009 00:00:02 +0000'
      t.date_time.should == ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
    end
    
    it "should accept nil as a value" do
      t = Mail::DateField.new(nil)
      t.date_time.should_not be_nil
    end
    
    it "should allow us to encode an date field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      field.encoded.should == "Date: Wed, 12 Aug 2009 00:00:02 +0000\r\n"
    end
    
    it "should allow us to decode an address field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      field.decoded.should == "Wed, 12 Aug 2009 00:00:02 +0000"
    end

    it "should be able to parse a really bad spacing example" do
      field = Mail::DateField.new("Fri, 21 Nov 1997 09(comment):   55  :  06 -0600")
      field.decoded.should == "Fri, 21 Nov 1997 09:55:06 -0600"
    end
    
  end

end
