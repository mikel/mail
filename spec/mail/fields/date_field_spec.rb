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
      expect(doing { Mail::DateField.new("12 Aug 2009 00:00:02 GMT") }).not_to raise_error
    end

    it "should be able to tell the time" do
      expect(Mail::DateField.new("12 Aug 2009 00:00:02 GMT").date_time.class).to eq DateTime
    end

    it "should mix in the CommonAddress module" do
      expect(Mail::DateField.included_modules).to include(Mail::CommonDate) 
    end

    it "should accept a string with the field name" do
      t = Mail::DateField.new('Date: 12 Aug 2009 00:00:02 GMT')
      expect(t.name).to eq 'Date'
      expect(t.value).to eq 'Wed, 12 Aug 2009 00:00:02 +0000'
      expect(t.date_time).to eq ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
    end

    it "should accept a string without the field name" do
      t = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      expect(t.name).to eq 'Date'
      expect(t.value).to eq 'Wed, 12 Aug 2009 00:00:02 +0000'
      expect(t.date_time).to eq ::DateTime.parse('12 Aug 2009 00:00:02 GMT')
    end
    
    it "should accept nil as a value" do
      t = Mail::DateField.new(nil)
      expect(t.date_time).not_to be_nil
    end
    
    it "should allow us to encode an date field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      expect(field.encoded).to eq "Date: Wed, 12 Aug 2009 00:00:02 +0000\r\n"
    end
    
    it "should allow us to decode an address field" do
      field = Mail::DateField.new('12 Aug 2009 00:00:02 GMT')
      expect(field.decoded).to eq "Wed, 12 Aug 2009 00:00:02 +0000"
    end

    it "should be able to parse a really bad spacing example" do
      field = Mail::DateField.new("Fri, 21 Nov 1997 09(comment):   55  :  06 -0600")
      expect(field.decoded).to eq "Fri, 21 Nov 1997 09:55:06 -0600"
    end

    it "should give today's date if no date is specified" do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)
      expect(Mail::DateField.new.date_time).to eq ::DateTime.parse(now.to_s)
    end
    
  end

end
