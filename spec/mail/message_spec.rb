# encoding: utf-8
require 'spec_helper'

describe Mail::Message do

  def basic_email
    "To: mikel\r\nFrom: bob\r\nSubject: Hello!\r\n\r\nemail message\r\n"
  end

  describe "initialization" do

    it "should instantiate empty" do
      Mail::Message.new.class.should == Mail::Message
    end

    it "should return a basic email" do
      mail = Mail.new
      mail = Mail.new(mail.to_s)
      mail.date.should_not be_blank
      mail.message_id.should_not be_blank
      mail.mime_version.should == "1.0"
      mail.content_type.should == "text/plain"
      mail.content_transfer_encoding.should == "7bit"
      mail.subject.should be_blank
      mail.body.should be_blank
    end

    it "should instantiate with a string" do
      Mail::Message.new(basic_email).class.should == Mail::Message
    end

    it "should allow us to pass it a block" do
      mail = Mail::Message.new do
        from 'mikel@me.com'
        to 'lindsaar@you.com'
      end
      mail.from.should == ['mikel@me.com']
      mail.to.should == ['lindsaar@you.com']
    end

    it "should initialize a body and header class even if called with nothing to begin with" do
      mail = Mail::Message.new
      mail.header.class.should == Mail::Header
      mail.body.class.should == Mail::Body
    end

    it "should not report basic emails as bounced" do
      Mail::Message.new.should_not be_bounced
    end

    it "should be able to parse a basic email" do
      doing { Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'basic_email.eml'))) }.should_not raise_error
    end

    it "should be able to parse an email with only blank lines as body" do
      doing { Mail::Message.new(File.read(fixture('emails', 'error_emails', 'missing_body.eml'))) }.should_not raise_error
    end

    it "should be able to parse an email with a funky date header" do
      doing { Mail::Message.new(File.read(fixture('emails', 'error_emails', 'bad_date_header2.eml'))) }
    end

    it 'should be able to invoke subject on a funky subject header' do
      Mail::Message.new(File.read(fixture('emails', 'error_emails', 'bad_subject.eml'))).subject
    end


    it 'should be able to parse an email missing an encoding' do
      Mail::Message.new(File.read(fixture('emails', 'error_emails', 'must_supply_encoding.eml')))
    end

    it "should be able to parse every email example we have without raising an exception" do
      emails = Dir.glob( fixture('emails/**/*') ).delete_if { |f| File.directory?(f) }

      STDERR.stub!(:puts) # Don't want to get noisy about any warnings
      errors = false
      expected_failures = []
      emails.each do |email|
        begin
          Mail::Message.new(File.read(email))
        rescue => e
          unless expected_failures.include?(email)
            puts "Failed on email #{email}"
            puts "Failure was:\n#{e}\n\n"
            errors = true
          end
        end
      end
      errors.should be_false
    end

    it "should not raise a warning on having non US-ASCII characters in the header (should just handle it)" do
      STDERR.should_not_receive(:puts)
      Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'raw_email_string_in_date_field.eml')))
    end

    it "should raise a warning (and keep parsing) on having an incorrectly formatted header" do
      STDERR.should_receive(:puts).with("WARNING: Could not parse (and so ignorning) 'quite Delivered-To: xxx@xxx.xxx'")
      Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'raw_email_incorrect_header.eml')))
    end

    it "should read in an email message and basically parse it" do
      mail = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'basic_email.eml')))
      mail.to.should == ["raasdnil@gmail.com"]
    end

    it "should not fail parsing message with caps in content_type" do
      mail = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'mix_caps_content_type.eml')))
      mail.content_type.should == 'text/plain; charset=iso-8859-1'
      mail.main_type.should == 'text'
      mail.sub_type.should == 'plain'
    end

    it "should be able to pass an empty reply-to header" do
      mail = Mail.new(File.read(fixture('emails', 'error_emails', 'empty_in_reply_to.eml')))
      mail.in_reply_to.should be_blank
    end

    describe "YAML serialization" do
      before(:each) do
        @yaml_mail = Mail::Message.new(:to => 'someone@somewhere.com',
                                  :cc => 'someoneelse@somewhere.com',
                                  :bcc => 'someonesecret@somewhere.com',
                                  :body => 'body',
                                  :subject => 'subject')
        @smtp_settings = { :address=>"smtp.somewhere.net",
          :port=>"587", :domain=>"somewhere.net", :user_name=>"someone@somewhere.net",
          :password=>"password", :authentication=>:plain, :enable_starttls_auto => true,
          :openssl_verify_mode => nil }
        @yaml_mail.delivery_method :smtp, @smtp_settings
      end

      it "should serialize the basic information to YAML" do
        yaml = @yaml_mail.to_yaml
        yaml_output = YAML.load(yaml)
        yaml_output['headers']['To'].should       == "someone@somewhere.com"
        yaml_output['headers']['Cc'].should       == "someoneelse@somewhere.com"
        yaml_output['headers']['Subject'].should  == "subject"
        yaml_output['headers']['Bcc'].should      == "someonesecret@somewhere.com"
        yaml_output['@body_raw'].should           == "body"
        yaml_output['@delivery_method'].should_not be_blank
      end

      it "should deserialize after serializing" do
        deserialized = Mail::Message.from_yaml(@yaml_mail.to_yaml)
        deserialized.should == @yaml_mail
        deserialized.delivery_method.settings.should == @smtp_settings
      end

      it "should serialize a Message with a custom delivery_handler" do
        @yaml_mail.delivery_handler = DeliveryAgent
        yaml = @yaml_mail.to_yaml
        yaml_output = YAML.load(yaml)
        yaml_output['delivery_handler'].should == "DeliveryAgent"
      end

      it "should load a serialized delivery handler" do
        @yaml_mail.delivery_handler = DeliveryAgent
        deserialized = Mail::Message.from_yaml(@yaml_mail.to_yaml)
        deserialized.delivery_handler.should == DeliveryAgent
      end

      it "should not deserialize a delivery_handler that does not exist" do
        yaml = @yaml_mail.to_yaml
        yaml_hash = YAML.load(yaml)
        yaml_hash['delivery_handler'] = "NotARealClass"
        deserialized = Mail::Message.from_yaml(yaml_hash.to_yaml)
        deserialized.delivery_handler.should be_nil
      end
    end
  end

  describe "envelope line handling" do
    it "should respond to 'envelope from'" do
      Mail::Message.new.should respond_to(:envelope_from)
    end

    it "should strip off the envelope from field if present" do
      message = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'raw_email.eml')))
      message.envelope_from.should == "jamis_buck@byu.edu"
      message.envelope_date.should == ::DateTime.parse("Mon May  2 16:07:05 2005")
    end

    it "should strip off the envelope from field if present" do
      message = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'raw_email.eml')))
      message.raw_envelope.should == "jamis_buck@byu.edu Mon May  2 16:07:05 2005"
      message.from.should == ["jamis@37signals.com"]
    end

    it "should not cause any problems if there is no envelope from present" do
      message = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'basic_email.eml')))
      message.from.should == ["test@lindsaar.net"]
    end

    it "should ignore a plain text body that starts with ^From" do
      m = Mail::Message.new("From: mikel@test.lindsaar.net\r\n\r\nThis is a way to break mail by putting\r\nFrom at the start of a body\r\nor elsewhere.")
      m.from.should_not be_nil
      m.from.should == ['mikel@test.lindsaar.net']
    end

    it "should handle a multipart message that has ^From in it" do
      m = Mail::Message.new(File.read(fixture('emails', 'error_emails', 'cant_parse_from.eml')))
      m.from.should_not be_nil
      m.from.should == ["News@InsideApple.Apple.com"]
      m.should be_multipart
    end

  end

  describe "accepting a plain text string email" do

    it "should accept some email text to parse and return an email" do
      mail = Mail::Message.new(basic_email)
      mail.class.should == Mail::Message
    end

    it "should set a raw source instance variable to equal the passed in message" do
      mail = Mail::Message.new(basic_email)
      mail.raw_source.should == basic_email.strip
    end

    it "should set the raw source instance variable to '' if no message is passed in" do
      mail = Mail::Message.new
      mail.raw_source.should == ""
    end

    it "should give the header class the header to parse" do
      header = Mail::Header.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
      Mail::Header.should_receive(:new).with("To: mikel\r\nFrom: bob\r\nSubject: Hello!", 'UTF-8').and_return(header)
      mail = Mail::Message.new(basic_email)
    end

    it "should give the header class the header to parse even if there is no body" do
      header = Mail::Header.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
      Mail::Header.should_receive(:new).with("To: mikel\r\nFrom: bob\r\nSubject: Hello!", 'UTF-8').and_return(header)
      mail = Mail::Message.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
    end

    it "should give the body class the body to parse" do
      body = Mail::Body.new("email message")
      Mail::Body.should_receive(:new).with("email message").and_return(body)
      mail = Mail::Message.new(basic_email)
      mail.body #body calculates now lazy so need to ask for it
    end

    it "should still ask the body for a new instance even though these is nothing to parse, yet" do
      body = Mail::Body.new('')
      Mail::Body.should_receive(:new).and_return(body)
      mail = Mail::Message.new("To: mikel\r\nFrom: bob\r\nSubject: Hello!")
    end

    it "should give the header the part before the line without spaces and the body the part without" do
      header = Mail::Header.new("To: mikel")
      body = Mail::Body.new("G'Day!")
      Mail::Header.should_receive(:new).with("To: mikel", 'UTF-8').and_return(header)
      Mail::Body.should_receive(:new).with("G'Day!").and_return(body)
      mail = Mail::Message.new("To: mikel\r\n\r\nG'Day!")
      mail.body #body calculates now lazy so need to ask for it
    end

    it "should give allow for whitespace on the gap line between header and body" do
      header = Mail::Header.new("To: mikel")
      body = Mail::Body.new("G'Day!")
      Mail::Header.should_receive(:new).with("To: mikel", 'UTF-8').and_return(header)
      Mail::Body.should_receive(:new).with("G'Day!").and_return(body)
      mail = Mail::Message.new("To: mikel\r\n   		  \r\nG'Day!")
      mail.body #body calculates now lazy so need to ask for it
    end

    it "should allow for whitespace at the start of the email" do
      mail = Mail.new("\r\n\r\nFrom: mikel\r\n\r\nThis is the body")
      mail.from.should == ['mikel']
      mail.body.to_s.should == 'This is the body'
    end

    it "should read in an email message with the word 'From' in it multiple times and parse it" do
      mail = Mail::Message.new(File.read(fixture('emails', 'mime_emails', 'two_from_in_message.eml')))
      mail.to.should_not be_nil
      mail.to.should == ["tester2@test.com"]
    end

  end

  describe "directly setting values of a message" do

    describe "accessing fields directly" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should allow you to grab field objects if you really want to" do
        @mail.header_fields.class.should == Mail::FieldList
      end

      it "should give you back the fields in the header" do
        @mail['bar'] = 'abcd'
        @mail.header_fields.length.should == 1
        @mail['foo'] = '4321'
        @mail.header_fields.length.should == 2
      end

      it "should delete a field if it is set to nil" do
        @mail['foo'] = '4321'
        @mail.header_fields.length.should == 1
        @mail['foo'] = nil
        @mail.header_fields.length.should == 0
      end

    end

    describe "with :method=" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should return the to field" do
        @mail.to = "mikel"
        @mail.to.should == ["mikel"]
      end

      it "should return the from field" do
        @mail.from = "bob"
        @mail.from.should == ["bob"]
      end

      it "should return the subject" do
        @mail.subject = "Hello!"
        @mail.subject.should == "Hello!"
      end

      it "should return the body decoded with to_s" do
        @mail.body "email message\r\n"
        @mail.body.to_s.should == "email message\n"
      end

      it "should return the body encoded if asked for" do
        @mail.body "email message\r\n"
        @mail.body.encoded.should == "email message\r\n"
      end

      it "should return the body decoded if asked for" do
        @mail.body "email message\r\n"
        @mail.body.decoded.should == "email message\n"
      end
    end

    describe "with :method(value)" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should return the to field" do
        @mail.to "mikel"
        @mail.to.should == ["mikel"]
      end

      it "should return the from field" do
        @mail.from "bob"
        @mail.from.should == ["bob"]
      end

      it "should return the subject" do
        @mail.subject "Hello!"
        @mail.subject.should == "Hello!"
      end

      it "should return the body decoded with to_s" do
        @mail.body "email message\r\n"
        @mail.body.to_s.should == "email message\n"
      end

      it "should return the body encoded if asked for" do
        @mail.body "email message\r\n"
        @mail.body.encoded.should == "email message\r\n"
      end

      it "should return the body decoded if asked for" do
        @mail.body "email message\r\n"
        @mail.body.decoded.should == "email message\n"
      end
    end

    describe "setting arbitrary headers" do

      before(:each) do
        @mail = Mail::Message.new
      end

      it "should allow you to set them" do
        doing {@mail['foo'] = 1234}.should_not raise_error
      end

      it "should allow you to read arbitrary headers" do
        @mail['foo'] = 1234
        @mail['foo'].value.to_s.should == '1234'
      end

      it "should instantiate a new Header" do
        @mail['foo'] = 1234
        @mail.header_fields.first.class.should == Mail::Field
      end
    end

    describe "replacing header values" do

      it "should allow you to replace a from field" do
        mail = Mail.new
        mail.from.should == nil
        mail.from = 'mikel@test.lindsaar.net'
        mail.from.should == ['mikel@test.lindsaar.net']
        mail.from = 'bob@test.lindsaar.net'
        mail.from.should == ['bob@test.lindsaar.net']
      end

      it "should maintain the class of the field" do
        mail = Mail.new
        mail.from = 'mikel@test.lindsaar.net'
        mail[:from].field.class.should == Mail::FromField
        mail.from = 'bob@test.lindsaar.net'
        mail[:from].field.class.should == Mail::FromField
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

        message.bcc.should           == ['mikel@bcc.lindsaar.net']
        message.cc.should            == ['mikel@cc.lindsaar.net']
        message.comments.should      == 'this is a comment'
        message.date.should          == DateTime.parse('12 Aug 2009 00:00:01 GMT')
        message.from.should          == ['mikel@from.lindsaar.net']
        message.in_reply_to.should   == '1234@in_reply_to.lindsaar.net'
        message.keywords.should      == ["test", "of the new mail", "system"]
        message.message_id.should    == '1234@message_id.lindsaar.net'
        message.received.date_time.should      == DateTime.parse('12 Aug 2009 00:00:02 GMT')
        message.references.should    == '1234@references.lindsaar.net'
        message.reply_to.should      == ['mikel@reply-to.lindsaar.net']
        message.resent_bcc.should    == ['mikel@resent-bcc.lindsaar.net']
        message.resent_cc.should     == ['mikel@resent-cc.lindsaar.net']
        message.resent_date.should   == DateTime.parse('12 Aug 2009 00:00:03 GMT')
        message.resent_from.should   == ['mikel@resent-from.lindsaar.net']
        message.resent_message_id.should == '1234@resent_message_id.lindsaar.net'
        message.resent_sender.should == ['mikel@resent-sender.lindsaar.net']
        message.resent_to.should     == ['mikel@resent-to.lindsaar.net']
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == ['mikel@to.lindsaar.net']
        message.content_type.should              == 'text/plain; charset=UTF-8'
        message.content_transfer_encoding.should == '7bit'
        message.content_description.should       == 'This is a test'
        message.content_disposition.should       == 'attachment; filename=File'
        message.content_id.should                == '<1234@message_id.lindsaar.net>'
        message.mime_version.should              == '1.0'
        message.body.to_s.should          == 'This is a body of text'
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

        message.bcc.should           == ['mikel@bcc.lindsaar.net']
        message.cc.should            == ['mikel@cc.lindsaar.net']
        message.comments.should      == 'this is a comment'
        message.date.should          == DateTime.parse('12 Aug 2009 00:00:01 GMT')
        message.from.should          == ['mikel@from.lindsaar.net']
        message.in_reply_to.should   == '1234@in_reply_to.lindsaar.net'
        message.keywords.should      == ["test", "of the new mail", "system"]
        message.message_id.should    == '1234@message_id.lindsaar.net'
        message.received.date_time.should      == DateTime.parse('12 Aug 2009 00:00:02 GMT')
        message.references.should    == '1234@references.lindsaar.net'
        message.reply_to.should      == ['mikel@reply-to.lindsaar.net']
        message.resent_bcc.should    == ['mikel@resent-bcc.lindsaar.net']
        message.resent_cc.should     == ['mikel@resent-cc.lindsaar.net']
        message.resent_date.should   == DateTime.parse('12 Aug 2009 00:00:03 GMT')
        message.resent_from.should   == ['mikel@resent-from.lindsaar.net']
        message.resent_message_id.should == '1234@resent_message_id.lindsaar.net'
        message.resent_sender.should == ['mikel@resent-sender.lindsaar.net']
        message.resent_to.should     == ['mikel@resent-to.lindsaar.net']
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == ['mikel@to.lindsaar.net']
        message.content_type.should              == 'text/plain; charset=UTF-8'
        message.content_transfer_encoding.should == '7bit'
        message.content_description.should       == 'This is a test'
        message.content_disposition.should       == 'attachment; filename=File'
        message.content_id.should                == '<1234@message_id.lindsaar.net>'
        message.mime_version.should              == '1.0'
        message.body.to_s.should          == 'This is a body of text'
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

        message.bcc.should           == ['mikel@bcc.lindsaar.net']
        message.cc.should            == ['mikel@cc.lindsaar.net']
        message.comments.should      == 'this is a comment'
        message.date.should          == DateTime.parse('12 Aug 2009 00:00:01 GMT')
        message.from.should          == ['mikel@from.lindsaar.net']
        message.in_reply_to.should   == '1234@in_reply_to.lindsaar.net'
        message.keywords.should      == ["test", "of the new mail", "system"]
        message.message_id.should    == '1234@message_id.lindsaar.net'
        message.received.date_time.should      == DateTime.parse('12 Aug 2009 00:00:02 GMT')
        message.references.should    == '1234@references.lindsaar.net'
        message.reply_to.should      == ['mikel@reply-to.lindsaar.net']
        message.resent_bcc.should    == ['mikel@resent-bcc.lindsaar.net']
        message.resent_cc.should     == ['mikel@resent-cc.lindsaar.net']
        message.resent_date.should   == DateTime.parse('12 Aug 2009 00:00:03 GMT')
        message.resent_from.should   == ['mikel@resent-from.lindsaar.net']
        message.resent_message_id.should == '1234@resent_message_id.lindsaar.net'
        message.resent_sender.should == ['mikel@resent-sender.lindsaar.net']
        message.resent_to.should     == ['mikel@resent-to.lindsaar.net']
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == ['mikel@to.lindsaar.net']
        message.content_type.should              == 'text/plain; charset=UTF-8'
        message.content_transfer_encoding.should == '7bit'
        message.content_description.should       == 'This is a test'
        message.content_disposition.should       == 'attachment; filename=File'
        message.content_id.should                == '<1234@message_id.lindsaar.net>'
        message.mime_version.should              == '1.0'
        message.body.to_s.should          == 'This is a body of text'
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

        message.bcc.should           == ['mikel@bcc.lindsaar.net']
        message.cc.should            == ['mikel@cc.lindsaar.net']
        message.comments.should      == 'this is a comment'
        message.date.should          == DateTime.parse('12 Aug 2009 00:00:01 GMT')
        message.from.should          == ['mikel@from.lindsaar.net']
        message.in_reply_to.should   == '1234@in_reply_to.lindsaar.net'
        message.keywords.should      == ["test", "of the new mail", "system"]
        message.message_id.should    == '1234@message_id.lindsaar.net'
        message.received.date_time.should      == DateTime.parse('12 Aug 2009 00:00:02 GMT')
        message.references.should    == '1234@references.lindsaar.net'
        message.reply_to.should      == ['mikel@reply-to.lindsaar.net']
        message.resent_bcc.should    == ['mikel@resent-bcc.lindsaar.net']
        message.resent_cc.should     == ['mikel@resent-cc.lindsaar.net']
        message.resent_date.should   == DateTime.parse('12 Aug 2009 00:00:03 GMT')
        message.resent_from.should   == ['mikel@resent-from.lindsaar.net']
        message.resent_message_id.should == '1234@resent_message_id.lindsaar.net'
        message.resent_sender.should == ['mikel@resent-sender.lindsaar.net']
        message.resent_to.should     == ['mikel@resent-to.lindsaar.net']
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == ['mikel@to.lindsaar.net']
        message.content_type.should              == 'text/plain; charset=UTF-8'
        message.content_transfer_encoding.should == '7bit'
        message.content_description.should       == 'This is a test'
        message.content_disposition.should       == 'attachment; filename=File'
        message.content_id.should                == '<1234@message_id.lindsaar.net>'
        message.mime_version.should              == '1.0'
        message.body.to_s.should          == 'This is a body of text'
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

        message.bcc.should           == ['mikel@bcc.lindsaar.net']
        message.cc.should            == ['mikel@cc.lindsaar.net']
        message.comments.should      == 'this is a comment'
        message.date.should          == DateTime.parse('12 Aug 2009 00:00:01 GMT')
        message.from.should          == ['mikel@from.lindsaar.net']
        message.in_reply_to.should   == '1234@in_reply_to.lindsaar.net'
        message.keywords.should      == ["test", "of the new mail", "system"]
        message.message_id.should    == '1234@message_id.lindsaar.net'
        message.received.date_time.should      == DateTime.parse('12 Aug 2009 00:00:02 GMT')
        message.references.should    == '1234@references.lindsaar.net'
        message.reply_to.should      == ['mikel@reply-to.lindsaar.net']
        message.resent_bcc.should    == ['mikel@resent-bcc.lindsaar.net']
        message.resent_cc.should     == ['mikel@resent-cc.lindsaar.net']
        message.resent_date.should   == DateTime.parse('12 Aug 2009 00:00:03 GMT')
        message.resent_from.should   == ['mikel@resent-from.lindsaar.net']
        message.resent_message_id.should == '1234@resent_message_id.lindsaar.net'
        message.resent_sender.should == ['mikel@resent-sender.lindsaar.net']
        message.resent_to.should     == ['mikel@resent-to.lindsaar.net']
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == ['mikel@to.lindsaar.net']
        message.content_type.should              == 'text/plain; charset=UTF-8'
        message.content_transfer_encoding.should == '7bit'
        message.content_description.should       == 'This is a test'
        message.content_disposition.should       == 'attachment; filename=File'
        message.content_id.should                == '<1234@message_id.lindsaar.net>'
        message.mime_version.should              == '1.0'
        message.body.to_s.should          == 'This is a body of text'
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

        message.bcc.should           == ['mikel@bcc.lindsaar.net']
        message.cc.should            == ['mikel@cc.lindsaar.net']
        message.comments.should      == 'this is a comment'
        message.date.should          == DateTime.parse('12 Aug 2009 00:00:01 GMT')
        message.from.should          == ['mikel@from.lindsaar.net']
        message.in_reply_to.should   == '1234@in_reply_to.lindsaar.net'
        message.keywords.should      == ["test", "of the new mail", "system"]
        message.message_id.should    == '1234@message_id.lindsaar.net'
        message.received.date_time.should      == DateTime.parse('12 Aug 2009 00:00:02 GMT')
        message.references.should    == '1234@references.lindsaar.net'
        message.reply_to.should      == ['mikel@reply-to.lindsaar.net']
        message.resent_bcc.should    == ['mikel@resent-bcc.lindsaar.net']
        message.resent_cc.should     == ['mikel@resent-cc.lindsaar.net']
        message.resent_date.should   == DateTime.parse('12 Aug 2009 00:00:03 GMT')
        message.resent_from.should   == ['mikel@resent-from.lindsaar.net']
        message.resent_message_id.should == '1234@resent_message_id.lindsaar.net'
        message.resent_sender.should == ['mikel@resent-sender.lindsaar.net']
        message.resent_to.should     == ['mikel@resent-to.lindsaar.net']
        message.sender.should        == 'mikel@sender.lindsaar.net'
        message.subject.should       == 'Hello there Mikel'
        message.to.should            == ['mikel@to.lindsaar.net']
        message.content_type.should              == 'text/plain; charset=UTF-8'
        message.content_transfer_encoding.should == '7bit'
        message.content_description.should       == 'This is a test'
        message.content_disposition.should       == 'attachment; filename=File'
        message.content_id.should                == '<1234@message_id.lindsaar.net>'
        message.mime_version.should              == '1.0'
        message.body.to_s.should          == 'This is a body of text'
      end

      it "should let you set custom headers with a :headers => {hash}" do
        message = Mail.new(:headers => {'custom-header' => 'mikel'})
        message['custom-header'].decoded.should == 'mikel'
      end

      it "should assign the body to a part on creation" do
        message = Mail.new do
          part({:content_type=>"multipart/alternative", :content_disposition=>"inline", :body=>"Nothing to see here."})
        end
        message.parts.first.body.decoded.should == "Nothing to see here."
      end

      it "should not overwrite bodies on creation" do
        message = Mail.new do
          part({:content_type=>"multipart/alternative", :content_disposition=>"inline", :body=>"Nothing to see here."}) do |p|
            p.part :content_type => "text/html", :body => "<b>test</b> HTML<br/>"
          end
        end
        message.parts.first.parts[0].body.decoded.should == "Nothing to see here."
        message.parts.first.parts[1].body.decoded.should == "<b>test</b> HTML<br/>"
        message.encoded.should match %r{Nothing to see here\.}
        message.encoded.should match %r{<b>test</b> HTML<br/>}
      end

      it "should allow you to init on an array of addresses from a hash" do
        mail = Mail.new(:to => ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>'])
        mail.to.should == ['test1@lindsaar.net', 'test2@lindsaar.net']
      end

      it "should allow you to init on an array of addresses directly" do
        mail = Mail.new
        mail.to = ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>']
        mail.to.should == ['test1@lindsaar.net', 'test2@lindsaar.net']
      end

      it "should allow you to init on an array of addresses directly" do
        mail = Mail.new
        mail[:to] = ['test1@lindsaar.net', 'Mikel <test2@lindsaar.net>']
        mail.to.should == ['test1@lindsaar.net', 'test2@lindsaar.net']
      end

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
          mail.should_not be_has_message_id
        end

        it "should preserve any message id that you pass it if add_message_id is called explicitly" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_message_id("<ThisIsANonUniqueMessageId@me.com>")
          mail.to_s.should =~ /Message-ID: <ThisIsANonUniqueMessageId@me.com>\r\n/
        end

        it "should generate a random message ID if nothing is passed to add_message_id" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_message_id
          fqdn ||= ::Socket.gethostname
          mail.to_s.should =~ /Message-ID: <[\w]+@#{fqdn}.mail>\r\n/
        end

        it "should make an email and inject a message ID if none was set if told to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          (mail.to_s =~ /Message-ID: <.+@.+.mail>/i).should_not be_nil
        end

        it "should add the message id to the message permanently once sent to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s
          mail.should be_has_message_id
        end

        it "should add a body part if it is missing" do
          mail = Mail.new
          mail.to_s
          mail.body.class.should == Mail::Body
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
          mail.should_not be_has_date
        end

        it "should preserve any date that you pass it if add_date is called explicitly" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_date("Mon, 24 Nov 1997 14:22:01 -0800")
          mail.to_s.should =~ /Date: Mon, 24 Nov 1997 14:22:01 -0800/
        end

        it "should generate a current date if nothing is passed to add_date" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_date
          mail.to_s.should =~ /Date: \w{3}, [\s\d]\d \w{3} \d{4} \d{2}:\d{2}:\d{2} [-+]?\d{4}\r\n/
        end

        it "should make an email and inject a date if none was set if told to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s.should =~ /Date: \w{3}, [\s\d]\d \w{3} \d{4} \d{2}:\d{2}:\d{2} [-+]?\d{4}\r\n/
        end

        it "should add the date to the message permanently once sent to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s
          mail.should be_has_date
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
          mail.should_not be_has_mime_version
        end

        it "should preserve any mime version that you pass it if add_mime_version is called explicitly" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_mime_version("3.0 (This is an unreal version number)")
          mail.to_s.should =~ /Mime-Version: 3.0\r\n/
        end

        it "should generate a mime version if nothing is passed to add_date" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.add_mime_version
          mail.to_s.should =~ /Mime-Version: 1.0\r\n/
        end

        it "should make an email and inject a mime_version if none was set if told to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s.should =~ /Mime-Version: 1.0\r\n/
        end

        it "should add the mime version to the message permanently once sent to_s" do
          mail = Mail.new do
               from 'mikel@test.lindsaar.net'
                 to 'you@test.lindsaar.net'
            subject 'This is a test email'
               body 'This is a body of the email'
          end
          mail.to_s
          mail.should be_has_mime_version
        end
      end

      describe "content type" do

        it "should say if it has a content type" do
          mail = Mail.new('Content-Type: text/plain')
          mail.should be_has_content_type
        end

        it "should say if it does not have a content type" do
          mail = Mail.new
          mail.should_not be_has_content_type
        end

        it "should say if it has a charset" do
          mail = Mail.new('Content-Type: text/plain; charset=US-ASCII')
          mail.should be_has_charset
        end

        it "should say if it has a charset" do
          mail = Mail.new('Content-Type: text/plain')
          mail.should_not be_has_charset
        end

        it "should not raise a warning if there is no charset defined and only US-ASCII chars" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          STDERR.should_not_receive(:puts)
          mail.to_s
        end

        it "should set the content type to text/plain; charset=us-ascii" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          mail.to_s =~ %r{Content-Type: text/plain; charset=US-ASCII}
        end

        it "should not set the charset if the file is an attachment" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          mail.content_disposition = 'attachment; filename="foo.jpg"'
          mail.to_s =~ %r{Content-Type: text/plain;\r\n}
        end

        it "should raise a warning if there is no content type and there is non ascii chars and default to text/plain, UTF-8" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_transfer_encoding = "8bit"
          STDERR.should_receive(:puts).with(/Non US-ASCII detected and no charset defined.\nDefaulting to UTF-8, set your own if this is incorrect./m)
          mail.to_s =~ %r{Content-Type: text/plain; charset=UTF-8}
        end

        it "should raise a warning if there is no charset parameter and there is non ascii chars and default to text/plain, UTF-8" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_type = "text/plain"
          mail.content_transfer_encoding = "8bit"
          STDERR.should_receive(:puts).with(/Non US-ASCII detected and no charset defined.\nDefaulting to UTF-8, set your own if this is incorrect./m)
          mail.to_s =~ %r{Content-Type: text/plain; charset=UTF-8}
        end

        it "should not raise a warning if there is a charset defined and there is non ascii chars" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.body = body
          mail.content_transfer_encoding = "8bit"
          mail.content_type = "text/plain; charset=UTF-8"
          STDERR.should_not_receive(:puts)
          mail.to_s
        end

        it "should be able to set a content type with an array and hash" do
          mail = Mail.new
          mail.content_type = ["text", "plain", { :charset => 'US-ASCII' }]
          mail[:content_type].encoded.should == %Q[Content-Type: text/plain;\r\n\scharset=US-ASCII\r\n]
          mail.content_type_parameters.should == {"charset" => "US-ASCII"}
        end

        it "should be able to set a content type with an array and hash with a non-usascii field" do
          mail = Mail.new
          mail.content_type = ["text", "plain", { :charset => 'UTF-8' }]
          mail[:content_type].encoded.should == %Q[Content-Type: text/plain;\r\n\scharset=UTF-8\r\n]
          mail.content_type_parameters.should == {"charset" => "UTF-8"}
        end

        it "should allow us to specify a content type in a block" do
          mail = Mail.new { content_type ["text", "plain", { "charset" => "UTF-8" }] }
          mail.content_type_parameters.should == {"charset" => "UTF-8"}
        end

      end

      describe "content-transfer-encoding" do

        it "should use 7bit for only US-ASCII chars" do
          body = "This is plain text US-ASCII"
          mail = Mail.new
          mail.body = body
          mail.to_s.should =~ %r{Content-Transfer-Encoding: 7bit}
        end

        it "should use QP transfer encoding for 8bit text with only a few 8bit characters" do
          body = "Maxfeldstraße 5, 90409 Nürnberg"
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          mail.to_s.should =~ %r{Content-Transfer-Encoding: quoted-printable}
        end

        it "should use base64 transfer encoding for 8-bit text with lots of 8bit characters" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          mail.content_type = "text/plain; charset=utf-8"
          mail.should be_has_content_type
          mail.should be_has_charset
          mail.to_s.should =~  %r{Content-Transfer-Encoding: base64}
        end

        it "should not use 8bit transfer encoding when 8bit is allowed" do
          body = "This is NOT plain text ASCII　− かきくけこ"
          mail = Mail.new
          mail.charset = "UTF-8"
          mail.body = body
          mail.content_type = "text/plain; charset=utf-8"
          mail.transport_encoding = "8bit"
          mail.to_s.should =~ %r{Content-Transfer-Encoding: 8bit}
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

      mail.to_s.should =~ /From: mikel@test.lindsaar.net\r\n/
      mail.to_s.should =~ /To: you@test.lindsaar.net\r\n/
      mail.to_s.should =~ /Subject: This is a test email\r\n/
      mail.to_s.should =~ /This is a body of the email/

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
      doing { mail.decoded }.should raise_error(NoMethodError, 'Can not decode an entire message, try calling #decoded on the various fields and body or parts if it is a multipart message.')
    end

    it "should return the decoded body if you call decode and the message is not multipart" do
      mail = Mail.new do
        content_transfer_encoding 'base64'
        body "VGhlIGJvZHk=\n"
      end
      mail.decoded.should == "The body"
    end

    describe "decoding bodies" do

      it "should not change a body on decode if not given an encoding type to decode" do
        mail = Mail.new do
          body "The=3Dbody"
        end
        mail.body.decoded.should == "The=3Dbody"
        mail.body.encoded.should == "The=3Dbody"
      end

      it "should change a body on decode if given an encoding type to decode" do
        mail = Mail.new do
          content_transfer_encoding 'quoted-printable'
          body "The=3Dbody"
        end
        mail.body.decoded.should == "The=body"
        mail.body.encoded.should == "The=3Dbody=\r\n"
      end

      it "should change a body on decode if given an encoding type to decode" do
        mail = Mail.new do
          content_transfer_encoding 'base64'
          body "VGhlIGJvZHk=\n"
        end
        mail.body.decoded.should == "The body"
        mail.body.encoded.should == "VGhlIGJvZHk=\r\n"
      end

    end

  end

  describe "helper methods" do

    describe "==" do
      it "should be implemented" do
        doing { Mail.new == Mail.new }.should_not raise_error
      end

      it "should ignore the message id value if both have a nil message id" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m1.should == m2
      end

      it "should ignore the message id value if self has a nil message id" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m1.should == m2
      end

      it "should ignore the message id value if other has a nil message id" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m1.should == m2
      end

      it "should not be == if both emails have different Message IDs" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <4321@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m1.should_not == m2
      end

      it "should preserve the message id of self if set" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m1 == m2
        m1.message_id.should == '1234@test.lindsaar.net'
      end

      it "should preserve the message id of other if set" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m1 == m2
        m2.message_id.should == '1234@test.lindsaar.net'
      end

      it "should preserve the message id of both if set" do
        m1 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <4321@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m2 = Mail.new("To: mikel@test.lindsaar.net\r\nMessage-ID: <1234@test.lindsaar.net>\r\nSubject: Yo!\r\n\r\nHello there")
        m1 == m2
        m1.message_id.should == '4321@test.lindsaar.net'
        m2.message_id.should == '1234@test.lindsaar.net'
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
      [mail2, mail1].sort.should == [mail2, mail1]
    end

    it "should have a destinations method" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
        cc 'bob@test.lindsaar.net'
        bcc 'sam@test.lindsaar.net'
      end
      mail.destinations.length.should == 3
    end

    it "should have a from_addrs method" do
      mail = Mail.new do
        from 'mikel@test.lindsaar.net'
      end
      mail.from_addrs.length.should == 1
    end

    it "should have a from_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      mail.from_addrs.length.should == 0
    end

    it "should have a to_addrs method" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
      end
      mail.to_addrs.length.should == 1
    end

    it "should have a to_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      mail.to_addrs.length.should == 0
    end

    it "should have a cc_addrs method" do
      mail = Mail.new do
        cc 'bob@test.lindsaar.net'
      end
      mail.cc_addrs.length.should == 1
    end

    it "should have a cc_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      mail.cc_addrs.length.should == 0
    end

    it "should have a bcc_addrs method" do
      mail = Mail.new do
        bcc 'sam@test.lindsaar.net'
      end
      mail.bcc_addrs.length.should == 1
    end

    it "should have a bcc_addrs method that is empty if nil" do
      mail = Mail.new do
      end
      mail.bcc_addrs.length.should == 0
    end

    it "should give destinations even if some of the fields are blank" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
      end
      mail.destinations.length.should == 1
    end

    it "should be able to encode with only one destination" do
      mail = Mail.new do
        to 'mikel@test.lindsaar.net'
      end
      mail.encoded
    end

  end

  describe "nested parts" do
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

      mail.parts.first.should be_multipart
      mail.parts.first.parts.length.should == 2
      mail.parts.first.parts[0][:content_type].string.should == "text/plain"
      mail.parts.first.parts[0].body.decoded.should == "test text\nline #2"
      mail.parts.first.parts[1][:content_type].string.should == "text/html"
      mail.parts.first.parts[1].body.decoded.should == "<b>test</b> HTML<br/>\nline #2"
    end
  end

  describe "deliver" do
    it "should return self after delivery" do
      mail = Mail.new
      mail.perform_deliveries = false
      mail.deliver.should == mail
    end

    class DeliveryAgent
      def self.deliver_mail(mail)
      end
    end

    it "should pass self to a delivery agent" do
      mail = Mail.new
      mail.delivery_handler = DeliveryAgent
      DeliveryAgent.should_receive(:deliver_mail).with(mail)
      mail.deliver
    end

    class ObserverAgent
      def self.delivered_email(mail)
      end
    end

    it "should inform observers that the mail was sent" do
      mail = Mail.new
      mail.delivery_method :test
      Mail.register_observer(ObserverAgent)
      ObserverAgent.should_receive(:delivered_email).with(mail)
      mail.deliver
    end

    it "should inform observers that the mail was sent, even if a delivery agent is used" do
      mail = Mail.new
      mail.delivery_handler = DeliveryAgent
      Mail.register_observer(ObserverAgent)
      ObserverAgent.should_receive(:delivered_email).with(mail)
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
      mail = Mail.new
      mail.delivery_method :test
      Mail.register_interceptor(InterceptorAgent)
      InterceptorAgent.should_receive(:delivering_email).with(mail)
      InterceptorAgent.intercept = true
      mail.deliver
      InterceptorAgent.intercept = false
    end

    it "should let the interceptor that the mail was sent" do
      mail = Mail.new
      mail.to = 'fred@example.com'
      mail.delivery_method :test
      Mail.register_interceptor(InterceptorAgent)
      InterceptorAgent.intercept = true
      mail.deliver
      InterceptorAgent.intercept = false
      mail.to.should == ['bob@example.com']
    end

  end

  describe "error handling" do
    it "should collect up any of its fields' errors" do
      mail = Mail.new("Content-Transfer-Encoding: vlad\r\nReply-To: a b b\r\n")
      mail.errors.should_not be_blank
      mail.errors.size.should == 2
      mail.errors[0][0].should == 'Content-Transfer-Encoding'
      mail.errors[0][1].should == 'vlad'
      mail.errors[1][0].should == 'Reply-To'
      mail.errors[1][1].should == 'a b b'
    end
  end

  describe "header case should be preserved" do
    it "should handle mail[] and keep the header case" do
      mail = Mail.new
      mail['X-Foo-Bar'] = "Some custom text"
      mail.to_s.should match(/X-Foo-Bar: Some custom text/)
    end
  end

  describe "parsing emails with non usascii in the header" do
    it "should work" do
      mail = Mail.new('From: "Foo áëô îü" <extended@example.net>')
      mail.from.should == ['extended@example.net']
      mail[:from].decoded.should == '"Foo áëô îü" <extended@example.net>'
      mail[:from].encoded.should == "From: =?UTF-8?B?Rm9vIMOhw6vDtCDDrsO8?= <extended@example.net>\r\n"
    end
  end

  describe "ordering messages" do
    it "should put all attachments as the last item" do
      # XXX: AFAICT, this is not actually working. The code does not appear to implement this. -- singpolyma
      mail = Mail.new
      mail.attachments['image.png'] = "\302\302\302\302"
      p = Mail::Part.new(:content_type => 'multipart/alternative')
      p.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
      p.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
      mail.add_part(p)
      mail.encoded
      mail.parts[0].mime_type.should == "multipart/alternative"
      mail.parts[0].parts[0].mime_type.should == "text/plain"
      mail.parts[0].parts[1].mime_type.should == "text/html"
      mail.parts[1].mime_type.should == "image/png"
    end
  end

  describe "attachment query methods" do
    it "shouldn't die with an invalid Content-Disposition header" do
      mail = Mail.new('Content-Disposition: invalid')
      doing { mail.attachment? }.should_not raise_error
    end

    it "shouldn't die with an invalid Content-Type header" do
      mail = Mail.new('Content-Type: invalid/invalid; charset="iso-8859-1"')
      mail.attachment?
      doing { mail.attachment? }.should_not raise_error
    end

  end

  describe "replying" do

    describe "to a basic message" do

      before do
        @mail = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'basic_email.eml')))
      end

      it "should create a new message" do
        @mail.reply.should be_a_kind_of(Mail::Message)
      end

      it "should be in-reply-to the original message" do
        @mail.reply.in_reply_to.should == '6B7EC235-5B17-4CA8-B2B8-39290DEB43A3@test.lindsaar.net'
      end

      it "should reference the original message" do
        @mail.reply.references.should == '6B7EC235-5B17-4CA8-B2B8-39290DEB43A3@test.lindsaar.net'
      end

      it "should RE: the original subject" do
        @mail.reply.subject.should == 'RE: Testing 123'
      end

      it "should be sent to the original sender" do
        @mail.reply.to.should == ['test@lindsaar.net']
        @mail.reply[:to].to_s.should == 'Mikel Lindsaar <test@lindsaar.net>'
      end

      it "should be sent from the original recipient" do
        @mail.reply.from.should == ['raasdnil@gmail.com']
        @mail.reply[:from].to_s.should == 'Mikel Lindsaar <raasdnil@gmail.com>'
      end

      it "should accept args" do
        @mail.reply(:from => 'Donald Ball <donald.ball@gmail.com>').from.should == ['donald.ball@gmail.com']
      end

      it "should accept a block" do
        @mail.reply { from('Donald Ball <donald.ball@gmail.com>') }.from.should == ['donald.ball@gmail.com']
      end

    end

    describe "to a message with an explicit reply-to address" do

      before do
        @mail = Mail::Message.new(File.read(fixture('emails', 'rfc2822', 'example06.eml')))
      end

      it "should be sent to the reply-to address" do
        @mail.reply[:to].to_s.should == '"Mary Smith: Personal Account" <smith@home.example>'
      end

    end

    describe "to a message with more than one recipient" do

      before do
        @mail = Mail::Message.new(File.read(fixture('emails', 'rfc2822', 'example03.eml')))
      end

      it "should be sent from the first to address" do
        @mail.reply[:from].to_s.should == 'Mary Smith <mary@x.test>'
      end

    end

    describe "to a reply" do

      before do
        @mail = Mail::Message.new(File.read(fixture('emails', 'plain_emails', 'raw_email_reply.eml')))
      end

      it "should be in-reply-to the original message" do
        @mail.reply.in_reply_to.should == '473FFE27.20003@xxx.org'
      end

      it "should append to the original's references list" do
        @mail.reply[:references].message_ids.should == ['473FF3B8.9020707@xxx.org', '348F04F142D69C21-291E56D292BC@xxxx.net', '473FFE27.20003@xxx.org']
      end

      it "should not append another RE:" do
        @mail.reply.subject.should == "Re: Test reply email"
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
        @mail.reply[:references].message_ids.should == ['1234@test.lindsaar.net', '5678@test.lindsaar.net']
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
        @mail.references.should be_nil
      end

    end

  end

end
