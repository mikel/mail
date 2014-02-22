# encoding: utf-8
require 'spec_helper'
# 3.6.4. Identification fields
#  
#   Though optional, every message SHOULD have a "Message-ID:" field.
#   Furthermore, reply messages SHOULD have "In-Reply-To:" and
#   "References:" fields as appropriate, as described below.
#   
#   The "Message-ID:" field contains a single unique message identifier.
#   The "References:" and "In-Reply-To:" field each contain one or more
#   unique message identifiers, optionally separated by CFWS.
#   
#   The message identifier (msg-id) is similar in syntax to an angle-addr
#   construct without the internal CFWS.
#  
#  message-id      =       "Message-ID:" msg-id CRLF
#  
#  in-reply-to     =       "In-Reply-To:" 1*msg-id CRLF
#  
#  references      =       "References:" 1*msg-id CRLF
#  
#  msg-id          =       [CFWS] "<" id-left "@" id-right ">" [CFWS]
#  
#  id-left         =       dot-atom-text / no-fold-quote / obs-id-left
#  
#  id-right        =       dot-atom-text / no-fold-literal / obs-id-right
#  
#  no-fold-quote   =       DQUOTE *(qtext / quoted-pair) DQUOTE
#  
#  no-fold-literal =       "[" *(dtext / quoted-pair) "]"
#  
#    The "Message-ID:" field provides a unique message identifier that
#    refers to a particular version of a particular message.  The
#    uniqueness of the message identifier is guaranteed by the host that
#    generates it (see below).  This message identifier is intended to be
#    machine readable and not necessarily meaningful to humans.  A message
#    identifier pertains to exactly one instantiation of a particular
#    message; subsequent revisions to the message each receive new message
#    identifiers.
#     
#    Note: There are many instances when messages are "changed", but those
#    changes do not constitute a new instantiation of that message, and
#    therefore the message would not get a new message identifier.  For
#    example, when messages are introduced into the transport system, they
#    are often prepended with additional header fields such as trace
#    fields (described in section 3.6.7) and resent fields (described in
#    section 3.6.6).  The addition of such header fields does not change
#    the identity of the message and therefore the original "Message-ID:"
#    field is retained.  In all cases, it is the meaning that the sender
#    of the message wishes to convey (i.e., whether this is the same
#    message or a different message) that determines whether or not the
#    "Message-ID:" field changes, not any particular syntactic difference
#    that appears (or does not appear) in the message.

describe Mail::MessageIdField do

  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::MessageIdField.new("<1234@test.lindsaar.net>") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      m = Mail::MessageIdField.new('Message-ID: <1234@test.lindsaar.net>')
      expect(m.name).to eq 'Message-ID'
      expect(m.value).to eq '<1234@test.lindsaar.net>'
      expect(m.message_id).to eq '1234@test.lindsaar.net'
    end

    it "should accept a string without the field name" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      expect(m.name).to eq 'Message-ID'
      expect(m.value).to eq '<1234@test.lindsaar.net>'
      expect(m.message_id).to eq '1234@test.lindsaar.net'
    end

    it "should accept a nil value and generate a message_id" do
      m = Mail::MessageIdField.new(nil)
      expect(m.name).to eq 'Message-ID'
      expect(m.value).not_to be_nil
    end

  end
  
  describe "ensuring only one message ID" do

    it "should not accept a string with multiple message IDs but only return the first" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net> <4567@test.lindsaar.net>')
      expect(m.name).to eq 'Message-ID'
      expect(m.to_s).to eq '<1234@test.lindsaar.net>'
      expect(m.message_id).to eq '1234@test.lindsaar.net'
      expect(m.message_ids).to eq ['1234@test.lindsaar.net']
    end

    it "should change the message id if given a new message id" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      expect(m.to_s).to eq '<1234@test.lindsaar.net>'
      m.value = '<4567@test.lindsaar.net>'
      expect(m.to_s).to eq '<4567@test.lindsaar.net>'
    end

  end

  describe "instance methods" do
    it "should provide to_s" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      expect(m.to_s).to eq '<1234@test.lindsaar.net>'
      expect(m.message_id.to_s).to eq '1234@test.lindsaar.net'
    end

    it "should provide encoded" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      expect(m.encoded).to eq "Message-ID: <1234@test.lindsaar.net>\r\n"
    end

    it "should provide decoded" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      expect(m.decoded).to eq "<1234@test.lindsaar.net>"
    end
    
    it "should respond to :responsible_for?" do
      m = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      expect(m).to respond_to(:responsible_for?)
    end
  end

  describe "generating a message id" do
    it "should generate a message ID if it has no value" do
      m = Mail::MessageIdField.new
      expect(m.message_id).not_to be_blank
    end
    
    it "should generate a random message ID" do
      m = Mail::MessageIdField.new
      1.upto(100) do
        expect(m.message_id).not_to eq(Mail::MessageIdField.new.message_id)
      end
    end
  end
  
  describe "weird message IDs" do
    it "should be able to parse <000701c874a6$3df7eaf0$b9e7c0d0$@geille@fiscon.com>" do
      m = Mail::MessageIdField.new('<000701c874a6$3df7eaf0$b9e7c0d0$@geille@fiscon.com>')
      expect(m.message_id).to eq '000701c874a6$3df7eaf0$b9e7c0d0$@geille@fiscon.com'
    end
  end
end
