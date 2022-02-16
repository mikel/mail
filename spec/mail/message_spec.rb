# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe Mail::Message do

  def basic_email
    "To: mikel\r\nFrom: bob\r\nSubject: Hello!\r\n\r\nemail message\r\n"
  end

  describe "initialization" do

    it "should instantiate empty" do
      expect(Mail::Message.new.class).to eq Mail::Message
    end

    it "should return a basic email" do
      mail = Mail.new
      mail = Mail.new(mail.to_s)
      expect(Mail::Utilities.blank?(mail.date)).not_to be_truthy
      expect(Mail::Utilities.blank?(mail.message_id)).not_to be_truthy
      expect(mail.mime_version).to eq "1.0"
      expect(mail.content_type).to eq "text/plain"
      expect(mail.content_transfer_encoding).to eq "7bit"
      expect(Mail::Utilities.blank?(mail.subject)).to be_truthy
      expect(Mail::Utilities.blank?(mail.body)).to be_truthy
    end

    it "should instantiate with a string" do
      expect(Mail::Message.new(basic_email).class).to eq Mail::Message
    end

    it "should allow us to pass it a block" do
      mail = Mail::Message.new do
        from 'mikel@me.com'
        to 'lindsaar@you.com'
      end
      expect(mail.from).to eq ['mikel@me.com']
      expect(mail.to).to eq ['lindsaar@you.com']
    end

    it "should yield self if the given block takes any args" do
      class ClassThatCreatesMail
        def initialize(from, to)
          @from = from
          @to = to
        end

        def create_mail_with_one_arg
          Mail::Message.new do |m|
            m.from @from
            m.to @to
          end
        end

        def create_mail_with_splat_args
          Mail::Message.new do |*args|
            m = args.first
            m.from @from
            m.to @to
          end
        end
      end

      mail = ClassThatCreatesMail.new('mikel@me.com', 'lindsaar@you.com').create_mail_with_one_arg
      expect(mail.from).to eq ['mikel@me.com']
      expect(mail.to).to eq ['lindsaar@you.com']

      mail = ClassThatCreatesMail.new('mikel@me.com', 'lindsaar@you.com').create_mail_with_splat_args
      expect(mail.from).to eq ['mikel@me.com']
      expect(mail.to).to eq ['lindsaar@you.com']
    end

    it "should initialize a body and header class even if called with nothing to begin with" do
      mail = Mail::Message.new
      expect(mail.header.class).to eq Mail::Header
      expect(mail.body.class).to eq Mail::Body
    end

    it "should not report basic emails as bounced" do
      expect(Mail::Message.new).not_to be_bounced
    end

    it "should be able to parse a basic email" do
      expect { read_fixture('emails', 'plain_emails', 'basic_email.eml') }.not_to raise_error
    end

    it "should be able to parse a basic email with linefeeds" do
      expect { read_fixture('emails', 'plain_emails', 'basic_email_lf.eml') }.not_to raise_error
    end

    it "should be able to parse an email with @ in display name" do
      message = read_fixture('emails', 'plain_emails', 'raw_email_with_at_display_name.eml')
      expect(message.to).to eq ["smith@gmail.com", "raasdnil@gmail.com", "tom@gmail.com"]
    end

    it "should be able to parse an email with only blank lines as body" do
      expect { read_fixture('emails', 'error_emails', 'missing_body.eml') }.not_to raise_error
    end

    it "should be able to parse an email with a funky date header" do
      # TODO: This spec should actually do something
       expect { read_fixture('emails', 'error_emails', 'bad_date_header2.eml') }
    end

    it 'should be able to invoke subject on a funky subject header' do
      read_fixture('emails', 'error_emails', 'bad_subject.eml').subject
    end

    it 'should use default charset' do
      begin
        Mail::Message.default_charset, old = 'iso-8859-1', Mail::Message.default_charset
        expect(Mail::Message.new.charset).to eq 'iso-8859-1'
      ensure
        Mail::Message.default_charset = old
      end
    end

    it 'should be able to parse an email missing an encoding' do
      read_fixture('emails', 'error_emails', 'must_supply_encoding.eml')
    end

    Dir.glob(fixture_path('emails/**/*.eml')).each do |path|
      it "parses #{path} fixture" do
        allow(Kernel).to receive(:warn) # Don't want to get noisy about any warnings
        expect { Mail.read(path) }.to_not raise_error
      end
    end

    it "should be able to parse a large email without raising an exception" do
      m = Mail.new
      m.add_file(:filename => "attachment.data", :content => "a" * (8 * 1024 * 1024))
      raw_email = "From jamis_buck@byu.edu Mon May  2 16:07:05 2005\r\n#{m.to_s}"

      expect { Mail::Message.new(raw_email) }.not_to raise_error
      expect(Mail::Message.new(raw_email).part[0].header[:filename]).to be_nil
    end

    it "should not raise a warning on having non US-ASCII characters in the header (should just handle it)" do
      expect {
        read_fixture('emails', 'plain_emails', 'raw_email_string_in_date_field.eml')
      }.to_not output.to_stderr
    end

    it "should raise a warning (and keep parsing) on having an incorrectly formatted header" do
      expect(Kernel).to receive(:warn).with('WARNING: Ignoring unparsable header "quite Delivered-To: xxx@xxx.xxx": invalid header name syntax: "quite Delivered-To"').once
      read_fixture('emails', 'plain_emails', 'raw_email_incorrect_header.eml').to_s
    end

    it "should read in an email message and basically parse it" do
      mail = read_fixture('emails', 'plain_emails', 'basic_email.eml')
      expect(mail.to).to eq ["raasdnil@gmail.com"]
    end

    it "should not fail parsing message with caps in content_type" do
      mail = read_fixture('emails', 'plain_emails', 'mix_caps_content_type.eml')
      expect(mail.content_type).to eq 'text/plain; charset=iso-8859-1'
      expect(mail.main_type).to eq 'text'
      expect(mail.sub_type).to eq 'plain'
    end

    it "should be able to pass an empty reply-to header" do
      mail = read_fixture('emails', 'error_emails', 'empty_in_reply_to.eml')
      expect(Mail::Utilities.blank?(mail.in_reply_to)).to be_truthy
    end

    it "should be able to pass two In-Reply-To headers" do
      mail = Mail.new("From: bob\r\nIn-Reply-To: <a@a.a>\r\nIn-Reply-To: <b@b.b>\r\nSubject: Hello!\r\n\r\nemail message\r\n")
      expect(mail.in_reply_to).to eq 'b@b.b'
    end

    it "should be able to pass two References headers" do
      mail = Mail.new("From: bob\r\nReferences: <a@a.a>\r\nReferences: <b@b.b>\r\nSubject: Hello!\r\n\r\nemail message\r\n")
      expect(mail.references).to eq 'b@b.b'
    end

    describe "YAML serialization" do
      before(:each) do
        # Ensure specs don't randomly fail due to messages being generated 1 second apart
        time = DateTime.now
        allow(DateTime).to receive(:now).and_return(time)

        @yaml_mail = Mail::Message.new(:to => 'someone@somewhere.com',
                                  :cc => 'someoneelse@somewhere.com',
                                  :bcc => 'someonesecret@somewhere.com',
                                  :body => 'body',
                                  :subject => 'subject')
        @smtp_settings = { :address=>"smtp.somewhere.net",
          :port=>"587", :domain=>"somewhere.net", :user_name=>"someone@somewhere.net",
          :password=>"password", :authentication=>:plain, :enable_starttls_auto => true,
          :enable_starttls => nil, :openssl_verify_mode => nil, :ssl=>nil, :tls=>nil, :open_timeout=>nil, :read_timeout=>nil }
        @yaml_mail.delivery_method :smtp, @smtp_settings
      end

      it "should serialize the basic information to YAML" do
        yaml = @yaml_mail.to_yaml
        yaml_output = YAML.load(yaml)
        expect(yaml_output['headers']['To']).to       eq "someone@somewhere.com"
        expect(yaml_output['headers']['Cc']).to       eq "someoneelse@somewhere.com"
        expect(yaml_output['headers']['Subject']).to  eq "subject"
        expect(yaml_output['headers']['Bcc']).to      eq "someonesecret@somewhere.com"
        expect(yaml_output['@body_raw']).to           eq "body"
        expect(Mail::Utilities.blank?(yaml_output['@delivery_method'])).not_to be_truthy
      end

      it "should deserialize after serializing" do
        deserialized = Mail::Message.from_yaml(@yaml_mail.to_yaml)
        expect(deserialized).to eq @yaml_mail
        expect(deserialized.delivery_method.settings).to eq @smtp_settings
      end

      it "should serialize a Message with a custom delivery_handler" do
        @yaml_mail.delivery_handler = DeliveryAgent
        yaml = @yaml_mail.to_yaml
        yaml_output = YAML.load(yaml)
        expect(yaml_output['delivery_handler']).to eq "DeliveryAgent"
      end

      it "should load a serialized delivery handler" do
        @yaml_mail.delivery_handler = DeliveryAgent
        deserialized = Mail::Message.from_yaml(@yaml_mail.to_yaml)
        expect(deserialized.delivery_handler).to eq DeliveryAgent
      end

      it "should not deserialize a delivery_handler that does not exist" do
        yaml = @yaml_mail.to_yaml
        yaml_hash = YAML.load(yaml)
        yaml_hash['delivery_handler'] = "NotARealClass"
        deserialized = Mail::Message.from_yaml(yaml_hash.to_yaml)
        expect(deserialized.delivery_handler).to be_nil
      end

      it "should deserialize parts as an instance of Mail::PartsList" do
        yaml = @yaml_mail.to_yaml
        yaml_hash = YAML.load(yaml)
        deserialized = Mail::Message.from_yaml(yaml_hash.to_yaml)
        expect(deserialized.parts).to be_kind_of(Mail::PartsList)
      end

      it "should handle multipart mail" do
        @yaml_mail.add_part Mail::Part.new(:content_type => 'text/html', :body => '<b>body</b>')
        deserialized = Mail::Message.from_yaml(@yaml_mail.to_yaml)
        expect(deserialized).to be_multipart
        deserialized.parts.each {|part| expect(part).to be_a(Mail::Part)}
        expect(deserialized.parts.map(&:body)).to eq(['body', '<b>body</b>'])
      end
    end

    describe "splitting" do
      it "should split the body from the header" do
        message = Mail::Message.new("To: Example <example@cirw.in>\r\n\r\nHello there\r\n")
        expect(message.decoded).to eq("Hello there\n")
      end

      it "should split when the body starts with a space" do
        message = Mail::Message.new("To: Example <example@cirw.in>\r\n\r\n Hello there\r\n")
        expect(message.decoded).to eq(" Hello there\n")
      end

      it "should split if the body starts with an empty line" do
        message = Mail::Message.new("To: Example <example@cirw.in>\r\n\r\n\r\nHello there\r\n")
        expect(message.decoded).to eq("\nHello there\n")
      end

      it "should split if the body starts with a blank line" do
        message = Mail::Message.new("To: Example <example@cirw.in>\r\n\r\n\t\r\nHello there\r\n")
        expect(message.decoded).to eq("\t\nHello there\n")
      end

      it 'should split after headers that contain "\r\n "' do
        message = Mail::Message.new("To: Example\r\n <example@cirw.in>\r\n\r\n Hello there\r\n")
        expect(message.decoded).to eq(" Hello there\n")
      end

      it 'should split only once if there are "\r\n\r\n"s in the body' do
        message = Mail::Message.new("To: Example <example@cirw.in>\r\n\r\nHello\r\n\r\nthere\r\n")
        expect(message.decoded).to eq("Hello\n\nthere\n")
      end

      it "should allow headers that end in trailing whitespace" do
        message = Mail::Message.new("To: Example <example@cirw.in>\r\nThread-Topic: -= MAINTENANCE =- Canasta - Wednesday 4/24/2013 8am - 10am\r\n                                         \r\n\r\nHello there\r\n")
        expect(message.decoded).to eq("Hello there\n")
      end
    end
  end

  describe "envelope line handling" do
    it "should respond to 'envelope from'" do
      expect(Mail::Message.new).to respond_to(:envelope_from)
    end

    it "should strip off the envelope from field if present" do
      message = read_fixture('emails', 'plain_emails', 'raw_email.eml')
      expect(message.envelope_from).to eq "jamis_buck@byu.edu"
      expect(message.envelope_date).to eq ::DateTime.parse("Mon May  2 16:07:05 2005")
    end

    it "should strip off the envelope from field if present" do
      message = read_fixture('emails', 'plain_emails', 'raw_email.eml')
      expect(message.raw_envelope).to eq "jamis_buck@byu.edu Mon May  2 16:07:05 2005"
      expect(message.from).to eq ["jamis@37signals.com"]
    end

    it "should not cause any problems if there is no envelope from present" do
      message = read_fixture('emails', 'plain_emails', 'basic_email.eml')
      expect(message.from).to eq ["test@lindsaar.net"]
    end

    it "should ignore a plain text body that starts with ^From" do
      m = Mail::Message.new("From: mikel@test.lindsaar.net\r\n\r\nThis is a way to break mail by putting\r\nFrom at the start of a body\r\nor elsewhere.")
      expect(m.from).not_to be_nil
      expect(m.from).to eq ['mikel@test.lindsaar.net']
    end

    it "should handle a multipart message that has ^From in it" do
      m = read_fixture('emails', 'error_emails', 'cant_parse_from.eml')
      expect(m.from).not_to be_nil
      expect(m.from).to eq ["News@InsideApple.Apple.com"]
      expect(m).to be_multipart
    end

  end

  describe "accepting a plain text string email" do

    it "should accept some email text to parse and return an email" do
      mail = Mail::Message.new(basic_email)
      expect(mail.class).to eq Mail::Message
    end

    it "should set a raw source instance variable to equal the passed in message" do
      mail = Mail::Message.new(basic_email)
      expect(mail.raw_source).to eq basic_email
    end

    it "should set the raw source instance variable to '' if no message is passed in" do
      mail = Mail::Message.new
      expect(mail.raw_source).to eq ""
    end

    it "should give the header class the header to parse" do
      header = Mail::Header.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
      expect(Mail::Header).to receive(:new).with("To: mikel\r\nFrom: bob\r\nSubject: Hello!", 'UTF-8').and_return(header)
      Mail::Message.new(basic_email)
    end

    it "should give the header class the header to parse even if there is no body" do
      header = Mail::Header.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
      expect(Mail::Header).to receive(:new).with("To: mikel\r\nFrom: bob\r\nSubject: Hello!", 'UTF-8').and_return(header)
      Mail::Message.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
    end

    it "should give the body class the body to parse" do
      body = Mail::Body.new("email message")
      expect(Mail::Body).to receive(:new).with("email message\r\n").and_return(body)
      mail = Mail::Message.new(basic_email)
      mail.body #body calculates now lazy so need to ask for it
    end

    it "should still ask the body for a new instance even though these is nothing to parse, yet" do
      body = Mail::Body.new('')
      expect(Mail::Body).to receive(:new).and_return(body)
      Mail::Message.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
    end

    it "should give the header the part before the line without spaces and the body the part without" do
      header = Mail::Header.new("To: mikel")
      body = Mail::Body.new("G'Day!")
      expect(Mail::Header).to receive(:new).with("To: mikel", 'UTF-8').and_return(header)
      expect(Mail::Body).to receive(:new).with("G'Day!").and_return(body)
      mail = Mail::Message.new("To: mikel\r\n\r\nG'Day!")
      mail.body #body calculates now lazy so need to ask for it
    end

    it "should allow for whitespace at the start of the email" do
      mail = Mail.new("\r\n\r\nFrom: mikel\r\n\r\nThis is the body")
      expect(mail.body.to_s).to eq 'This is the body'
      expect(mail.from).to eq ['mikel']
    end

    it "should read in an email message with the word 'From' in it multiple times and parse it" do
      mail = read_fixture('emails', 'mime_emails', 'two_from_in_message.eml')
      expect(mail.to).not_to be_nil
      expect(mail.to).to eq ["tester2@test.com"]
    end

    it "should parse non-UTF8 sources" do
      raw_message = read_raw_fixture('emails', 'multi_charset', 'japanese_iso_2022.eml')
      original_encoding = raw_message.encoding if raw_message.respond_to?(:encoding)
      mail = Mail.new(raw_message)
      expect(mail.to).to eq ["raasdnil@gmail.com"]
      expect(mail.decoded).to eq "すみません。\n\n"
      expect(raw_message.encoding).to eq original_encoding if raw_message.respond_to?(:encoding)
    end

    it "should parse sources with charsets that we know but Ruby doesn't" do
      raw_message = read_raw_fixture('emails', 'multi_charset', 'ks_c_5601-1987.eml')
      original_encoding = raw_message.encoding if raw_message.respond_to?(:encoding)
      mail = Mail.new(raw_message)
      expect(mail.decoded.chomp).to eq "스티해"
      expect(raw_message.encoding).to eq original_encoding if raw_message.respond_to?(:encoding)
    end

    if '1.9+'.respond_to?(:encoding)
      it "should be able to normalize CRLFs on non-UTF8 encodings" do
        File.open(fixture_path('emails', 'multi_charset', 'japanese_shift_jis.eml'), 'rb') do |io|
          mail = Mail.new(io.read)
          expect(mail.raw_source.encoding).to eq Encoding::BINARY
        end
      end
    end

    if '1.9+'.respond_to?(:encoding)
      it "should be able to normalize CRLFs on non-UTF8 encodings" do
        File.open(fixture_path('emails', 'multi_charset', 'japanese_shift_jis.eml'), 'rb') do |io|
          mail = Mail.new(io.read)
          expect(mail.raw_source.encoding).to eq Encoding::BINARY
        end
      end
    end
  end

  describe "directly setting values of a message" do

    describe "accessing fields directly" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should allow you to grab field objects if you really want to" do
        expect(@mail.header_fields.class).to eq Mail::FieldList
      end

      it "should give you back the fields in the header" do
        @mail['bar'] = 'abcd'
        expect(@mail.header_fields.length).to eq 1
        @mail['foo'] = '4321'
        expect(@mail.header_fields.length).to eq 2
      end

      it "should delete a field if it is set to nil" do
        @mail['foo'] = '4321'
        expect(@mail.header_fields.length).to eq 1
        @mail['foo'] = nil
        expect(@mail.header_fields.length).to eq 0
      end

    end

    describe "with :method=" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should return the to field" do
        @mail.to = "mikel"
        expect(@mail.to).to eq ["mikel"]
      end

      it "should return the from field" do
        @mail.from = "bob"
        expect(@mail.from).to eq ["bob"]
      end

      it "should return the subject" do
        @mail.subject = "Hello!"
        expect(@mail.subject).to eq "Hello!"
      end

      it "should return the body decoded with to_s" do
        @mail.body "email message\r\n"
        expect(@mail.body.to_s).to eq "email message\n"
      end

      it "should return the body encoded if asked for" do
        @mail.body "email message\r\n"
        expect(@mail.body.encoded).to eq "email message\r\n"
      end

      it "should return the body decoded if asked for" do
        @mail.body "email message\r\n"
        expect(@mail.body.decoded).to eq "email message\n"
      end
    end

    describe "with :method(value)" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should return the to field" do
        @mail.to "mikel"
        expect(@mail.to).to eq ["mikel"]
      end

      it "should return the from field" do
        @mail.from "bob"
        expect(@mail.from).to eq ["bob"]
      end

      it "should return the subject" do
        @mail.subject "Hello!"
        expect(@mail.subject).to eq "Hello!"
      end

      it "should return the body decoded with to_s" do
        @mail.body "email message\r\n"
        expect(@mail.body.to_s).to eq "email message\n"
      end

      it "should return the body encoded if asked for" do
        @mail.body "email message\r\n"
        expect(@mail.body.encoded).to eq "email message\r\n"
      end

      it "should return the body decoded if asked for" do
        @mail.body "email message\r\n"
        expect(@mail.body.decoded).to eq "email message\n"
      end
    end

    describe "setting arbitrary headers" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should allow you to set them" do
        expect {@mail['foo'] = 1234}.not_to raise_error
      end

      it "should allow you to read arbitrary headers" do
        @mail['foo'] = 1234
        expect(@mail['foo'].value.to_s).to eq '1234'
      end

      it "should instantiate a new Header" do
        @mail['foo'] = 1234
        expect(@mail.header_fields.first.class).to eq Mail::Field
      end
    end

    describe "replacing header values" do

      it "should allow you to replace a from field" do
        mail = Mail.new
        expect(mail.from).to be_nil
        mail.from = 'mikel@test.lindsaar.net'
        expect(mail.from).to eq ['mikel@test.lindsaar.net']
        mail.from = 'bob@test.lindsaar.net'
        expect(mail.from).to eq ['bob@test.lindsaar.net']
      end

      it "should maintain the class of the field" do
        mail = Mail.new
        mail.from = 'mikel@test.lindsaar.net'
        expect(mail[:from].field.class).to eq Mail::FromField
        mail.from = 'bob@test.lindsaar.net'
        expect(mail[:from].field.class).to eq Mail::FromField
      end
    end

    describe "setting headers" do

      it "should accept them in block form" do
        message = Mail.new do
          bcc           'mikel@bcc.lindsaar.net'
          cc            'mikel@cc.lindsaar.net'
          comments      'this is a comment'
          date          '12 Aug 2009 00:00:01 GMT'
          from          'mikel@from.lindsaar.net'
          in_reply_to   '<1234@in_reply_to.lindsaar.net>'
          keywords      'test, "of the new mail", system'
          message_id    '<1234@message_id.lindsaar.net>'
          received      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT'
          references    '<1234@references.lindsaar.net>'
          reply_to      'mikel@reply-to.lindsaar.net'
          resent_bcc    'mikel@resent-bcc.lindsaar.net'
          resent_cc     'mikel@resent-cc.lindsaar.net'
          resent_date   '12 Aug 2009 00:00:03 GMT'
          resent_from   'mikel@resent-from.lindsaar.net'
          resent_message_id '<1234@resent_message_id.lindsaar.net>'
          resent_sender 'mikel@resent-sender.lindsaar.net'
          resent_to     'mikel@resent-to.lindsaar.net'
          sender        'mikel@sender.lindsaar.net'
          subject       'Hello there Mikel'
          to            'mikel@to.lindsaar.net'
          content_type  'text/plain; charset=UTF-8'
          content_transfer_encoding '7bit'
          content_description       'This is a test'
          content_disposition       'attachment; filename=File'
          content_id                '<1234@message_id.lindsaar.net>'
          mime_version  '1.0'
          body          'This is a body of text'
        end

        expect(message.bcc).to           eq ['mikel@bcc.lindsaar.net']
        expect(message.cc).to            eq ['mikel@cc.lindsaar.net']
        expect(message.comments).to      eq 'this is a comment'
        expect(message.date).to          eq DateTime.parse('12 Aug 2009 00:00:01 GMT')
        expect(message.from).to          eq ['mikel@from.lindsaar.net']
        expect(message.in_reply_to).to   eq '1234@in_reply_to.lindsaar.net'
        expect(message.keywords).to      eq ["test", "of the new mail", "system"]
        expect(message.message_id).to    eq '1234@message_id.lindsaar.net'
        expect(message.received.date_time).to      eq DateTime.parse('12 Aug 2009 00:00:02 GMT')
        expect(message.references).to    eq '1234@references.lindsaar.net'
        expect(message.reply_to).to      eq ['mikel@reply-to.lindsaar.net']
        expect(message.resent_bcc).to    eq ['mikel@resent-bcc.lindsaar.net']
        expect(message.resent_cc).to     eq ['mikel@resent-cc.lindsaar.net']
        expect(message.resent_date).to   eq DateTime.parse('12 Aug 2009 00:00:03 GMT')
        expect(message.resent_from).to   eq ['mikel@resent-from.lindsaar.net']
        expect(message.resent_message_id).to eq '1234@resent_message_id.lindsaar.net'
        expect(message.resent_sender).to eq ['mikel@resent-sender.lindsaar.net']
        expect(message.resent_to).to     eq ['mikel@resent-to.lindsaar.net']
        expect(message.sender).to        eq 'mikel@sender.lindsaar.net'
        expect(message.subject).to       eq 'Hello there Mikel'
        expect(message.to).to            eq ['mikel@to.lindsaar.net']
        expect(message.content_type).to              eq 'text/plain; charset=UTF-8'
        expect(message.content_transfer_encoding).to eq '7bit'
        expect(message.content_description).to       eq 'This is a test'
        expect(message.content_disposition).to       eq 'attachment; filename=File'
        expect(message.content_id).to                eq '<1234@message_id.lindsaar.net>'
        expect(message.mime_version).to              eq '1.0'
        expect(message.body.to_s).to          eq 'This is a body of text'
      end

      it "should accept them in assignment form" do
        message = Mail.new
        message.bcc =           'mikel@bcc.lindsaar.net'
        message.cc =            'mikel@cc.lindsaar.net'
        message.comments =      'this is a comment'
        message.date =          '12 Aug 2009 00:00:01 GMT'
        message.from =          'mikel@from.lindsaar.net'
        message.in_reply_to =   '<1234@in_reply_to.lindsaar.net>'
        message.keywords =      'test, "of the new mail", system'
        message.message_id =    '<1234@message_id.lindsaar.net>'
        message.received =      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT'
        message.references =    '<1234@references.lindsaar.net>'
        message.reply_to =      'mikel@reply-to.lindsaar.net'
        message.resent_bcc =    'mikel@resent-bcc.lindsaar.net'
        message.resent_cc =     'mikel@resent-cc.lindsaar.net'
        message.resent_date =   '12 Aug 2009 00:00:03 GMT'
        message.resent_from =   'mikel@resent-from.lindsaar.net'
        message.resent_message_id = '<1234@resent_message_id.lindsaar.net>'
        message.resent_sender = 'mikel@resent-sender.lindsaar.net'
        message.resent_to =     'mikel@resent-to.lindsaar.net'
        message.sender =        'mikel@sender.lindsaar.net'
        message.subject =       'Hello there Mikel'
        message.to =            'mikel@to.lindsaar.net'
        message.content_type =  'text/plain; charset=UTF-8'
        message.content_transfer_encoding = '7bit'
        message.content_description =       'This is a test'
        message.content_disposition =       'attachment; filename=File'
        message.content_id =                '<1234@message_id.lindsaar.net>'
        message.mime_version =  '1.0'
        message.body =          'This is a body of text'

        expect(message.bcc).to           eq ['mikel@bcc.lindsaar.net']
        expect(message.cc).to            eq ['mikel@cc.lindsaar.net']
        expect(message.comments).to      eq 'this is a comment'
        expect(message.date).to          eq DateTime.parse('12 Aug 2009 00:00:01 GMT')
        expect(message.from).to          eq ['mikel@from.lindsaar.net']
        expect(message.in_reply_to).to   eq '1234@in_reply_to.lindsaar.net'
        expect(message.keywords).to      eq ["test", "of the new mail", "system"]
        expect(message.message_id).to    eq '1234@message_id.lindsaar.net'
        expect(message.received.date_time).to      eq DateTime.parse('12 Aug 2009 00:00:02 GMT')
        expect(message.references).to    eq '1234@references.lindsaar.net'
        expect(message.reply_to).to      eq ['mikel@reply-to.lindsaar.net']
        expect(message.resent_bcc).to    eq ['mikel@resent-bcc.lindsaar.net']
        expect(message.resent_cc).to     eq ['mikel@resent-cc.lindsaar.net']
        expect(message.resent_date).to   eq DateTime.parse('12 Aug 2009 00:00:03 GMT')
        expect(message.resent_from).to   eq ['mikel@resent-from.lindsaar.net']
        expect(message.resent_message_id).to eq '1234@resent_message_id.lindsaar.net'
        expect(message.resent_sender).to eq ['mikel@resent-sender.lindsaar.net']
        expect(message.resent_to).to     eq ['mikel@resent-to.lindsaar.net']
        expect(message.sender).to        eq 'mikel@sender.lindsaar.net'
        expect(message.subject).to       eq 'Hello there Mikel'
        expect(message.to).to            eq ['mikel@to.lindsaar.net']
        expect(message.content_type).to              eq 'text/plain; charset=UTF-8'
        expect(message.content_transfer_encoding).to eq '7bit'
        expect(message.content_description).to       eq 'This is a test'
        expect(message.content_disposition).to       eq 'attachment; filename=File'
        expect(message.content_id).to                eq '<1234@message_id.lindsaar.net>'
        expect(message.mime_version).to              eq '1.0'
        expect(message.body.to_s).to          eq 'This is a body of text'
      end

      it "should accept them in key, value form as symbols" do
        message = Mail.new
        message[:bcc] =           'mikel@bcc.lindsaar.net'
        message[:cc] =            'mikel@cc.lindsaar.net'
        message[:comments] =      'this is a comment'
        message[:date] =          '12 Aug 2009 00:00:01 GMT'
        message[:from] =          'mikel@from.lindsaar.net'
        message[:in_reply_to] =   '<1234@in_reply_to.lindsaar.net>'
        message[:keywords] =      'test, "of the new mail", system'
        message[:message_id] =    '<1234@message_id.lindsaar.net>'
        message[:received] =      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT'
        message[:references] =    '<1234@references.lindsaar.net>'
        message[:reply_to] =      'mikel@reply-to.lindsaar.net'
        message[:resent_bcc] =    'mikel@resent-bcc.lindsaar.net'
        message[:resent_cc] =     'mikel@resent-cc.lindsaar.net'
        message[:resent_date] =   '12 Aug 2009 00:00:03 GMT'
        message[:resent_from] =   'mikel@resent-from.lindsaar.net'
        message[:resent_message_id] = '<1234@resent_message_id.lindsaar.net>'
        message[:resent_sender] = 'mikel@resent-sender.lindsaar.net'
        message[:resent_to] =     'mikel@resent-to.lindsaar.net'
        message[:sender] =        'mikel@sender.lindsaar.net'
        message[:subject] =       'Hello there Mikel'
        message[:to] =            'mikel@to.lindsaar.net'
        message[:content_type] =  'text/plain; charset=UTF-8'
        message[:content_transfer_encoding] = '7bit'
        message[:content_description] =       'This is a test'
        message[:content_disposition] =       'attachment; filename=File'
        message[:content_id] =                '<1234@message_id.lindsaar.net>'
        message[:mime_version]=  '1.0'
        message[:body] =          'This is a body of text'

        expect(message.bcc).to           eq ['mikel@bcc.lindsaar.net']
        expect(message.cc).to            eq ['mikel@cc.lindsaar.net']
        expect(message.comments).to      eq 'this is a comment'
        expect(message.date).to          eq DateTime.parse('12 Aug 2009 00:00:01 GMT')
        expect(message.from).to          eq ['mikel@from.lindsaar.net']
        expect(message.in_reply_to).to   eq '1234@in_reply_to.lindsaar.net'
        expect(message.keywords).to      eq ["test", "of the new mail", "system"]
        expect(message.message_id).to    eq '1234@message_id.lindsaar.net'
        expect(message.received.date_time).to      eq DateTime.parse('12 Aug 2009 00:00:02 GMT')
        expect(message.references).to    eq '1234@references.lindsaar.net'
        expect(message.reply_to).to      eq ['mikel@reply-to.lindsaar.net']
        expect(message.resent_bcc).to    eq ['mikel@resent-bcc.lindsaar.net']
        expect(message.resent_cc).to     eq ['mikel@resent-cc.lindsaar.net']
        expect(message.resent_date).to   eq DateTime.parse('12 Aug 2009 00:00:03 GMT')
        expect(message.resent_from).to   eq ['mikel@resent-from.lindsaar.net']
        expect(message.resent_message_id).to eq '1234@resent_message_id.lindsaar.net'
        expect(message.resent_sender).to eq ['mikel@resent-sender.lindsaar.net']
        expect(message.resent_to).to     eq ['mikel@resent-to.lindsaar.net']
        expect(message.sender).to        eq 'mikel@sender.lindsaar.net'
        expect(message.subject).to       eq 'Hello there Mikel'
        expect(message.to).to            eq ['mikel@to.lindsaar.net']
        expect(message.content_type).to              eq 'text/plain; charset=UTF-8'
        expect(message.content_transfer_encoding).to eq '7bit'
        expect(message.content_description).to       eq 'This is a test'
        expect(message.content_disposition).to       eq 'attachment; filename=File'
        expect(message.content_id).to                eq '<1234@message_id.lindsaar.net>'
        expect(message.mime_version).to              eq '1.0'
        expect(message.body.to_s).to          eq 'This is a body of text'
      end

      it "should accept them in key, value form as strings" do
        message = Mail.new
        message['bcc'] =           'mikel@bcc.lindsaar.net'
        message['cc'] =            'mikel@cc.lindsaar.net'
        message['comments'] =      'this is a comment'
        message['date'] =          '12 Aug 2009 00:00:01 GMT'
        message['from'] =          'mikel@from.lindsaar.net'
        message['in_reply_to'] =   '<1234@in_reply_to.lindsaar.net>'
        message['keywords'] =      'test, "of the new mail", system'
        message['message_id'] =    '<1234@message_id.lindsaar.net>'
        message['received'] =      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT'
        message['references'] =    '<1234@references.lindsaar.net>'
        message['reply_to'] =      'mikel@reply-to.lindsaar.net'
        message['resent_bcc'] =    'mikel@resent-bcc.lindsaar.net'
        message['resent_cc'] =     'mikel@resent-cc.lindsaar.net'
        message['resent_date'] =   '12 Aug 2009 00:00:03 GMT'
        message['resent_from'] =   'mikel@resent-from.lindsaar.net'
        message['resent_message_id'] = '<1234@resent_message_id.lindsaar.net>'
        message['resent_sender'] = 'mikel@resent-sender.lindsaar.net'
        message['resent_to'] =     'mikel@resent-to.lindsaar.net'
        message['sender'] =        'mikel@sender.lindsaar.net'
        message['subject'] =       'Hello there Mikel'
        message['to'] =            'mikel@to.lindsaar.net'
        message['content_type'] =  'text/plain; charset=UTF-8'
        message['content_transfer_encoding'] = '7bit'
        message['content_description'] =       'This is a test'
        message['content_disposition'] =       'attachment; filename=File'
        message['content_id'] =                '<1234@message_id.lindsaar.net>'
        message['mime_version'] =  '1.0'
        message['body'] =          'This is a body of text'

        expect(message.bcc).to           eq ['mikel@bcc.lindsaar.net']
        expect(message.cc).to            eq ['mikel@cc.lindsaar.net']
        expect(message.comments).to      eq 'this is a comment'
        expect(message.date).to          eq DateTime.parse('12 Aug 2009 00:00:01 GMT')
        expect(message.from).to          eq ['mikel@from.lindsaar.net']
        expect(message.in_reply_to).to   eq '1234@in_reply_to.lindsaar.net'
        expect(message.keywords).to      eq ["test", "of the new mail", "system"]
        expect(message.message_id).to    eq '1234@message_id.lindsaar.net'
        expect(message.received.date_time).to      eq DateTime.parse('12 Aug 2009 00:00:02 GMT')
        expect(message.references).to    eq '1234@references.lindsaar.net'
        expect(message.reply_to).to      eq ['mikel@reply-to.lindsaar.net']
        expect(message.resent_bcc).to    eq ['mikel@resent-bcc.lindsaar.net']
        expect(message.resent_cc).to     eq ['mikel@resent-cc.lindsaar.net']
        expect(message.resent_date).to   eq DateTime.parse('12 Aug 2009 00:00:03 GMT')
        expect(message.resent_from).to   eq ['mikel@resent-from.lindsaar.net']
        expect(message.resent_message_id).to eq '1234@resent_message_id.lindsaar.net'
        expect(message.resent_sender).to eq ['mikel@resent-sender.lindsaar.net']
        expect(message.resent_to).to     eq ['mikel@resent-to.lindsaar.net']
        expect(message.sender).to        eq 'mikel@sender.lindsaar.net'
        expect(message.subject).to       eq 'Hello there Mikel'
        expect(message.to).to            eq ['mikel@to.lindsaar.net']
        expect(message.content_type).to              eq 'text/plain; charset=UTF-8'
        expect(message.content_transfer_encoding).to eq '7bit'
        expect(message.content_description).to       eq 'This is a test'
        expect(message.content_disposition).to       eq 'attachment; filename=File'
        expect(message.content_id).to                eq '<1234@message_id.lindsaar.net>'
        expect(message.mime_version).to              eq '1.0'
        expect(message.body.to_s).to          eq 'This is a body of text'
      end

      it "should accept them as a hash with symbols" do
        message = Mail.new({
          :bcc =>           'mikel@bcc.lindsaar.net',
          :cc =>            'mikel@cc.lindsaar.net',
          :comments =>      'this is a comment',
          :date =>          '12 Aug 2009 00:00:01 GMT',
          :from =>          'mikel@from.lindsaar.net',
          :in_reply_to =>   '<1234@in_reply_to.lindsaar.net>',
          :keywords =>      'test, "of the new mail", system',
          :message_id =>    '<1234@message_id.lindsaar.net>',
          :received =>      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT',
          :references =>    '<1234@references.lindsaar.net>',
          :reply_to =>      'mikel@reply-to.lindsaar.net',
          :resent_bcc =>    'mikel@resent-bcc.lindsaar.net',
          :resent_cc =>     'mikel@resent-cc.lindsaar.net',
          :resent_date =>   '12 Aug 2009 00:00:03 GMT',
          :resent_from =>   'mikel@resent-from.lindsaar.net',
          :resent_message_id => '<1234@resent_message_id.lindsaar.net>',
          :resent_sender => 'mikel@resent-sender.lindsaar.net',
          :resent_to =>     'mikel@resent-to.lindsaar.net',
          :sender =>        'mikel@sender.lindsaar.net',
          :subject =>       'Hello there Mikel',
          :to =>            'mikel@to.lindsaar.net',
          :content_type =>  'text/plain; charset=UTF-8',
          :content_transfer_encoding => '7bit',
          :content_description =>       'This is a test',
          :content_disposition =>       'attachment; filename=File',
          :content_id =>                '<1234@message_id.lindsaar.net>',
          :mime_version =>  '1.0',
          :body =>          'This is a body of text'
        })

        expect(message.bcc).to           eq ['mikel@bcc.lindsaar.net']
        expect(message.cc).to            eq ['mikel@cc.lindsaar.net']
        expect(message.comments).to      eq 'this is a comment'
        expect(message.date).to          eq DateTime.parse('12 Aug 2009 00:00:01 GMT')
        expect(message.from).to          eq ['mikel@from.lindsaar.net']
        expect(message.in_reply_to).to   eq '1234@in_reply_to.lindsaar.net'
        expect(message.keywords).to      eq ["test", "of the new mail", "system"]
        expect(message.message_id).to    eq '1234@message_id.lindsaar.net'
        expect(message.received.date_time).to      eq DateTime.parse('12 Aug 2009 00:00:02 GMT')
        expect(message.references).to    eq '1234@references.lindsaar.net'
        expect(message.reply_to).to      eq ['mikel@reply-to.lindsaar.net']
        expect(message.resent_bcc).to    eq ['mikel@resent-bcc.lindsaar.net']
        expect(message.resent_cc).to     eq ['mikel@resent-cc.lindsaar.net']
        expect(message.resent_date).to   eq DateTime.parse('12 Aug 2009 00:00:03 GMT')
        expect(message.resent_from).to   eq ['mikel@resent-from.lindsaar.net']
        expect(message.resent_message_id).to eq '1234@resent_message_id.lindsaar.net'
        expect(message.resent_sender).to eq ['mikel@resent-sender.lindsaar.net']
        expect(message.resent_to).to     eq ['mikel@resent-to.lindsaar.net']
        expect(message.sender).to        eq 'mikel@sender.lindsaar.net'
        expect(message.subject).to       eq 'Hello there Mikel'
        expect(message.to).to            eq ['mikel@to.lindsaar.net']
        expect(message.content_type).to              eq 'text/plain; charset=UTF-8'
        expect(message.content_transfer_encoding).to eq '7bit'
        expect(message.content_description).to       eq 'This is a test'
        expect(message.content_disposition).to       eq 'attachment; filename=File'
        expect(message.content_id).to                eq '<1234@message_id.lindsaar.net>'
        expect(message.mime_version).to              eq '1.0'
        expect(message.body.to_s).to          eq 'This is a body of text'
      end

      it "should accept them as a hash with strings" do
        message = Mail.new({
          'bcc' =>           'mikel@bcc.lindsaar.net',
          'cc' =>            'mikel@cc.lindsaar.net',
          'comments' =>      'this is a comment',
          'date' =>          '12 Aug 2009 00:00:01 GMT',
          'from' =>          'mikel@from.lindsaar.net',
          'in_reply_to' =>   '<1234@in_reply_to.lindsaar.net>',
          'keywords' =>      'test, "of the new mail", system',
          'message_id' =>    '<1234@message_id.lindsaar.net>',
          'received' =>      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT',
          'references' =>    '<1234@references.lindsaar.net>',
          'reply_to' =>      'mikel@reply-to.lindsaar.net',
          'resent_bcc' =>    'mikel@resent-bcc.lindsaar.net',
          'resent_cc' =>     'mikel@resent-cc.lindsaar.net',
          'resent_date' =>   '12 Aug 2009 00:00:03 GMT',
          'resent_from' =>   'mikel@resent-from.lindsaar.net',
          'resent_message_id' => '<1234@resent_message_id.lindsaar.net>',
          'resent_sender' => 'mikel@resent-sender.lindsaar.net',
          'resent_to' =>     'mikel@resent-to.lindsaar.net',
          'sender' =>        'mikel@sender.lindsaar.net',
          'subject' =>       'Hello there Mikel',
          'to' =>            'mikel@to.lindsaar.net',
          'content_type' =>  'text/plain; charset=UTF-8',
          'content_transfer_encoding' => '7bit',
          'content_description' =>       'This is a test',
          'content_disposition' =>       'attachment; filename=File',
          'content_id' =>                '<1234@message_id.lindsaar.net>',
          'mime_version' =>  '1.0',
          'body' =>          'This is a body of text'
        })

        expect(message.bcc).to           eq ['mikel@bcc.lindsaar.net']
        expect(message.cc).to            eq ['mikel@cc.lindsaar.net']
        expect(message.comments).to      eq 'this is a comment'
        expect(message.date).to          eq DateTime.parse('12 Aug 2009 00:00:01 GMT')
        expect(message.from).to          eq ['mikel@from.lindsaar.net']
        expect(message.in_reply_to).to   eq '1234@in_reply_to.lindsaar.net'
        expect(message.keywords).to      eq ["test", "of the new mail", "system"]
        expect(message.message_id).to    eq '1234@message_id.lindsaar.net'
        expect(message.received.date_time).to      eq DateTime.parse('12 Aug 2009 00:00:02 GMT')
        expect(message.references).to    eq '1234@references.lindsaar.net'
        expect(message.reply_to).to      eq ['mikel@reply-to.lindsaar.net']
        expect(message.resent_bcc).to    eq ['mikel@resent-bcc.lindsaar.net']
        expect(message.resent_cc).to     eq ['mikel@resent-cc.lindsaar.net']
        expect(message.resent_date).to   eq DateTime.parse('12 Aug 2009 00:00:03 GMT')
        expect(message.resent_from).to   eq ['mikel@resent-from.lindsaar.net']
        expect(message.resent_message_id).to eq '1234@resent_message_id.lindsaar.net'
        expect(message.resent_sender).to eq ['mikel@resent-sender.lindsaar.net']
        expect(message.resent_to).to     eq ['mikel@resent-to.lindsaar.net']
        expect(message.sender).to        eq 'mikel@sender.lindsaar.net'
        expect(message.subject).to       eq 'Hello there Mikel'
        expect(message.to).to            eq ['mikel@to.lindsaar.net']
        expect(message.content_type).to              eq 'text/plain; charset=UTF-8'
        expect(message.content_transfer_encoding).to eq '7bit'
        expect(message.content_description).to       eq 'This is a test'
        expect(message.content_disposition).to       eq 'attachment; filename=File'
        expect(message.content_id).to                eq '<1234@message_id.lindsaar.net>'
        expect(message.mime_version).to              eq '1.0'
        expect(message.body.to_s).to          eq 'This is a body of text'
      end

      it "should let you set custom headers with a :headers => {hash}" do
        message = Mail.new(:headers => {'custom-header' => 'mikel'})
        expect(message['custom-header'].decoded).to eq 'mikel'
      end

      it "should assign the body to a part on creation" do
        message = Mail.new do
          part({:content_type=>"multipart/alternative", :content_disposition=>"inline", :body=>"Nothing to see here."})
        end
        expect(message.parts.first.body.decoded).to eq "Nothing to see here."
      end

      it "should not overwrite bodies on creation" do
        message = Mail.new do
          part({:content_type=>"multipart/alternative", :content_disposition=>"inline", :body=>"Nothing to see here."}) do |p|
            p.part :content_type => "text/html", :body => "<b>test</b> HTML<br/>"
          end
        end
        expect(message.parts.first.parts[0].body.decoded).to eq "Nothing to see here."
        expect(message.parts.first.parts[1].body.decoded).to eq "<b>test</b> HTML<br/>"
        expect(message.encoded).to match %r{Nothing to see here\.}
        expect(message.encoded).to match %r{<b>test</b> HTML<br/>}
      end

      it "should allow you to init on an array of addresses from a hash" do
        mail = Mail.new(:to => ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>'])
        expect(mail.to).to eq ['test1@lindsaar.net', 'test2@lindsaar.net']
      end

      it "should allow you to init on an array of addresses directly" do
        mail = Mail.new
        mail.to = ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>']
        expect(mail.to).to eq ['test1@lindsaar.net', 'test2@lindsaar.net']
      end

      it "should allow you to init on an array of addresses directly" do
        mail = Mail.new
        mail[:to] = ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>']
        expect(mail.to).to eq ['test1@lindsaar.net', 'test2@lindsaar.net']
      end

    end

  end

  describe "making a copy of a message with dup" do
    def message_should_have_default_values(message)
      expect(message.bcc).to           be_nil
      expect(message.cc).to            be_nil
      expect(message.comments).to      be_nil
      expect(message.date).to          be_nil
      expect(message.from).to          be_nil
      expect(message.in_reply_to).to   be_nil
      expect(message.keywords).to      be_nil
      expect(message.message_id).to    be_nil
      expect(message.received).to      be_nil
      expect(message.references).to    be_nil
      expect(message.reply_to).to      be_nil
      expect(message.resent_bcc).to    be_nil
      expect(message.resent_cc).to     be_nil
      expect(message.resent_date).to   be_nil
      expect(message.resent_from).to   be_nil
      expect(message.resent_message_id).to be_nil
      expect(message.resent_sender).to be_nil
      expect(message.resent_to).to     be_nil
      expect(message.sender).to        be_nil
      expect(message.subject).to       be_nil
      expect(message.to).to            be_nil
      expect(message.content_type).to              be_nil
      expect(message.content_transfer_encoding).to be_nil
      expect(message.content_description).to       be_nil
      expect(message.content_disposition).to       be_nil
      expect(message.content_id).to                be_nil
      expect(message.mime_version).to              be_nil
      expect(message.body.to_s).to          eq ''
    end

    it "its headers should not be changed when you change the headers of the original" do
      message = Mail.new
      message_copy = message.dup
      message_should_have_default_values message
      message_should_have_default_values message_copy

      message[:bcc] =           'mikel@bcc.lindsaar.net'
      message[:cc] =            'mikel@cc.lindsaar.net'
      message[:comments] =      'this is a comment'
      message[:date] =          '12 Aug 2009 00:00:01 GMT'
      message[:from] =          'mikel@from.lindsaar.net'
      message[:in_reply_to] =   '<1234@in_reply_to.lindsaar.net>'
      message[:keywords] =      'test, "of the new mail", system'
      message[:message_id] =    '<1234@message_id.lindsaar.net>'
      message[:received] =      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT'
      message[:references] =    '<1234@references.lindsaar.net>'
      message[:reply_to] =      'mikel@reply-to.lindsaar.net'
      message[:resent_bcc] =    'mikel@resent-bcc.lindsaar.net'
      message[:resent_cc] =     'mikel@resent-cc.lindsaar.net'
      message[:resent_date] =   '12 Aug 2009 00:00:03 GMT'
      message[:resent_from] =   'mikel@resent-from.lindsaar.net'
      message[:resent_message_id] = '<1234@resent_message_id.lindsaar.net>'
      message[:resent_sender] = 'mikel@resent-sender.lindsaar.net'
      message[:resent_to] =     'mikel@resent-to.lindsaar.net'
      message[:sender] =        'mikel@sender.lindsaar.net'
      message[:subject] =       'Hello there Mikel'
      message[:to] =            'mikel@to.lindsaar.net'
      message[:content_type] =  'text/plain; charset=UTF-8'
      message[:content_transfer_encoding] = '7bit'
      message[:content_description] =       'This is a test'
      message[:content_disposition] =       'attachment; filename=File'
      message[:content_id] =                '<1234@message_id.lindsaar.net>'
      message[:mime_version]=  '1.0'
      message[:body] =          'This is a body of text'

      message_should_have_default_values message_copy
    end

    def message_headers_should_match(message, other)
      expect(message.bcc).to           eq other.bcc
      expect(message.cc).to            eq other.cc
      expect(message.comments).to      eq other.comments
      expect(message.date).to          eq other.date
      expect(message.from).to          eq other.from
      expect(message.in_reply_to).to   eq other.in_reply_to
      expect(message.keywords).to      eq other.keywords
      expect(message.message_id).to    eq other.message_id
      expect(message.received).to      eq other.received
      expect(message.references).to    eq other.references
      expect(message.reply_to).to      eq other.reply_to
      expect(message.resent_bcc).to    eq other.resent_bcc
      expect(message.resent_cc).to     eq other.resent_cc
      expect(message.resent_date).to   eq other.resent_date
      expect(message.resent_from).to   eq other.resent_from
      expect(message.resent_message_id).to eq other.resent_message_id
      expect(message.resent_sender).to eq other.resent_sender
      expect(message.resent_to).to     eq other.resent_to
      expect(message.sender).to        eq other.sender
      expect(message.subject).to       eq other.subject
      expect(message.to).to            eq other.to
      expect(message.content_type).to              eq other.content_type
      expect(message.content_transfer_encoding).to eq other.content_transfer_encoding
      expect(message.content_description).to       eq other.content_description
      expect(message.content_disposition).to       eq other.content_disposition
      expect(message.content_id).to                eq other.content_id
      expect(message.mime_version).to              eq other.mime_version
      expect(message.body.to_s).to          eq other.body.to_s
    end

    it "its headers should be copies of the headers of the original" do
      message = Mail.new
      message[:bcc] =           'mikel@bcc.lindsaar.net'
      message[:cc] =            'mikel@cc.lindsaar.net'
      message[:comments] =      'this is a comment'
      message[:date] =          '12 Aug 2009 00:00:01 GMT'
      message[:from] =          'mikel@from.lindsaar.net'
      message[:in_reply_to] =   '<1234@in_reply_to.lindsaar.net>'
      message[:keywords] =      'test, "of the new mail", system'
      message[:message_id] =    '<1234@message_id.lindsaar.net>'
      message[:received] =      'from machine.example by x.y.test; 12 Aug 2009 00:00:02 GMT'
      message[:references] =    '<1234@references.lindsaar.net>'
      message[:reply_to] =      'mikel@reply-to.lindsaar.net'
      message[:resent_bcc] =    'mikel@resent-bcc.lindsaar.net'
      message[:resent_cc] =     'mikel@resent-cc.lindsaar.net'
      message[:resent_date] =   '12 Aug 2009 00:00:03 GMT'
      message[:resent_from] =   'mikel@resent-from.lindsaar.net'
      message[:resent_message_id] = '<1234@resent_message_id.lindsaar.net>'
      message[:resent_sender] = 'mikel@resent-sender.lindsaar.net'
      message[:resent_to] =     'mikel@resent-to.lindsaar.net'
      message[:sender] =        'mikel@sender.lindsaar.net'
      message[:subject] =       'Hello there Mikel'
      message[:to] =            'mikel@to.lindsaar.net'
      message[:content_type] =  'text/plain; charset=UTF-8'
      message[:content_transfer_encoding] = '7bit'
      message[:content_description] =       'This is a test'
      message[:content_disposition] =       'attachment; filename=File'
      message[:content_id] =                '<1234@message_id.lindsaar.net>'
      message[:mime_version]=  '1.0'
      message[:body] =          'This is a body of text'

      message_copy = message.dup
      message_headers_should_match message_copy, message
    end
  end

  describe "handling missing required fields:" do

    describe "every email" do

      describe "Message-ID" do
        it "should say if it has a message id" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          expect(mail).not_to be_has_message_id
        end

        it "should preserve any message id that you pass it if add_message_id is called explicitly" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_message_id("<ThisIsANonUniqueMessageId@me.com>")
          expect(mail.to_s).to match(/Message-ID: <ThisIsANonUniqueMessageId@me.com>\r\n/)
        end

        it "should generate a random message ID if nothing is passed to add_message_id" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_message_id
          expect(mail.to_s).to match(/Message-ID: <[\w]+@#{::Socket.gethostname}.mail>\r\n/)
        end

        it "should make an email and inject a message ID if none was set if told to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          expect(mail.to_s =~ /Message-ID: <.+@.+.mail>/i).not_to be_nil
        end

        it "should add the message id to the message permanently once sent to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s
          expect(mail).to be_has_message_id
        end

        it "should add a body part if it is missing" do
          mail = Mail.new
          mail.to_s
          expect(mail.body.class).to eq Mail::Body
        end
      end

      describe "Date" do
        it "should say if it has a date" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          expect(mail).not_to be_has_date
        end

        it "should preserve any date that you pass it if add_date is called explicitly" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_date("Mon, 24 Nov 1997 14:22:01 -0800")
          expect(mail.to_s).to match(/Date: Mon, 24 Nov 1997 14:22:01 -0800/)
        end

        it "should generate a current date if nothing is passed to add_date" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_date
          expect(mail.to_s).to match(/Date: \w{3}, [\s\d]\d \w{3} \d{4} \d{2}:\d{2}:\d{2} [-+]?\d{4}\r\n/)
        end

        it "should make an email and inject a date if none was set if told to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          expect(mail.to_s).to match(/Date: \w{3}, [\s\d]\d \w{3} \d{4} \d{2}:\d{2}:\d{2} [-+]?\d{4}\r\n/)
        end

        it "should add the date to the message permanently once sent to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s
          expect(mail).to be_has_date
        end
      end

    end

    describe "mime emails" do

      describe "mime-version" do
        it "should say if it has a mime-version" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          expect(mail).not_to be_has_mime_version
        end

        it "should preserve any mime version that you pass it if add_mime_version is called explicitly" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_mime_version("3.0 (This is an unreal version number)")
          expect(mail.to_s).to match(/Mime-Version: 3.0\r\n/)
        end

        it "should generate a mime version if nothing is passed to add_date" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_mime_version
          expect(mail.to_s).to match(/Mime-Version: 1.0\r\n/)
        end

        it "should make an email and inject a mime_version if none was set if told to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          expect(mail.to_s).to match(/Mime-Version: 1.0\r\n/)
        end

        it "should add the mime version to the message permanently once sent to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s
          expect(mail).to be_has_mime_version
        end
      end

      describe "content type" do

        it "should say if it has a content type" do
          mail = Mail.new('Content-Type: text/plain')
          expect(mail).to be_has_content_type
        end

        it "should say if it does not have a content type" do
          mail = Mail.new
          expect(mail).not_to be_has_content_type
        end

        it "should say if it has a charset" do
          mail = Mail.new('Content-Type: text/plain; charset=US-ASCII')
          expect(mail).to be_has_charset
        end

        it "should say if it has a charset" do
          mail = Mail.new('Content-Type: text/plain')
          expect(mail).not_to be_has_charset
        end

        it "should not raise a warning if there is no charset defined and only US-ASCII chars" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          expect { mail.to_s }.to_not output.to_stderr
        end

        it "should set the content type to text/plain; charset=us-ascii" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          expect(mail.to_s).to match(%r{|Content-Type: text/plain; charset=US-ASCII|})
        end

        it "should not set the charset if the file is an attachment" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          mail.content_disposition = 'attachment; filename="foo.jpg"'
          expect(mail.to_s).to match("Content-Type: text/plain;\r\n")
        end

        it "should not set the charset if the content_type is not text" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_type = "image/png"
          expect(mail.to_s).to_not match("Content-Type: image/png;\\s+charset=UTF-8")
        end

        it "should raise a warning if there is no content type and there is non ascii chars and default to text/plain, UTF-8" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_transfer_encoding = "8bit"

          result = nil
          expect {
            result = mail.to_s
          }.to output(/Non US-ASCII detected and no charset defined.\nDefaulting to UTF-8, set your own if this is incorrect./).to_stderr
          expect(result).to match(%r{|Content-Type: text/plain; charset=UTF-8|})
        end

        it "should raise a warning if there is no charset parameter and there is non ascii chars and default to text/plain, UTF-8" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_type = "text/plain"
          mail.content_transfer_encoding = "8bit"

          result = nil
          expect {
            result = mail.to_s
          }.to output(/Non US-ASCII detected and no charset defined.\nDefaulting to UTF-8, set your own if this is incorrect./).to_stderr
          expect(result).to match(%r{|Content-Type: text/plain; charset=UTF-8|})
        end

        it "should not raise a warning if there is no charset parameter and the content-type is not text" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_type = "image/png"
          mail.content_transfer_encoding = "8bit"
          expect { mail.to_s }.to_not output.to_stderr
        end

        it "should not raise a warning if there is a charset defined and there is non ascii chars" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_transfer_encoding = "8bit"
          mail.content_type = "text/plain; charset=UTF-8"
          expect { mail.to_s }.to_not output.to_stderr
        end

        it "should be able to set a content type with an array and hash" do
          mail = Mail.new
          mail.content_type = ["text", "plain", { :charset => 'US-ASCII' }]
          expect(mail[:content_type].encoded).to eq %Q[Content-Type: text/plain;\r\n\scharset=US-ASCII\r\n]
          expect(mail.content_type_parameters).to eql({"charset" => "US-ASCII"})
        end

        it "should be able to set a content type with an array and hash with a non-usascii field" do
          mail = Mail.new
          mail.content_type = ["text", "plain", { :charset => 'UTF-8' }]
          expect(mail[:content_type].encoded).to eq %Q[Content-Type: text/plain;\r\n\scharset=UTF-8\r\n]
          expect(mail.content_type_parameters).to eql({"charset" => "UTF-8"})
        end

        it "should allow us to specify a content type in a block" do
          mail = Mail.new { content_type ["text", "plain", { "charset" => "UTF-8" }] }
          expect(mail.content_type_parameters).to eql({"charset" => "UTF-8"})
        end

      end

      it "rfc2046 can be decoded" do
        mail = Mail.new
        mail.body << Mail::Part.new.tap do |part|
          part.content_disposition = 'attachment; filename="test.eml"'
          part.content_type = 'message/rfc822'
          part.body = "This is NOT plain text ASCII　− かきくけこ" * 30
        end

        roundtripped = Mail.new(mail.encoded)
        expect(roundtripped.content_transfer_encoding).to eq '7bit'
        expect(roundtripped.parts.last.content_transfer_encoding).to eq ''

        # Check that the part's transfer encoding isn't set to 7bit, causing
        # the actual content to end up encoded with base64.
        expect(roundtripped.encoded).to include('NOT plain')
        expect(roundtripped.content_transfer_encoding).to eq '7bit'
        expect(roundtripped.parts.last.content_transfer_encoding).to eq ''
      end

      # https://www.ietf.org/rfc/rfc2046.txt
      # No encoding other than "7bit", "8bit", or "binary" is permitted for
      # the body of a "message/rfc822" entity.
      it "rfc2046" do
        mail = Mail.new
        mail.body << Mail::Part.new.tap do |part|
          part.content_disposition = 'attachment; filename="test.eml"'
          part.content_type  = 'message/rfc822'
          part.body          = 'a' * 999
        end
        mail.encoded
        
        expect(mail.parts.count).to eq(1)
        expect(mail.parts.last.content_transfer_encoding).to match(/7bit|8bit|binary/)
      end

      describe 'charset=' do
        before do
          @mail = Mail.new do
            to 'mikel@test.lindsaar.net'
            from 'bob@test.lindsaar.net'
            subject 'Multipart email'
            text_part do
              body 'This is plain text'
            end
            html_part do
              content_type 'text/html; charset=UTF-8'
              body '<h1>This is HTML</h1>'
            end
          end
        end
        
        it "should not add an empty charset header" do
          @mail.charset = nil
          
          expect(@mail.multipart?).to eq true
          expect(@mail.parts.count).to eq 2
          expect(@mail.encoded.scan(/charset=UTF-8/).count).to eq 2
        end
        
        it "should remove the charset header" do
          @mail.charset = 'iso-8859-1'
          @mail.charset = nil
          
          expect(@mail.encoded.scan(/charset=UTF-8/).count).to eq 2
          expect(@mail.encoded.scan(/charset=iso-8859-1/).count).to eq 0
        end
      end

      describe "convert_to_multipart" do
        subject do
          read_fixture('emails', 'attachment_emails', 'attachment_only_email.eml').tap(&:convert_to_multipart)
        end

        it "original content headers move to the new part" do
          expect(subject.header[:content_type]).to be_nil
          expect(subject.header[:content_disposition]).to be_nil
          expect(subject.header[:content_description]).to be_nil
          expect(subject.header[:content_transfer_encoding]).to be_nil

          expect(subject.parts[0].header[:content_type].value).to eq("application/x-gzip; NAME=blah.gz")
          expect(subject.parts[0].header[:content_disposition].value).to eq("attachment; filename=blah.gz")
          expect(subject.parts[0].header[:content_description].value).to eq("Attachment has identical content to above foo.gz")
          expect(subject.parts[0].header[:content_transfer_encoding].value).to eq("base64")
        end
      end

      describe "content-transfer-encoding" do

        it "should use 7bit for only US-ASCII chars" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          expect(mail.to_s).to match(%r{Content-Transfer-Encoding: 7bit})
        end

        it "should use QP transfer encoding for 7bit text with lines longer than 998 octets" do
          body = "a" * 999
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          expect(mail.to_s).to match(%r{Content-Transfer-Encoding: quoted-printable})
        end

        it "should use QP transfer encoding for 8bit text with only a few 8bit characters" do
          body = "Maxfeldstraße 5, 90409 Nürnberg"
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          expect(mail.to_s).to match(%r{Content-Transfer-Encoding: quoted-printable})
        end

        it "should use QP transfer encoding for 8bit text attachment with only a few 8bit characters" do
          mail = Mail.new
          file_content = String.new("Pok\xE9mon")
          file_content = file_content.force_encoding('BINARY') if file_content.respond_to?(:force_encoding)
          mail.attachments['iso_text.txt'] = file_content
          mail.body = 'This is plain text US-ASCII'
          expect(mail.to_s).to match(%r{
            Content-Transfer-Encoding:\ 7bit
            .*
            This\ is\ plain\ text\ US-ASCII
            .*
            Content-Transfer-Encoding:\ quoted-printable
            .*
            Pok=E9mon
          }mx)
        end

        it "should use base64 transfer encoding for 8-bit text with lots of 8bit characters" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          mail.content_type = "text/plain; charset=utf-8"
          expect(mail).to be_has_content_type
          expect(mail).to be_has_charset
          expect(mail.to_s).to match(%r{Content-Transfer-Encoding: base64})
        end

        it "should use 8bit transfer encoding when 8bit is forced" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          mail.content_type = "text/plain; charset=utf-8"
          mail.transport_encoding = "8bit"
          expect(mail.to_s).to match(%r{Content-Transfer-Encoding: 8bit})
        end

      end

    end

  end

  describe "output" do

    it "should make an email and allow you to call :to_s on it to get a string" do
      mail = Mail.new do
           from 'mikel@test.lindsaar.net'
             to 'you@test.lindsaar.net'
        subject 'This is a test email'
           body 'This is a body of the email'
      end

      expect(mail.to_s).to match(/From: mikel@test.lindsaar.net\r\n/)
      expect(mail.to_s).to match(/To: you@test.lindsaar.net\r\n/)
      expect(mail.to_s).to match(/Subject: This is a test email\r\n/)
      expect(mail.to_s).to match(/This is a body of the email/)

    end

    it "should raise an error and message if you try and call decoded on a multipart email" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
        from 'bob@test.lindsaar.net'
        subject 'Multipart email'
        text_part do
          body 'This is plain text'
        end
        html_part do
          content_type 'text/html; charset=UTF-8'
          body '<h1>This is HTML</h1>'
        end
      end
      expect { mail.decoded }.to raise_error(NoMethodError, 'Can not decode an entire message, try calling #decoded on the various fields and body or parts if it is a multipart message.')
    end

    it "should return the decoded body if you call decode and the message is not multipart" do
      mail = Mail.new do
        content_transfer_encoding 'base64'
        body "VGhlIGJvZHk=\n"
      end
      expect(mail.decoded).to eq "The body"
    end

    describe "decoding bodies" do

      it "should not change a body on decode if not given an encoding type to decode" do
        mail = Mail.new do
          body "The=3Dbody"
        end
        expect(mail.body.decoded).to eq "The=3Dbody"
        expect(mail.body.encoded).to eq "The=3Dbody"
      end

      it "should change a body on decode if given an encoding type to decode" do
        mail = Mail.new do
          content_transfer_encoding 'quoted-printable'
          body "The=3Dbody"
        end
        expect(mail.body.decoded).to eq "The=body"
        expect(mail.body.encoded).to eq "The=3Dbody=\r\n"
      end

      it "should change a body on decode if given an encoding type to decode" do
        mail = Mail.new do
          content_transfer_encoding 'base64'
          body "VGhlIGJvZHk=\n"
        end
        expect(mail.body.decoded).to eq "The body"
        expect(mail.body.encoded).to eq "VGhlIGJvZHk=\r\n"
      end

      it 'should not strip the raw mail source in case the trailing \r\n is meaningful' do
        expect(Mail.new("Content-Transfer-Encoding: quoted-printable;\r\n\r\nfoo=\r\nbar=\r\nbaz=\r\n").decoded).to eq 'foobarbaz'
      end

    end

  end

  describe "text messages" do
    def message_with_iso_8859_1_charset
      "From: test@example.com\r\n"+
      "Content-Type: text/plain; charset=iso-8859-1\r\n"+
      "Content-Transfer-Encoding: quoted-printable\r\n"+
      "Date: Tue, 27 Sep 2011 16:59:48 +0100 (BST)\r\n"+
      "Subject: test\r\n\r\n"+
      "Am=E9rica"
    end

    def with_encoder(encoder)
      old, Mail::Ruby19.charset_encoder = Mail::Ruby19.charset_encoder, encoder
      yield
    ensure
      Mail::Ruby19.charset_encoder = old
    end

    let(:message){
      Mail.new(message_with_iso_8859_1_charset)
    }

    it "should be decoded using content type charset" do
      expect(message.decoded).to eq "América"
    end

    it "should respond true to text?" do
      expect(message.text?).to eq true
    end

    it "inspect_structure should return the same as inspect (no attachments)" do
      expect(message.inspect_structure).to eq message.inspect
    end

    it "uses the Ruby19 charset encoder" do
      with_encoder(Mail::Ruby19::BestEffortCharsetEncoder.new) do
        message = Mail.new("Content-Type: text/plain;\r\n charset=windows-1258\r\nContent-Transfer-Encoding: base64\r\n\r\nSGkglg==\r\n")
        expect(message.decoded).to eq("Hi –")
      end
    end
  end

  describe "helper methods" do

    describe "==" do
      before(:each) do
        # Ensure specs don't randomly fail due to messages being generated 1 second apart
        time = DateTime.now
        expect(DateTime).to receive(:now).at_least(:once).and_return(time)
      end

      it "should be implemented" do
        expect { Mail.new == Mail.new }.not_to raise_error
      end

      it "should ignore the message id value if both have a nil message id" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        expect(m1).to eq m2
        # confirm there are no side-effects in the comparison
        expect(m1[:message_id]).to be_nil
        expect(m2[:message_id]).to be_nil
      end

      it "should ignore the message id value if self has a nil message id" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")

        # confirm there are no side-effects in the comparison
        expect(m1[:message_id]).to be_nil
        expect(m2[:message_id].value).to eq '<1234@test.lindsaar.net>'

        expect(m1).to eq m2
      end

      it "should ignore the message id value if other has a nil message id" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")

        # confirm there are no side-effects in the comparison
        expect(m1[:message_id].value).to eq '<1234@test.lindsaar.net>'
        expect(m2[:message_id]).to be_nil

        expect(m1).to eq m2
      end

      it "should not be == if both emails have different Message IDs" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <4321@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        expect(m1).not_to eq m2
        # confirm there are no side-effects in the comparison
        expect(m1.message_id).to eq '4321@test.lindsaar.net'
        expect(m2.message_id).to eq '1234@test.lindsaar.net'
      end
    end

    it "should implement the spaceship operator on the date field" do
      now = Time.now
      mail1 = Mail.new do
        date(now)
      end
      mail2 = Mail.new do
        date(now - 10) # Make mail2 10 seconds 'older'
      end
      expect([mail2, mail1].sort).to eq [mail2, mail1]
    end

    it "should have a destinations method" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
        cc 'bob@test.lindsaar.net'
        bcc 'sam@test.lindsaar.net'
      end
      expect(mail.destinations.length).to eq 3
    end

    it "should have a from_addrs method" do
      mail = Mail.new do
        from 'mikel@test.lindsaar.net'
      end
      expect(mail.from_addrs.length).to eq 1
    end

    it "should have a from_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      expect(mail.from_addrs.length).to eq 0
    end

    it "should have a to_addrs method" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
      end
      expect(mail.to_addrs.length).to eq 1
    end

    it "should have a to_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      expect(mail.to_addrs.length).to eq 0
    end

    it "should have a cc_addrs method" do
      mail = Mail.new do
        cc 'bob@test.lindsaar.net'
      end
      expect(mail.cc_addrs.length).to eq 1
    end

    it "should have a cc_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      expect(mail.cc_addrs.length).to eq 0
    end

    it "should have a bcc_addrs method" do
      mail = Mail.new do
        bcc 'sam@test.lindsaar.net'
      end
      expect(mail.bcc_addrs.length).to eq 1
    end

    it "should have a bcc_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      expect(mail.bcc_addrs.length).to eq 0
    end

    it "should give destinations even if some of the fields are blank" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
      end
      expect(mail.destinations.length).to eq 1
    end

    it "should be able to encode with only one destination" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
      end
      mail.encoded
    end

  end

  describe "nested parts" do
    it "adds a new text part when assigning the body on an already-multipart message" do
      mail = Mail.new do
        part :content_type => 'foo/bar', :body => 'baz'
      end

      mail.body 'this: body is not a header'

      expect(mail.parts.size).to eq(2)
      expect(mail.text_part).not_to be_nil
      expect(mail.text_part.decoded).to eq('this: body is not a header')
    end

    it "should provide a way to instantiate a new part as you go down" do
      mail = Mail.new do
        to           'mikel@test.lindsaar.net'
        subject      "nested multipart"
        from         "test@example.com"
        content_type "multipart/mixed"

        part :content_type => "multipart/alternative", :content_disposition => "inline", :headers => { "foo" => "bar" } do |p|
          p.part :content_type => "text/plain", :body => "test text\nline #2"
          p.part :content_type => "text/html", :body => "<b>test</b> HTML<br/>\nline #2"
        end

      end

      expect(mail.parts.first).to be_multipart
      expect(mail.parts.first.parts.length).to eq 2
      expect(mail.parts.first.parts[0][:content_type].string).to eq "text/plain"
      expect(mail.parts.first.parts[0].body.decoded).to eq "test text\nline #2"
      expect(mail.parts.first.parts[1][:content_type].string).to eq "text/html"
      expect(mail.parts.first.parts[1].body.decoded).to eq "<b>test</b> HTML<br/>\nline #2"
    end
  end

  describe "deliver" do
    it "should return self after delivery" do
      mail = Mail.new
      mail.perform_deliveries = false
      expect(mail.deliver).to eq mail
    end

    class DeliveryAgent
      def self.deliver_mail(mail)
      end
    end

    it "should pass self to a delivery agent" do
      mail = Mail.new
      mail.delivery_handler = DeliveryAgent
      expect(DeliveryAgent).to receive(:deliver_mail).with(mail)
      mail.deliver
    end

    class ObserverAgent
      def self.delivered_email(mail)
      end
    end

    it "should inform observers that the mail was sent" do
      mail = Mail.new(:from => 'bob@example.com', :to => 'bobette@example.com')
      mail.delivery_method :test
      Mail.register_observer(ObserverAgent)
      expect(ObserverAgent).to receive(:delivered_email).with(mail)
      mail.deliver
    end

    it "should allow observers to be unregistered" do
      mail = Mail.new(:from => 'bob@example.com', :to => 'bobette@example.com')
      mail.delivery_method :test
      Mail.register_observer(ObserverAgent)
      Mail.unregister_observer(ObserverAgent)
      expect(ObserverAgent).not_to receive(:delivered_email).with(mail)
      mail.deliver
    end

    it "should inform observers that the mail was sent, even if a delivery agent is used" do
      mail = Mail.new
      mail.delivery_handler = DeliveryAgent
      Mail.register_observer(ObserverAgent)
      expect(ObserverAgent).to receive(:delivered_email).with(mail)
      mail.deliver
    end

    class InterceptorAgent
      @@intercept = false
      def self.intercept=(val)
        @@intercept = val
      end
      def self.delivering_email(mail)
        if @@intercept
          mail.to = 'bob@example.com'
        end
      end
    end

    it "should pass to the interceptor the email just before it gets sent" do
      mail = Mail.new(:from => 'bob@example.com', :to => 'bobette@example.com')
      mail.delivery_method :test
      Mail.register_interceptor(InterceptorAgent)
      expect(InterceptorAgent).to receive(:delivering_email).with(mail)
      InterceptorAgent.intercept = true
      mail.deliver
      InterceptorAgent.intercept = false
    end

    it "should let the interceptor that the mail was sent" do
      mail = Mail.new(:from => 'bob@example.com', :to => 'bobette@example.com')
      mail.to = 'fred@example.com'
      mail.delivery_method :test
      Mail.register_interceptor(InterceptorAgent)
      InterceptorAgent.intercept = true
      mail.deliver
      InterceptorAgent.intercept = false
      expect(mail.to).to eq ['bob@example.com']
    end

    it "should allow interceptors to be unregistered" do
      mail = Mail.new(:from => 'bob@example.com', :to => 'bobette@example.com')
      mail.to = 'fred@example.com'
      mail.delivery_method :test
      Mail.register_interceptor(InterceptorAgent)
      InterceptorAgent.intercept = true
      Mail.unregister_interceptor(InterceptorAgent)
      mail.deliver
      InterceptorAgent.intercept = false
      expect(mail.to).to eq ['fred@example.com']
    end

  end

  describe "error handling" do
    it "should collect up any of its fields' errors" do
      mail = Mail.new("Content-Transfer-Encoding: vl@d\r\nReply-To: a b b\r\n")
      expect(Mail::Utilities.blank?(mail.errors)).not_to be_truthy
      expect(mail.errors.size).to eq 2
      expect(mail.errors[0][0]).to eq 'Reply-To'
      expect(mail.errors[0][1]).to eq 'a b b'
      expect(mail.errors[1][0]).to eq 'Content-Transfer-Encoding'
      expect(mail.errors[1][1]).to eq 'vl@d'
    end
  end

  describe "header case should be preserved" do
    it "should handle mail[] and keep the header case" do
      mail = Mail.new
      mail['X-Foo-Bar'] = "Some custom text"
      expect(mail.to_s).to match(/X-Foo-Bar: Some custom text/)
    end
  end

  describe "parsing emails with non usascii in the header" do
    it "should work" do
      mail = Mail.new('From: "Foo áëô îü" <extended@example.net>')
      expect(mail.from).to eq ['extended@example.net']
      expect(mail[:from].decoded).to eq '"Foo áëô îü" <extended@example.net>'
      expect(mail[:from].encoded).to eq "From: =?UTF-8?B?Rm9vIMOhw6vDtCDDrsO8?= <extended@example.net>\r\n"
    end
  end

  describe "ordering messages" do
    it "should put all attachments as the last item" do
      mail = Mail.new
      mail.attachments['image.png'] = "\302\302\302\302"
      p = Mail::Part.new(:content_type => 'multipart/alternative')
      p.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
      p.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
      mail.add_part(p)
      mail.encoded
      expect(mail.parts[0].mime_type).to eq "multipart/alternative"
      expect(mail.parts[0].parts[0].mime_type).to eq "text/plain"
      expect(mail.parts[0].parts[1].mime_type).to eq "text/html"
      expect(mail.parts[1].mime_type).to eq "image/png"
    end

    it "should allow overwriting sort order" do
      mail = Mail.new
      mail.body.set_sort_order([])
      mail.attachments['image.png'] = "\302\302\302\302"
      p = Mail::Part.new(:content_type => 'multipart/alternative')
      p.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
      p.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
      mail.add_part(p)
      mail.encoded
      expect(mail.parts[0].mime_type).to eq "multipart/alternative"
      expect(mail.parts[0].parts[0].mime_type).to eq "text/plain"
      expect(mail.parts[0].parts[1].mime_type).to eq "text/html"
      expect(mail.parts[1].mime_type).to eq "image/png"
    end
  end

  describe "attachment query methods" do
    it "shouldn't die with an invalid Content-Disposition header" do
      mail = Mail.new('Content-Disposition: invalid')
      expect { mail.attachment? }.not_to raise_error
    end

    it "shouldn't die with an invalid Content-Type header" do
      mail = Mail.new('Content-Type: invalid/invalid; charset="iso-8859-1"')
      mail.attachment?
      expect { mail.attachment? }.not_to raise_error
    end

  end

  describe "without_attachments!" do
    it "should delete all attachments" do
      emails_with_attachments = [
        ['attachment_emails', 'attachment_content_disposition.eml'],
        ['attachment_emails', 'attachment_content_location.eml'],
        ['attachment_emails', 'attachment_pdf.eml'],
        ['attachment_emails', 'attachment_with_encoded_name.eml'],
        ['attachment_emails', 'attachment_with_quoted_filename.eml'],
        ['mime_emails', 'raw_email7.eml']]

      emails_with_attachments.each { |file_name|
        mail = read_fixture('emails', *file_name)
        non_attachment_parts = mail.all_parts.reject(&:attachment?)
        expect(mail.has_attachments?).to be_truthy
        mail.without_attachments!

        expect(mail.all_parts).to eq non_attachment_parts
        expect(mail.has_attachments?).to be_falsey
      }
    end
  end

  describe "replying" do

    describe "to a basic message" do

      before do
        @mail = read_fixture('emails', 'plain_emails', 'basic_email.eml')
      end

      it "should create a new message" do
        expect(@mail.reply).to be_a_kind_of(Mail::Message)
      end

      it "should be in-reply-to the original message" do
        expect(@mail.reply.in_reply_to).to eq '6B7EC235-5B17-4CA8-B2B8-39290DEB43A3@test.lindsaar.net'
      end

      it "should reference the original message" do
        expect(@mail.reply.references).to eq '6B7EC235-5B17-4CA8-B2B8-39290DEB43A3@test.lindsaar.net'
      end

      it "should Re: the original subject" do
        expect(@mail.reply.subject).to eq 'Re: Testing 123'
      end

      it "should be sent to the original sender" do
        expect(@mail.reply.to).to eq ['test@lindsaar.net']
        expect(@mail.reply[:to].to_s).to eq 'Mikel Lindsaar <test@lindsaar.net>'
      end

      it "should be sent from the original recipient" do
        expect(@mail.reply.from).to eq ['raasdnil@gmail.com']
        expect(@mail.reply[:from].to_s).to eq 'Mikel Lindsaar <raasdnil@gmail.com>'
      end

      it "should accept args" do
        expect(@mail.reply(:from => 'Donald Ball <donald.ball@gmail.com>').from).to eq ['donald.ball@gmail.com']
      end

      it "should accept a block" do
        expect(@mail.reply { from('Donald Ball <donald.ball@gmail.com>') }.from).to eq ['donald.ball@gmail.com']
      end

    end

    describe "to a message with an explicit reply-to address" do

      before do
        @mail = read_fixture('emails', 'rfc2822', 'example06.eml')
      end

      it "should be sent to the reply-to address" do
        expect(@mail.reply[:to].to_s).to eq '"Mary Smith: Personal Account" <smith@home.example>'
      end

    end

    describe "to a message with more than one recipient" do

      before do
        @mail = read_fixture('emails', 'rfc2822', 'example03.eml')
      end

      it "should be sent from the first to address" do
        expect(@mail.reply[:from].to_s).to eq 'Mary Smith <mary@x.test>'
      end

    end

    describe "to a reply" do

      before do
        @mail = read_fixture('emails', 'plain_emails', 'raw_email_reply.eml')
      end

      it "should be in-reply-to the original message" do
        expect(@mail.reply.in_reply_to).to eq '473FFE27.20003@xxx.org'
      end

      it "should append to the original's references list" do
        expect(@mail.reply[:references].message_ids).to eq ['473FF3B8.9020707@xxx.org', '348F04F142D69C21-291E56D292BC@xxxx.net', '473FFE27.20003@xxx.org']
      end

      it "should not append another Re:" do
        expect(@mail.reply.subject).to eq "Re: Test reply email"
      end

    end

    describe "to a reply with an in-reply-to with a single message id but no references header" do

      before do
        @mail = Mail.new do
          in_reply_to '<1234@test.lindsaar.net>'
          message_id '5678@test.lindsaar.net'
        end
      end

      it "should have a references consisting of the in-reply-to and message_id fields" do
        expect(@mail.reply[:references].message_ids).to eq ['1234@test.lindsaar.net', '5678@test.lindsaar.net']
      end

    end

    describe "to a reply with an in-reply-to with multiple message ids but no references header" do

      before do
        @mail = Mail.new do
          in_reply_to '<1234@test.lindsaar.net> <5678@test.lindsaar.net>'
          message_id '90@test.lindsaar.net'
        end
      end

      # Behavior is actually not defined in RFC2822, so we'll just leave it empty
      it "should have no references header" do
        expect(@mail.references).to be_nil
      end

    end

  end

  describe 'SMTP envelope From' do
    it 'should respond' do
      expect(Mail::Message.new).to respond_to(:smtp_envelope_from)
    end

    it 'should default to return_path, sender, or first from address' do
      message = Mail::Message.new do
        return_path 'return'
        sender 'sender'
        from 'from'
      end
      expect(message.smtp_envelope_from).to eq 'return'

      message.return_path = nil
      expect(message.smtp_envelope_from).to eq 'sender'

      message.sender = nil
      expect(message.smtp_envelope_from).to eq 'from'
    end

    it 'can be overridden' do
      message = Mail::Message.new { return_path 'return' }

      message.smtp_envelope_from = 'envelope_from'
      expect(message.smtp_envelope_from).to eq 'envelope_from'

      message.smtp_envelope_from = 'declared_from'
      expect(message.smtp_envelope_from).to eq 'declared_from'

      message.smtp_envelope_from = nil
      expect(message.smtp_envelope_from).to eq 'return'
    end
  end

  describe 'SMTP envelope To' do
    it 'should respond' do
      expect(Mail::Message.new).to respond_to(:smtp_envelope_to)
    end

    it 'should default to destinations' do
      message = Mail::Message.new do
        to 'to'
        cc 'cc'
        bcc 'bcc'
      end
      expect(message.smtp_envelope_to).to eq message.destinations
    end

    it 'can be overridden' do
      message = Mail::Message.new { to 'to' }

      message.smtp_envelope_to = 'envelope_to'
      expect(message.smtp_envelope_to).to eq %w(envelope_to)

      message.smtp_envelope_to = 'declared_to'
      expect(message.smtp_envelope_to).to eq %w(declared_to)

      message.smtp_envelope_to = nil
      expect(message.smtp_envelope_to).to eq %w(to)
    end
  end

end
