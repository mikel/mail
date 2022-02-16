# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::Field do

  describe 'parsing' do
    it "parses full header fields" do
      field = nil
      expect {
        field = Mail::Field.parse('To: Mikel')
      }.to_not output.to_stderr

      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Mikel'
      if field.value.respond_to?(:encoding)
        expect(field.value.encoding).to eq Encoding::UTF_8
      end
      expect(field.field).to be_kind_of(Mail::ToField)
    end

    it "parses missing whitespace" do
      field = Mail::Field.parse('To:Bob')
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob'
    end

    it "parses added inapplicable whitespace" do
      field = Mail::Field.parse('To                  :                   Bob                      ')
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob'
    end
  end

  describe "initialization" do
    it "raises if instantiating by parsing a full header field" do
      expect {
        Mail::Field.new('To: Mikel')
      }.to raise_error(ArgumentError)
    end

    it "instantiates with name and value" do
      expect(Mail::Field.new('To', 'Mikel').field).to be_kind_of(Mail::ToField)
    end

    it "accepts arrays of values" do
      field = Mail::Field.new("To", ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>'])
      expect(field.addresses).to eq ["test1@lindsaar.net", "test2@lindsaar.net"]
    end

    it "accepts omitted values" do
      expect(Mail::Field.new('To').field).to be_kind_of(Mail::ToField)
    end

    it "should match up fields to class names" do
      structured_fields = %w[ Date From Sender Reply-To To Cc Bcc Message-ID In-Reply-To
                              References Keywords Resent-Date Resent-From Resent-Sender
                              Resent-To Resent-Cc Resent-Bcc Resent-Message-ID
                              Return-Path Received Subject Comments Mime-Version
                              Content-Transfer-Encoding Content-Description
                              Content-Disposition Content-Type ]
      structured_fields.each do |sf|
        words = sf.split("-").map { |a| a.capitalize }
        klass = "#{words.join}Field"
        expect(Mail::Field.new(sf).field).to be_kind_of(Mail.const_get(klass))
      end
    end

    %w[ dATE fROM sENDER REPLY-TO TO CC BCC MESSAGE-ID IN-REPLY-TO
        REFERENCES KEYWORDS resent-date resent-from rESENT-sENDER
        rESENT-tO rESent-cc resent-bcc reSent-MESSAGE-iD
        rEtURN-pAtH rEcEiVeD Subject Comments Mime-VeRSIOn
        cOntenT-transfer-EnCoDiNg Content-Description
        Content-Disposition cOnTENt-TyPe
    ].each do |sf|
      words = sf.split("-").map { |a| a.capitalize }
      klass = Mail.const_get("#{words.join}Field")
      it "matches #{sf} to #{klass}" do
        expect(Mail::Field.new(sf).field).to be_kind_of(klass)
      end
    end

    it "should say anything that is not a known field is an optional field" do
      unstructured_fields = %w[ Too Becc bccc Random X-Mail MySpecialField ]
      value = '😊'
      unstructured_fields.each do |sf|
        raw = "#{sf}: #{value}"
        raw = raw.dup.force_encoding(Encoding::BINARY) if raw.respond_to?(:force_encoding)
        field = Mail::Field.parse(raw)
        expect(field.field).to be_kind_of(Mail::OptionalField)
        expect(field.name).to eq(sf)
        expect(field.value).to eq(value)
      end
    end

    it "should return an unstuctured field if the structured field parsing raises an error" do
      expect(Mail::ToField).to receive(:new).and_raise(Mail::Field::ParseError.new(Mail::ToField, 'To: Bob, ,,, Frank, Smith', "Some reason"))
      field = Mail::Field.new('To', 'Bob, ,,, Frank, Smith')
      expect(field.field).to be_kind_of(Mail::UnstructuredField)
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob, ,,, Frank, Smith'
      if field.value.respond_to?(:encoding)
        expect(field.value.encoding).to eq Encoding::UTF_8
      end
    end

    it "delegates to_s to its field" do
      field = Mail::Field.new('To', 'Bob')
      expect(field.field).to receive(:to_s).once
      field.to_s
    end

    it "delegates missing methods to its field" do
      field = Mail::Field.new('To', 'Bob')
      expect(field.field).to receive(:anything_at_all).once
      field.anything_at_all
    end

    it "should respond_to? its own methods and the same methods as its instantiated field class" do
      field = Mail::Field.new('To', 'Bob')
      expect(field.respond_to?(:field)).to be_truthy
      expect(field.field).to receive(:"respond_to?").once
      field.respond_to?(:addresses)
    end

    it "should change its type if you change the name" do
      field = Mail::Field.new('To', 'mikel@me.com')
      expect(field.field).to be_kind_of(Mail::ToField)
      field.value = "bob@me.com"
      expect(field.field).to be_kind_of(Mail::ToField)
    end

    it "should create a field without trying to parse if given a symbol" do
      field = Mail::Field.new('Message-ID')
      expect(field.field).to be_kind_of(Mail::MessageIdField)
    end

    it "should inherit charset" do
      charset = 'iso-2022-jp'
      field = Mail::Field.new('Subject', 'こんにちは', charset)
      expect(field.charset).to eq charset
    end
  end

  describe "error handling" do
    it "should populate the errors array if it finds a field it can't deal with" do
      field = Mail::Field.new('Content-Transfer-Encoding', '8@bit')
      expect(field.field.errors.size).to eq 1
      expect(field.field.errors[0][0]).to eq 'Content-Transfer-Encoding'
      expect(field.field.errors[0][1]).to eq '8@bit'
      expect(field.field.errors[0][2].to_s).to match(/ContentTransferEncodingElement can not parse |17-bit|/)
    end
  end

  describe "helper methods" do
    it "should reply if it is responsible for a field name as a capitalized string - structured field" do
      field = Mail::Field.new('To', 'mikel@test.lindsaar.net')
      expect(field.responsible_for?("To")).to be_truthy
    end

    it "should reply if it is responsible for a field as a lower case string - structured field" do
      field = Mail::Field.new('To', 'mikel@test.lindsaar.net')
      expect(field.responsible_for?("to")).to be_truthy
    end

    it "should reply if it is responsible for a field as a symbol - structured field" do
      field = Mail::Field.new('To', 'mikel@test.lindsaar.net')
      expect(field.responsible_for?(:to)).to be_truthy
    end

    it "should say it is the \"same\" as another if their field types match" do
      expect(Mail::Field.new('To', 'mikel').same(Mail::Field.new('To', 'bob'))).to be_truthy
    end

    it "should say it is not the \"same\" as another if their field types don't match" do
      expect(Mail::Field.new('To', 'mikel').same(Mail::Field.new('From', 'mikel'))).to be_falsey
    end

    it "should say it is not the \"same\" as nil" do
      expect(Mail::Field.new('To', 'mikel').same(nil)).to be_falsey
    end

    it "should say it is == to another if their field and names match" do
      expect(Mail::Field.new('To', 'mikel')).to eq(Mail::Field.new('To', 'mikel'))
    end

    it "should say it is not == to another if their field names do not match" do
      expect(Mail::Field.new('From', 'mikel')).not_to eq(Mail::Field.new('To', 'bob'))
    end

    it "should say it is not == to another if their field names match, but not their values" do
      expect(Mail::Field.new('To', 'mikel')).not_to eq(Mail::Field.new('To', 'bob'))
    end

    it "should say it is not == to nil" do
      expect(Mail::Field.new('From', 'mikel')).not_to eq(nil)
    end

    it "should sort according to the field order" do
      list = [Mail::Field.new('To', 'mikel'), Mail::Field.new('Return-Path', 'bob')]
      expect(list.sort[0].name).to eq "Return-Path"
    end
  end

  describe 'user defined fields' do
    it "should say it is the \"same\" as another if their field names match" do
      expect(Mail::Field.new('X-Foo', 'mikel').same(Mail::Field.new('X-Foo', 'bob'))).to be_truthy
    end

    it "should say it is not == to another if their field names do not match" do
      expect(Mail::Field.new('X-Foo', 'mikel')).not_to eq(Mail::Field.new('X-Bar', 'bob'))
    end
  end

  describe "passing an encoding" do
    it "should allow you to send in unencoded strings to fields and encode them" do
      subject = Mail::SubjectField.new("This is あ string", 'utf-8')
      expect(subject.encoded).to eq "Subject: =?UTF-8?Q?This_is_=E3=81=82_string?=\r\n"
      expect(subject.decoded).to eq "This is あ string"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      to = Mail::ToField.new('"Mikel Lindsああr" <mikel@test.lindsaar.net>', 'utf-8')
      expect(to.encoded).to eq "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in unencoded strings without quotes to address fields and encode them" do
      to = Mail::ToField.new('Mikel Lindsああr <mikel@test.lindsaar.net>', 'utf-8')
      expect(to.encoded).to eq "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      to = Mail::ToField.new("あdあ <ada@test.lindsaar.net>", 'utf-8')
      expect(to.encoded).to eq "To: =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      to = Mail::ToField.new(["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"], 'utf-8')
      expect(to.encoded).to eq "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      mail.charset = 'utf-8'
      array = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      field = Mail::ToField.new(array, 'utf-8')
      expect(field.encoded).to eq "To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      field = Mail::FromField.new(array, 'utf-8')
      expect(field.encoded).to eq "From: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      field = Mail::CcField.new(array, 'utf-8')
      expect(field.encoded).to eq "Cc: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      field = Mail::ReplyToField.new(array, 'utf-8')
      expect(field.encoded).to eq "Reply-To: =?UTF-8?B?TWlrZWwgTGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow an encoded value in the Subject field and decode it automatically (issue 44)" do
      subject = Mail::SubjectField.new("=?ISO-8859-1?Q?2_=FAlt?=", 'utf-8')
      expect(subject.decoded).to eq "2 últ"
    end

    it "should allow you to encoded text in the middle (issue 44)" do
      subject = Mail::SubjectField.new("ma=?ISO-8859-1?Q?=F1ana?=", 'utf-8')
      expect(subject.decoded).to eq "mañana"
    end

    it "more tolerable to encoding definitions, ISO (issue 120)" do
      subject = Mail::SubjectField.new("ma=?ISO88591?Q?=F1ana?=", 'utf-8')
      expect(subject.decoded).to eq "mañana"
    end

    it "more tolerable to encoding definitions, ISO-long (issue 120)" do
      # TODO: JRuby 1.7.0 has an encoding issue https://jira.codehaus.org/browse/JRUBY-6999
      skip if defined?(JRUBY_VERSION) && JRUBY_VERSION >= '1.7.0'

      subject = Mail::SubjectField.new("=?iso2022jp?B?SEVBUlQbJEIkSiQ0TyJNbRsoQg?=", 'utf-8')
      expect(subject.decoded).to eq  "HEARTなご連絡"
    end

    it "more tolerable to encoding definitions, UTF (issue 120)" do
      to = Mail::ToField.new("=?utf-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>", 'utf-8')
      expect(to.decoded).to eq "\"あdあ\" <ada@test.lindsaar.net>"
      expect(to.encoded).to eq "To: =?utf-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "more tolerable to encoding definitions, ISO (issue 120)" do
      subject = Mail::SubjectField.new("=?UTF-8?B?UmU6IHRlc3QgZW52w61vIG1lbnNhamUgY29u?=", 'utf-8')
      expect(subject.decoded).to eq "Re: test envío mensaje con"
    end


    it "more tolerable to encoding definitions, Windows (issue 120)" do
      # TODO: JRuby 1.7.0 has an encoding issue https://jira.codehaus.org/browse/JRUBY-6999
      skip if defined?(JRUBY_VERSION) && JRUBY_VERSION >= '1.7.0'

      subject = Mail::SubjectField.new("=?Windows1252?Q?It=92s_a_test=3F?=", 'utf-8')
      expect(subject.decoded).to eq "It’s a test?"
    end

    it "should support ascii encoded utf-8 subjects" do
      s = "=?utf-8?Q?simp?= =?utf-8?Q?le_=E2=80=93_dash_=E2=80=93_?="

      subject = Mail::SubjectField.new(s, 'utf-8')
      expect(subject.decoded).to eq("simple – dash – ")
    end

    it "should support ascii encoded windows subjects" do
      # TODO: JRuby 1.7.0 has an encoding issue https://jira.codehaus.org/browse/JRUBY-6999
      skip if defined?(JRUBY_VERSION) && JRUBY_VERSION >= '1.7.0'

      s = "=?WINDOWS-1252?Q?simp?= =?WINDOWS-1252?Q?le_=96_dash_=96_?="

      subject = Mail::SubjectField.new(s, "UTF-8")
      expect(subject.decoded).to eq("simple – dash – ")
    end
  end

  describe "value" do
    let(:original) { { :template => "t1" } }
    subject { Mail::Field.new("name", original) }

    context "parsed" do
      it "returns parsed value" do
        expect(subject.value).to eq(original.to_s)
      end
    end

    context "unparsed" do
      it "returns origin unparsed value" do
        expect(subject.unparsed_value).to eq(original)
      end
    end
  end

  describe Mail::Field::ParseError do
    it "should be structured" do
      error = nil
      begin
        Mail::DateTimeElement.new("invalid")
      rescue Mail::Field::ParseError => e
        error = e
      end
      expect(error).not_to be_nil
      expect(error.element).to eq Mail::DateTimeElement
      expect(error.value).to eq "invalid"
      expect(error.reason).not_to be_nil
    end
  end

end
