require 'spec_helper'

describe Mail::Envelope do
  # From RFC4155 The application/mbox Media Type
  #
  #   o Each message in the mbox database MUST be immediately preceded
  #     by a single separator line, which MUST conform to the following
  #     syntax:
  #
  #        The exact character sequence of "From";
  #
  #        a single Space character (0x20);
  #
  #        the email address of the message sender (as obtained from the
  #        message envelope or other authoritative source), conformant
  #        with the "addr-spec" syntax from RFC 2822;
  #
  #        a single Space character;
  #
  #        a timestamp indicating the UTC date and time when the message
  #        was originally received, conformant with the syntax of the
  #        traditional UNIX 'ctime' output sans timezone (note that the
  #        use of UTC precludes the need for a timezone indicator);
  #
  #        an end-of-line marker.

  it "should initialize" do
    expect(doing { Mail::Envelope.new('mikel@test.lindsaar.net Mon May  2 16:07:05 2005') }).not_to raise_error
  end

  describe "accessor methods" do
    it "should return the address" do
      envelope = Mail::Envelope.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      expect(envelope.from).to eq "mikel@test.lindsaar.net"
    end

    it "should return the date_time" do
      envelope = Mail::Envelope.new("mikel@test.lindsaar.net Mon Aug 17 00:39:21 2009")
      expect(envelope.date).to eq ::DateTime.parse("Mon Aug 17 00:39:21 2009")
    end
  end

end
