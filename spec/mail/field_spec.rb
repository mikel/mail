# encoding: utf-8
require 'spec_helper'

describe Mail::Field do

  describe "initialization" do

    it "should be instantiated" do
      expect {Mail::Field.new('To: Mikel')}.not_to raise_error
      expect(Mail::Field.new('To: Mikel').field.class).to eq Mail::ToField
    end

    it "should allow you to init on an array" do
      field = Mail::Field.new("To", ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>'])
      expect(field.addresses).to eq ["test1@lindsaar.net", "test2@lindsaar.net"]
    end

    it "should allow us to pass an empty value" do
      expect {Mail::Field.new('To')}.not_to raise_error
      expect(Mail::Field.new('To').field.class).to eq Mail::ToField
    end

    it "should allow us to pass a value" do
      expect {Mail::Field.new('To', 'Mikel')}.not_to raise_error
      expect(Mail::Field.new('To', 'Mikel').field.class).to eq Mail::ToField
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
        expect(Mail::Field.new("#{sf}: ").field.class).to eq Mail.const_get(klass)
      end
    end

    it "should match up fields to class names regardless of case" do
      structured_fields = %w[ dATE fROM sENDER REPLY-TO TO CC BCC MESSAGE-ID IN-REPLY-TO
                              REFERENCES KEYWORDS resent-date resent-from rESENT-sENDER
                              rESENT-tO rESent-cc resent-bcc reSent-MESSAGE-iD
                              rEtURN-pAtH rEcEiVeD Subject Comments Mime-VeRSIOn
                              cOntenT-transfer-EnCoDiNg Content-Description
                              Content-Disposition cOnTENt-TyPe ]
      structured_fields.each do |sf|
        words = sf.split("-").map { |a| a.capitalize }
        klass = "#{words.join}Field"
        expect(Mail::Field.new("#{sf}: ").field.class).to eq Mail.const_get(klass)
      end
    end

    it "should say anything that is not a known field is an optional field" do
      unstructured_fields = %w[ Too Becc bccc Random X-Mail MySpecialField ]
      unstructured_fields.each do |sf|
        expect(Mail::Field.new("#{sf}: Value").field.class).to eq Mail::OptionalField
      end
    end

    it "should split the name and values out of the raw field passed in" do
      field = Mail::Field.new('To: Bob')
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob'
    end

    it "should split the name and values out of the raw field passed in if missing whitespace" do
      field = Mail::Field.new('To:Bob')
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob'
    end

    it "should split the name and values out of the raw field passed in if having added inapplicable whitespace" do
      field = Mail::Field.new('To                  :                   Bob                      ')
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob'
    end

    it "should return an unstuctured field if the structured field parsing raises an error" do
      expect(Mail::ToField).to receive(:new).and_raise(Mail::Field::ParseError.new(Mail::ToField, 'To: Bob, ,,, Frank, Smith', "Some reason"))
      field = Mail::Field.new('To: Bob, ,,, Frank, Smith')
      expect(field.field.class).to eq Mail::UnstructuredField
      expect(field.name).to eq 'To'
      expect(field.value).to eq 'Bob, ,,, Frank, Smith'
    end

    it "should call to_s on its field when sent to_s" do
      @field = Mail::SubjectField.new('Subject: Hello bob')
      expect(Mail::SubjectField).to receive(:new).and_return(@field)
      expect(@field).to receive(:to_s).once
      Mail::Field.new('Subject: Hello bob').to_s
    end

    it "should pass missing methods to its instantiated field class" do
      field = Mail::Field.new('To: Bob')
      expect(field.field).to receive(:addresses).once
      field.addresses
    end

    it "should change its type if you change the name" do
      field = Mail::Field.new("To: mikel@me.com")
      expect(field.field.class).to eq Mail::ToField
      field.value = "bob@me.com"
      expect(field.field.class).to eq Mail::ToField
    end

    it "should create a field without trying to parse if given a symbol" do
      field = Mail::Field.new('Message-ID')
      expect(field.field.class).to eq Mail::MessageIdField
    end

    it "should inherit charset" do
      charset = 'iso-2022-jp'
      field = Mail::Field.new('Subject: こんにちは', charset)
      expect(field.charset).to eq charset
    end
  end

  describe "error handling" do
    it "should populate the errors array if it finds a field it can't deal with" do
      field = Mail::Field.new('Content-Transfer-Encoding: 8@bit')
      expect(field.field.errors.size).to eq 1
      expect(field.field.errors[0][0]).to eq 'Content-Transfer-Encoding'
      expect(field.field.errors[0][1]).to eq '8@bit'
      expect(field.field.errors[0][2].to_s).to match(/ContentTransferEncodingElement can not parse |17-bit|/)
    end
  end

  describe "helper methods" do
    it "should reply if it is responsible for a field name as a capitalized string - structured field" do
      field = Mail::Field.new("To: mikel@test.lindsaar.net")
      expect(field.responsible_for?("To")).to be_truthy
    end

    it "should reply if it is responsible for a field as a lower case string - structured field" do
      field = Mail::Field.new("To: mikel@test.lindsaar.net")
      expect(field.responsible_for?("to")).to be_truthy
    end

    it "should reply if it is responsible for a field as a symbol - structured field" do
      field = Mail::Field.new("To: mikel@test.lindsaar.net")
      expect(field.responsible_for?(:to)).to be_truthy
    end

    it "should say it is == to another if their field names match" do
      expect(Mail::Field.new("To: mikel").same(Mail::Field.new("To: bob"))).to be_truthy
    end

    it "should say it is not == to another if their field names do not match" do
      expect(Mail::Field.new("From: mikel")).not_to eq(Mail::Field.new("To: bob"))
    end

    it "should sort according to the field order" do
      list = [Mail::Field.new("To: mikel"), Mail::Field.new("Return-Path: bob")]
      expect(list.sort[0].name).to eq "Return-Path"
    end
  end

  describe 'user defined fields' do
    it "should say it is == to another if their field names match" do
      expect(Mail::Field.new("X-Foo: mikel").same(Mail::Field.new("X-Foo: bob"))).to be_truthy
    end

    it "should say it is not == to another if their field names do not match" do
      expect(Mail::Field.new("X-Foo: mikel")).not_to eq(Mail::Field.new("X-Bar: bob"))
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
      expect(to.encoded).to eq "To: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in unencoded strings to address fields and encode them" do
      to = Mail::ToField.new("あdあ <ada@test.lindsaar.net>", 'utf-8')
      expect(to.encoded).to eq "To: =?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to address fields and encode them" do
      to = Mail::ToField.new(["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"], 'utf-8')
      expect(to.encoded).to eq "To: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow you to send in multiple unencoded strings to any address field" do
      mail = Mail.new
      mail.charset = 'utf-8'
      array = ["Mikel Lindsああr <mikel@test.lindsaar.net>", "あdあ <ada@test.lindsaar.net>"]
      field = Mail::ToField.new(array, 'utf-8')
      expect(field.encoded).to eq "#{Mail::ToField::CAPITALIZED_FIELD}: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      field = Mail::FromField.new(array, 'utf-8')
      expect(field.encoded).to eq "#{Mail::FromField::CAPITALIZED_FIELD}: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      field = Mail::CcField.new(array, 'utf-8')
      expect(field.encoded).to eq "#{Mail::CcField::CAPITALIZED_FIELD}: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      field = Mail::ReplyToField.new(array, 'utf-8')
      expect(field.encoded).to eq "#{Mail::ReplyToField::CAPITALIZED_FIELD}: Mikel =?UTF-8?B?TGluZHPjgYLjgYJy?= <mikel@test.lindsaar.net>, \r\n\s=?UTF-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
    end

    it "should allow an encoded value in the Subject field and decode it automatically (issue 44)" do
      skip if RUBY_VERSION < '1.9'
      subject = Mail::SubjectField.new("=?ISO-8859-1?Q?2_=FAlt?=", 'utf-8')
      expect(subject.decoded).to eq "2 últ"
    end

    it "should allow you to encoded text in the middle (issue 44)" do
      skip if RUBY_VERSION < '1.9'
      subject = Mail::SubjectField.new("ma=?ISO-8859-1?Q?=F1ana?=", 'utf-8')
      expect(subject.decoded).to eq "mañana"
    end

    it "more tolerable to encoding definitions, ISO (issue 120)" do
      skip if RUBY_VERSION < '1.9'
      subject = Mail::SubjectField.new("ma=?ISO88591?Q?=F1ana?=", 'utf-8')
      expect(subject.decoded).to eq "mañana"
    end

    it "more tolerable to encoding definitions, ISO-long (issue 120)" do
      # Rubies under 1.9 don't handle encoding conversions
      skip if RUBY_VERSION < '1.9'

      # TODO: JRuby 1.7.0 has an encoding issue https://jira.codehaus.org/browse/JRUBY-6999
      skip if defined?(JRUBY_VERSION) && JRUBY_VERSION >= '1.7.0'

      subject = Mail::SubjectField.new("=?iso2022jp?B?SEVBUlQbJEIkSiQ0TyJNbRsoQg?=", 'utf-8')
      expect(subject.decoded).to eq  "HEARTなご連絡"
    end

    it "more tolerable to encoding definitions, UTF (issue 120)" do
      to = Mail::ToField.new("=?utf-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>", 'utf-8')
      expect(to.encoded).to eq "To: =?utf-8?B?44GCZOOBgg==?= <ada@test.lindsaar.net>\r\n"
      expect(to.decoded).to eq "\"あdあ\" <ada@test.lindsaar.net>"
    end

    it "more tolerable to encoding definitions, ISO (issue 120)" do
      subject = Mail::SubjectField.new("=?UTF-8?B?UmU6IHRlc3QgZW52w61vIG1lbnNhamUgY29u?=", 'utf-8')
      expect(subject.decoded).to eq "Re: test envío mensaje con"
    end


    it "more tolerable to encoding definitions, Windows (issue 120)" do
      skip if RUBY_VERSION < '1.9'

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
      skip if RUBY_VERSION < '1.9'

      # TODO: JRuby 1.7.0 has an encoding issue https://jira.codehaus.org/browse/JRUBY-6999
      skip if defined?(JRUBY_VERSION) && JRUBY_VERSION >= '1.7.0'

      s = "=?WINDOWS-1252?Q?simp?= =?WINDOWS-1252?Q?le_=96_dash_=96_?="

      subject = Mail::SubjectField.new(s, "UTF-8")
      expect(subject.decoded).to eq("simple – dash – ")
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
