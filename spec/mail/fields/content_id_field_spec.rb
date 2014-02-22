require 'spec_helper'

describe Mail::ContentIdField do
  # Content-ID Header Field
  #
  # In constructing a high-level user agent, it may be desirable to allow
  # one body to make reference to another.  Accordingly, bodies may be
  # labelled using the "Content-ID" header field, which is syntactically
  # identical to the "Content-ID" header field:
  #
  #   id := "Content-ID" ":" msg-id
  #
  # Like the Content-ID values, Content-ID values must be generated to be
  # world-unique.
  #
  # The Content-ID value may be used for uniquely identifying MIME
  # entities in several contexts, particularly for caching data
  # referenced by the message/external-body mechanism.  Although the
  # Content-ID header is generally optional, its use is MANDATORY in
  # implementations which generate data of the optional MIME media type
  # "message/external-body".  That is, each message/external-body entity
  # must have a Content-ID field to permit caching of such data.
  #
  # It is also worth noting that the Content-ID value has special
  # semantics in the case of the multipart/alternative media type.  This
  # is explained in the section of RFC 2046 dealing with
  # multipart/alternative.


  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ContentIdField.new("<1234@test.lindsaar.net>") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      c = Mail::ContentIdField.new('Content-ID: <1234@test.lindsaar.net>')
      expect(c.name).to eq 'Content-ID'
      expect(c.value).to eq '<1234@test.lindsaar.net>'
      expect(c.content_id).to eq '1234@test.lindsaar.net'
    end

    it "should accept a string without the field name" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m.name).to eq 'Content-ID'
      expect(m.value).to eq '<1234@test.lindsaar.net>'
      expect(m.content_id).to eq '1234@test.lindsaar.net'
    end

    it "should accept a nil value and generate a content_id" do
      m = Mail::ContentIdField.new(nil)
      expect(m.name).to eq 'Content-ID'
      expect(m.value).not_to be_nil
    end

    it "should allow it to be encoded" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m.encoded).to eq "Content-ID: <1234@test.lindsaar.net>\r\n"
    end

    it "should allow it to be decoded" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m.decoded).to eq "<1234@test.lindsaar.net>"
    end

  end
  
  describe "ensuring only one message ID" do

    it "should not accept a string with multiple message IDs but only return the first" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net> <4567@test.lindsaar.net>')
      expect(m.name).to eq 'Content-ID'
      expect(m.to_s).to eq '<1234@test.lindsaar.net>'
      expect(m.content_id).to eq '1234@test.lindsaar.net'
    end

    it "should change the message id if given a new message id" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m.to_s).to eq '<1234@test.lindsaar.net>'
      m.value = '<4567@test.lindsaar.net>'
      expect(m.to_s).to eq '<4567@test.lindsaar.net>'
    end

  end

  describe "instance methods" do
    it "should provide to_s" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m.to_s).to eq '<1234@test.lindsaar.net>'
      expect(m.content_id.to_s).to eq '1234@test.lindsaar.net'
    end

    it "should provide encoded" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m.encoded).to eq "Content-ID: <1234@test.lindsaar.net>\r\n"
    end
    
    it "should respond to :responsible_for?" do
      m = Mail::ContentIdField.new('<1234@test.lindsaar.net>')
      expect(m).to respond_to(:responsible_for?)
    end
  end

  describe "generating a message id" do
    it "should generate a message ID if it has no value" do
      m = Mail::ContentIdField.new
      expect(m.content_id).not_to be_blank
    end
    
    it "should generate a random message ID" do
      m = Mail::ContentIdField.new
      1.upto(100) do
        expect(m.content_id).not_to eq(Mail::ContentIdField.new.content_id)
      end
    end
  end
end
