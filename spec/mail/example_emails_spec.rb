# encoding: utf-8
require 'spec_helper'

describe "Test emails" do

  describe "from RFC2822" do

    # From RFC 2822:
    # This could be called a canonical message.  It has a single author,
    # John Doe, a single recipient, Mary Smith, a subject, the date, a
    # message identifier, and a textual message in the body.
    it "should handle the basic test email" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example01.eml'))
      mail.from.should eq ["jdoe@machine.example"]
      mail.to.should eq ['mary@example.net']
      mail.message_id.should eq '1234@local.machine.example'
      mail.date.should eq ::DateTime.parse('21 Nov 1997 09:55:06 -0600')
      mail.subject.should eq 'Saying Hello'
    end

    # From RFC 2822:
    # If John's secretary Michael actually sent the message, though John
    # was the author and replies to this message should go back to him, the
    # sender field would be used:
    it "should handle the sender test email" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example02.eml'))
      mail.from.should eq ['jdoe@machine.example']
      mail.sender.should eq 'mjones@machine.example'
      mail.to.should eq ['mary@example.net']
      mail.message_id.should eq '1234@local.machine.example'
      mail.date.should eq ::DateTime.parse('21 Nov 1997 09:55:06 -0600')
      mail.subject.should eq 'Saying Hello'
    end

    # From RFC 2822:
    # This message includes multiple addresses in the destination fields
    # and also uses several different forms of addresses.
    #
    # Note that the display names for Joe Q. Public and Giant; "Big" Box
    # needed to be enclosed in double-quotes because the former contains
    # the period and the latter contains both semicolon and double-quote
    # characters (the double-quote characters appearing as quoted-pair
    # construct).  Conversely, the display name for Who? could appear
    # without them because the question mark is legal in an atom.  Notice
    # also that jdoe@example.org and boss@nil.test have no display names
    # associated with them at all, and jdoe@example.org uses the simpler
    # address form without the angle brackets.
    #
    # "Giant; \"Big\" Box" <sysservices@example.net>
    it "should handle multiple recipients test email" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example03.eml'))
      mail.from.should eq ['john.q.public@example.com']
      mail.to.should eq ['mary@x.test', 'jdoe@example.org', 'one@y.test']
      mail.cc.should eq ['boss@nil.test', "sysservices@example.net"]
      mail.message_id.should eq '5678.21-Nov-1997@example.com'
      mail.date.should eq ::DateTime.parse('1 Jul 2003 10:52:37 +0200')
    end

    # From RFC 2822:
    # A.1.3. Group addresses
    # In this message, the "To:" field has a single group recipient named A
    # Group which contains 3 addresses, and a "Cc:" field with an empty
    # group recipient named Undisclosed recipients.
    it "should handle group address email test" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example04.eml'))
      mail.from.should eq ['pete@silly.example']
      mail.to.should eq ['c@a.test', 'joe@where.test', 'jdoe@one.test']
      mail[:cc].group_names.should eq ['Undisclosed recipients']
      mail.message_id.should eq 'testabcd.1234@silly.example'
      mail.date.should eq ::DateTime.parse('Thu, 13 Feb 1969 23:32:54 -0330')
    end


    # From RFC 2822:
    # A.2. Reply messages
    # The following is a series of three messages that make up a
    # conversation thread between John and Mary.  John firsts sends a
    # message to Mary, Mary then replies to John's message, and then John
    # replies to Mary's reply message.
    #
    # Note especially the "Message-ID:", "References:", and "In-Reply-To:"
    # fields in each message.
    it "should handle reply messages" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example05.eml'))
      mail.from.should eq ["jdoe@machine.example"]
      mail.to.should eq ['mary@example.net']
      mail.subject.should eq 'Saying Hello'
      mail.message_id.should eq '1234@local.machine.example'
      mail.date.should eq ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
    end

    # From RFC 2822:
    # When sending replies, the Subject field is often retained, though
    # prepended with "Re: " as described in section 3.6.5.
    # Note the "Reply-To:" field in the below message.  When John replies
    # to Mary's message above, the reply should go to the address in the
    # "Reply-To:" field instead of the address in the "From:" field.
    it "should handle reply message 2" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example06.eml'))
      mail.from.should eq ['mary@example.net']
      mail.to.should eq ['jdoe@machine.example']
      mail.reply_to.should eq ['smith@home.example']
      mail.subject.should eq 'Re: Saying Hello'
      mail.message_id.should eq '3456@example.net'
      mail[:in_reply_to].message_ids.should eq ['1234@local.machine.example']
      mail[:references].message_ids.should eq ['1234@local.machine.example']
      mail.date.should eq ::DateTime.parse('Fri, 21 Nov 1997 10:01:10 -0600')
    end

    # From RFC 2822:
    # Final reply message
    it "should handle the final reply message" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example07.eml'))
      mail.to.should eq ['smith@home.example']
      mail.from.should eq ['jdoe@machine.example']
      mail.subject.should eq 'Re: Saying Hello'
      mail.date.should eq ::DateTime.parse('Fri, 21 Nov 1997 11:00:00 -0600')
      mail.message_id.should eq 'abcd.1234@local.machine.tld'
      mail.in_reply_to.should eq '3456@example.net'
      mail[:references].message_ids.should eq ['1234@local.machine.example', '3456@example.net']
    end

    # From RFC2822
    # A.3. Resent messages
    # Say that Mary, upon receiving this message, wishes to send a copy of
    # the message to Jane such that (a) the message would appear to have
    # come straight from John; (b) if Jane replies to the message, the
    # reply should go back to John; and (c) all of the original
    # information, like the date the message was originally sent to Mary,
    # the message identifier, and the original addressee, is preserved.  In
    # this case, resent fields are prepended to the message:
    #
    # If Jane, in turn, wished to resend this message to another person,
    # she would prepend her own set of resent header fields to the above
    # and send that.
    it "should handle the rfc resent example email" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example08.eml'))
      mail.resent_from.should eq ['mary@example.net']
      mail.resent_to.should eq ['j-brown@other.example']
      mail.resent_date.should eq ::DateTime.parse('Mon, 24 Nov 1997 14:22:01 -0800')
      mail.resent_message_id.should eq '78910@example.net'
      mail.from.should eq ['jdoe@machine.example']
      mail.to.should eq ['mary@example.net']
      mail.subject.should eq 'Saying Hello'
      mail.date.should eq ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
      mail.message_id.should eq '1234@local.machine.example'
    end

    # A.4. Messages with trace fields
    # As messages are sent through the transport system as described in
    # [RFC2821], trace fields are prepended to the message.  The following
    # is an example of what those trace fields might look like.  Note that
    # there is some folding white space in the first one since these lines
    # can be long.
    it "should handle the RFC trace example email" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example09.eml'))
      mail.received[0].info.should eq 'from x.y.test by example.net via TCP with ESMTP id ABC12345 for <mary@example.net>'
      mail.received[0].date_time.should eq ::DateTime.parse('21 Nov 1997 10:05:43 -0600')
      mail.received[1].info.should eq 'from machine.example by x.y.test'
      mail.received[1].date_time.should eq ::DateTime.parse('21 Nov 1997 10:01:22 -0600')
      mail.from.should eq ['jdoe@machine.example']
      mail.to.should eq ['mary@example.net']
      mail.subject.should eq 'Saying Hello'
      mail.date.should eq ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
      mail.message_id.should eq '1234@local.machine.example'
    end

    # A.5. White space, comments, and other oddities
    # White space, including folding white space, and comments can be
    # inserted between many of the tokens of fields.  Taking the example
    # from A.1.3, white space and comments can be inserted into all of the
    # fields.
    #
    # The below example is aesthetically displeasing, but perfectly legal.
    # Note particularly (1) the comments in the "From:" field (including
    # one that has a ")" character appearing as part of a quoted-pair); (2)
    # the white space absent after the ":" in the "To:" field as well as
    # the comment and folding white space after the group name, the special
    # character (".") in the comment in Chris Jones's address, and the
    # folding white space before and after "joe@example.org,"; (3) the
    # multiple and nested comments in the "Cc:" field as well as the
    # comment immediately following the ":" after "Cc"; (4) the folding
    # white space (but no comments except at the end) and the missing
    # seconds in the time of the date field; and (5) the white space before
    # (but not within) the identifier in the "Message-ID:" field.

    it "should handle the rfc whitespace test email" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example10.eml'))
      mail.from.should eq ["pete(his account)@silly.test"]
      mail.to.should eq  ["c@(Chris's host.)public.example", "joe@example.org", "jdoe@one.test"]
      mail[:cc].group_names.should eq ['(Empty list)(start)Undisclosed recipients ']
      mail.date.should eq ::DateTime.parse('Thu, 13 Feb 1969 23:32 -0330')
      mail.message_id.should eq 'testabcd.1234@silly.test'
    end

    # A.6. Obsoleted forms
    # The following are examples of obsolete (that is, the "MUST NOT
    # generate") syntactic elements described in section 4 of this
    # document.
    # A.6.1. Obsolete addressing
    # Note in the below example the lack of quotes around Joe Q. Public,
    # the route that appears in the address for Mary Smith, the two commas
    # that appear in the "To:" field, and the spaces that appear around the
    # "." in the jdoe address.
    it "should handle the rfc obsolete addressing" do
      pending
      mail = Mail.read(fixture('emails', 'rfc2822', 'example11.eml'))
      mail[:from].addresses.should eq ['john.q.public@example.com']
      mail.from.should eq '"Joe Q. Public" <john.q.public@example.com>'
      mail.to.should eq ["@machine.tld:mary@example.net", 'jdoe@test.example']
      mail.date.should eq ::DateTime.parse('Tue, 1 Jul 2003 10:52:37 +0200')
      mail.message_id.should eq '5678.21-Nov-1997@example.com'
    end

    # A.6.2. Obsolete dates
    #
    # The following message uses an obsolete date format, including a non-
    # numeric time zone and a two digit year.  Note that although the
    # day-of-week is missing, that is not specific to the obsolete syntax;
    # it is optional in the current syntax as well.
    it "should handle the rfc obsolete dates" do
      pending
      mail = Mail.read(fixture('emails', 'rfc2822', 'example12.eml'))
      mail.from.should eq 'jdoe@machine.example'
      mail.to.should eq 'mary@example.net'
      mail.date.should eq ::DateTime.parse('21 Nov 97 09:55:06 GMT')
      mail.message_id.should eq '1234@local.machine.example'
    end

    # A.6.3. Obsolete white space and comments
    #
    # White space and comments can appear between many more elements than
    # in the current syntax.  Also, folding lines that are made up entirely
    # of white space are legal.
    #
    # Note especially the second line of the "To:" field.  It starts with
    # two space characters.  (Note that "__" represent blank spaces.)
    # Therefore, it is considered part of the folding as described in
    # section 4.2.  Also, the comments and white space throughout
    # addresses, dates, and message identifiers are all part of the
    # obsolete syntax.
    it "should handle the rfc obsolete whitespace email" do
      pending
      mail = Mail.read(fixture('emails', 'rfc2822', 'example13.eml'))
      mail.from.should eq 'John Doe <jdoe@machine(comment).example>'
      mail.to.should eq 'Mary Smith <mary@example.net>'
      mail.date.should eq ::DateTime.parse('Fri, 21 Nov 1997 09:55:06 -0600')
      mail.message_id.should eq '1234@local(blah).machine.example'
      doing { Mail::Message.new(email) }.should_not raise_error
    end

    it "should handle folding subject" do
      mail = Mail.read(fixture('emails', 'rfc2822', 'example14.eml'))
      mail.from.should eq ["atsushi@example.com"]
      mail.subject.should eq "Re: TEST テストテスト"
      mail.message_id.should eq '0CC5E11ED2C1D@example.com'
      mail.body.should eq "Hello"
    end
  end

  describe "from the wild" do

    describe "raw_email_encoded_stack_level_too_deep.eml" do
      before(:each) do
        @message = Mail::Message.new(File.read(fixture('emails', 'mime_emails', 'raw_email_encoded_stack_level_too_deep.eml')))
      end

      it "should return an 'encoded' version without raising a SystemStackError" do
        doing { @message.encoded }.should_not raise_error
      end

      it "should have two parts" do
        @message.parts.length.should eq 2
      end

    end

    describe "sig_only_email.eml" do
      before(:each) do
        @message = Mail::Message.new(File.read(fixture('emails', 'mime_emails', 'sig_only_email.eml')))
      end

      it "should not error on multiart/signed emails" do
        doing { @message.encoded }.should_not raise_error
      end

      it "should have one attachment called signature.asc" do
        @message.attachments.length.should eq 1
        @message.attachments.first.filename.should eq 'signature.asc'
      end

    end

    describe "handling invalid group lists" do
      before(:each) do
        @message = Mail::Message.new(File.read(fixture('emails', 'error_emails', 'empty_group_lists.eml')))
      end

      it "should parse the email and encode without crashing" do
        doing { @message.encoded }.should_not raise_error
      end

      it "should return an empty groups list" do
        @message[:to].group_addresses.should eq []
      end
    end

  end

  describe "empty address lists" do

    before(:each) do
      @message = Mail::Message.new(File.read(fixture('emails', 'error_emails', 'weird_to_header.eml')))
    end

    it "should parse the email and encode without crashing" do
      doing { @message.encoded }.should_not raise_error
    end

    it "should return an empty groups list" do
      @message.to.should eq ['user-example@aol.com', 'e-s-a-s-2200@app.ar.com']
    end

  end

end
