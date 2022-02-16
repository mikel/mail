# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

describe "MIME Emails" do

    describe "general helper methods" do

      it "should read a mime version from an email" do
        mail = Mail.new("Mime-Version: 1.0")
        expect(mail.mime_version).to eq '1.0'
      end

      it "should return nil if the email has no mime version" do
        mail = Mail.new("To: bob")
        expect(mail.mime_version).to be_nil
      end

      it "should read the content-transfer-encoding" do
        mail = Mail.new("Content-Transfer-Encoding: quoted-printable")
        expect(mail.content_transfer_encoding).to eq 'quoted-printable'
      end

      it "should read the content-description" do
        mail = Mail.new("Content-Description: This is a description")
        expect(mail.content_description).to eq 'This is a description'
      end

      it "should return the content-type" do
        mail = Mail.new("Content-Type: text/plain")
        expect(mail.mime_type).to eq 'text/plain'
      end

      it "should return the charset" do
        mail = Mail.new("Content-Type: text/plain; charset=utf-8")
        expect(mail.charset).to eq 'utf-8'
      end

      it "should allow you to set the charset" do
        mail = Mail.new
        mail.charset = 'utf-8'
        expect(mail.charset).to eq 'utf-8'
      end

      it "should return the main content-type" do
        mail = Mail.new("Content-Type: text/plain")
        expect(mail.main_type).to eq 'text'
      end

      it "should return the sub content-type" do
        mail = Mail.new("Content-Type: text/plain")
        expect(mail.sub_type).to eq 'plain'
      end

      it "should return the content-type parameters" do
        mail = Mail.new("Content-Type: text/plain; charset=US-ASCII; format=flowed")
        expect(mail.content_type_parameters).to eql({"charset" => 'US-ASCII', "format" => 'flowed'})
      end

      describe 'a multipart email (raw_email7.eml)' do
        let(:mail) { read_fixture('emails', 'mime_emails', 'raw_email7.eml') }
        it "should recognize a multipart email" do
          expect(mail).to be_multipart
        end

        it "inspect_structure should return what is expected" do
          expect(mail.inspect_structure).to eq <<-End.chomp
#{mail.inspect}
1. #{mail.parts[0].inspect}
1.1. #{mail.parts[0].parts[0].inspect}
1.2. #{mail.parts[0].parts[1].inspect}
1.3. #{mail.parts[0].parts[2].inspect}
1.4. #{mail.parts[0].parts[3].inspect}
2. #{mail.parts[1].inspect}
          End
        end
      end

      it "should recognize a non multipart email" do
        mail = read_fixture('emails', 'plain_emails', 'basic_email.eml')
        expect(mail).not_to be_multipart
      end

      it "should not report the email as :attachment?" do
        mail = read_fixture('emails', 'attachment_emails', 'attachment_pdf.eml')
        expect(mail.attachment?).to eq false
      end

      describe 'attachment_only_email.eml' do
        let(:mail) { read_fixture('emails', 'attachment_emails', 'attachment_only_email.eml') }
        it "should report the email as :attachment?" do
          expect(mail.attachment?).to eq true
        end
        it "inspect_structure should return what is expected" do
          expect(mail.inspect_structure).to eq mail.inspect
        end
      end

      it "should recognize an attachment part" do
        mail = read_fixture('emails', 'attachment_emails', 'attachment_pdf.eml')
        expect(mail).not_to be_attachment
        expect(mail.parts[0].attachment?).to eq false
        expect(mail.parts[1].attachment?).to eq true
      end

      it "should give how may (top level) parts there are" do
        mail = read_fixture('emails', 'mime_emails', 'raw_email7.eml')
        expect(mail.parts.length).to eq 2
      end

      describe 'a multipart/alternative mail (raw_email11.eml)' do
        let(:mail) { read_fixture('emails', 'mime_emails', 'raw_email11.eml') }
        it "should give the content_type of each part" do
          expect(mail.mime_type).to eq 'multipart/alternative'
          expect(mail.parts[0].mime_type).to eq 'text/plain'
          expect(mail.parts[1].mime_type).to eq 'text/enriched'
        end
        it "inspect_structure should return what is expected" do
          expect(mail.inspect_structure).to eq <<-End.chomp
#{mail.inspect}
1. #{mail.parts[0].inspect}
2. #{mail.parts[1].inspect}
          End
        end
      end

      it "should report the mail :has_attachments?" do
        mail = read_fixture('emails', 'attachment_emails', 'attachment_pdf.eml')
        expect(mail).to be_has_attachments
      end

      it "should only split on exact boundary matches" do
        mail = read_fixture('emails', 'mime_emails', 'email_with_similar_boundaries.eml')
        expect(mail.parts.size).to eq 2
        expect(mail.parts.first.parts.size).to eq 2
        expect(mail.boundary).to eq "----=_NextPart_476c4fde88e507bb8028170e8cf47c73"
        expect(mail.parts.first.boundary).to eq "----=_NextPart_476c4fde88e507bb8028170e8cf47c73_alt"
      end
    end

    describe "multipart emails" do
      it "should add a boundary if there is none defined and a part is added" do
        mail = Mail.new do
          part('This is a part')
          part('This is another part')
        end
        expect(mail.boundary).not_to be_nil
      end

      it "should not add a boundary for a message that is only an attachment" do
        mail = Mail.new
        mail.attachments['test.png'] = "2938492384923849"
        expect(mail.boundary).to be_nil
      end
    end

    describe "multipart/alternative emails" do

      it "should know what its boundary is if it is a multipart document" do
        mail = Mail.new('Content-Type: multipart/mixed; boundary="--==Boundary"')
        expect(mail.boundary).to eq "--==Boundary"
      end

      it "should return nil if there is no content-type defined" do
        mail = Mail.new
        expect(mail.boundary).to be_nil
      end

      it "should assign the text part and allow you to reference" do
        mail = Mail.new
        text_mail = Mail.new("This is Text")
        mail.text_part = text_mail
        expect(mail.text_part).to eq text_mail
      end

      it "should convert strings assigned to the text part into Mail::Part objects with sensible defaults" do
        mail = Mail.new
        mail.text_part = 'This is text'
        expect(mail.text_part.body).to eq 'This is text'
        expect(mail.text_part.content_type).to eq 'text/plain'
      end

      it "should not assign a nil text part" do
        mail = Mail.new
        mail.text_part = nil
        expect(mail.text_part).to be_nil
      end

      it "should assign the html part and allow you to reference" do
        mail = Mail.new
        html_mail = Mail.new("<b>This is HTML</b>")
        mail.html_part = html_mail
        expect(mail.html_part).to eq html_mail
      end

      it "should convert strings assigned to the html part into Mail::Part objects with sensible defaults" do
        mail = Mail.new
        mail.html_part = "<b>This is HTML</b>"
        expect(mail.html_part.body).to eq "<b>This is HTML</b>"
        expect(mail.html_part.content_type).to eq "text/html"
      end

      it "should not assign a nil html part" do
        mail = Mail.new
        mail.html_part = nil
        expect(mail.html_part).to be_nil
      end

      it "should set default content type on assigned text and html parts" do
        mail = Mail.new
        mail.text_part = Mail.new
        expect(mail.text_part.content_type).to eq 'text/plain'
        mail.html_part = Mail.new
        expect(mail.html_part.content_type).to eq 'text/html'
      end

      it "should set default content type on declared text and html parts" do
        mail = Mail.new
        mail.text_part { }
        expect(mail.text_part.content_type).to eq 'text/plain'
        mail.html_part { }
        expect(mail.html_part.content_type).to eq 'text/html'
      end

      it "should not override content type" do
        mail = Mail.new
        mail.text_part { content_type 'text/plain+foo' }
        expect(mail.text_part.content_type).to eq 'text/plain+foo'
        mail.html_part { content_type 'text/html+foo' }
        expect(mail.html_part.content_type).to eq 'text/html+foo'
      end

      it "should add the html part and text part" do
        mail = Mail.new
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        expect(mail.parts.length).to eq 2
        expect(mail.parts.first.class).to eq Mail::Part
        expect(mail.parts.last.class).to eq Mail::Part
      end

      it "should remove the html part and back out of multipart/alternative if set to nil" do
        mail = Mail.new
        mail.text_part = Mail::Part.new
        mail.html_part = Mail::Part.new
        expect(mail.parts.length).to eq 2

        mail.html_part = nil
        expect(mail.parts.length).to eq 1
        expect(mail.boundary).to be_nil
        expect(mail.content_type).to be_nil
      end

      it "should remove the text part and back out of multipart/alternative if set to nil" do
        mail = Mail.new
        mail.text_part = Mail::Part.new
        mail.html_part = Mail::Part.new
        expect(mail.parts.length).to eq 2

        mail.text_part = nil
        expect(mail.parts.length).to eq 1
        expect(mail.boundary).to be_nil
        expect(mail.content_type).to be_nil
      end

      it "should set the content type to multipart/alternative if you assign html and text parts" do
        mail = Mail.new
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        expect(mail.to_s).to match(%r|Content-Type: multipart/alternative;\s+boundary="#{mail.boundary}"|)
      end

      it "should set the content type to multipart/alternative if you declare html and text parts" do
        mail = Mail.new
        mail.text_part { }
        mail.html_part { }
        expect(mail.to_s).to match(%r|Content-Type: multipart/alternative;\s+boundary="#{mail.boundary}"|)
      end

      it "should not set the content type to multipart/alternative if you declare an html part but not a text part" do
        mail = Mail.new
        mail.html_part { }
        expect(mail.to_s).not_to match(%r|Content-Type: multipart/alternative;\s+boundary="#{mail.boundary}"|)
      end

      it "should not set the content type to multipart/alternative if you declare a text part but not an html part" do
        mail = Mail.new
        mail.text_part { }
        expect(mail.to_s).not_to match(%r|Content-Type: multipart/alternative;\s+boundary="#{mail.boundary}"|)
      end

      it "should add the end boundary tag" do
        mail = Mail.new
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        expect(mail.to_s).to match(%r|#{mail.boundary}--|)
      end

      it "should not put message-ids into parts" do
        mail = Mail.new('Subject: FooBar')
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        mail.to_s
        expect(mail.parts.first.message_id).to be_nil
        expect(mail.parts.last.message_id).to be_nil
      end

      it "should create a multipart/alternative email through a block" do
        mail = Mail.new do
          to 'nicolas.fouche@gmail.com'
          from 'Mikel Lindsaar <raasdnil@gmail.com>'
          subject 'First multipart email sent with Mail'
          text_part do
            body 'This is plain text'
          end
          html_part do
            content_type 'text/html; charset=UTF-8'
            body '<h1>This is HTML</h1>'
          end
        end
        expect(mail).to be_multipart
        expect(mail.parts.length).to eq 2
        expect(mail.text_part.class).to eq Mail::Part
        expect(mail.text_part.body.to_s).to eq 'This is plain text'
        expect(mail.html_part.class).to eq Mail::Part
        expect(mail.html_part.body.to_s).to eq '<h1>This is HTML</h1>'
      end

      it "should detect an html_part in an existing email" do
        m = Mail.new(:content_type => 'multipart/alternative')
        m.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        m.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        expect(m.text_part.body.decoded).to eq 'PLAIN TEXT'
        expect(m.html_part.body.decoded).to eq 'HTML TEXT'
      end

      it "should detect a text_part in an existing email with plain text attachment" do
        m = Mail.new(:content_type => 'multipart/alternative')
        m.add_file(fixture_path('attachments', 'てすと.txt'))
        m.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        m.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        expect(m.text_part.body.decoded).to eq 'PLAIN TEXT'
        expect(m.html_part.body.decoded).to eq 'HTML TEXT'
      end

      it "should detect an html_part in a multi level mime email" do
        m = Mail.new(:content_type => 'multipart/mixed')
        a = Mail::Part.new(:content_type => 'text/script', :body => '12345')
        p = Mail::Part.new(:content_type => 'multipart/alternative')
        p.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        p.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        m.add_part(p)
        m.add_part(a)
        expect(m.text_part.body.decoded).to eq 'PLAIN TEXT'
        expect(m.html_part.body.decoded).to eq 'HTML TEXT'
      end

      it "should only the first part on a stupidly overly complex email" do
        m = Mail.new(:content_type => 'multipart/mixed')
        a = Mail::Part.new(:content_type => 'text/script', :body => '12345')
        m.add_part(a)

        b = Mail::Part.new(:content_type => 'multipart/alternative')
        b.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        b.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        m.add_part(b)

        c = Mail::Part.new(:content_type => 'multipart/alternative')
        c.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML 2 TEXT'))
        c.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN 2 TEXT'))
        b.add_part(c)

        d = Mail::Part.new(:content_type => 'multipart/alternative')
        d.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML 3 TEXT'))
        d.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN 3 TEXT'))
        b.add_part(d)

        expect(m.text_part.body.decoded).to eq 'PLAIN TEXT'
        expect(m.html_part.body.decoded).to eq 'HTML TEXT'
      end

    end

    describe "finding attachments" do

      it "should return an array of attachments" do
        mail = read_fixture('emails', 'attachment_emails', 'attachment_content_disposition.eml')
        expect(mail.attachments.length).to eq 1
        expect(mail.attachments.first.filename).to eq 'api.rb'
      end

      it "should return an array of attachments" do
        mail = read_fixture('emails', 'mime_emails', 'raw_email_with_nested_attachment.eml')
        expect(mail.attachments.length).to eq 2
        expect(mail.attachments[0].filename).to eq 'truncated.png'
        expect(mail.attachments[1].filename).to eq 'smime.p7s'
      end

      Dir.glob(fixture_path('attachments', "test.*")).each do |test_attachment|
        it "should find binary encoded attachments of type #{File.extname(test_attachment)}" do
          pre, post = read_raw_fixture('emails', 'mime_emails', 'raw_email_with_binary_encoded.eml').split('BINARY_CONTENT_GOES_HERE')
          raw_file  = File.open(test_attachment, "rb", &:read)

          raw_mail = pre + raw_file + post
          expect(raw_mail.encoding).to eq(Encoding::ASCII_8BIT) if raw_mail.respond_to?(:encoding)

          mail = Mail.new(raw_mail)

          expect(mail.attachments.size).to eq 1
          expect(mail.attachments.first.decoded.bytesize).to eq raw_file.bytesize
          expect(mail.attachments.first.decoded).to eq raw_file
        end
      end
    end

    describe "adding a file attachment" do

      it "should set to multipart/mixed if a text part and you add an attachment" do
        mail = Mail::Message.new
        mail.text_part { body("log message goes here") }
        mail.add_file(fixture_path('attachments', 'test.png'))
        expect(mail.mime_type).to eq 'multipart/mixed'
      end

      it "should set to multipart/mixed if you add an attachment and then a text part" do
        mail = Mail::Message.new
        mail.add_file(fixture_path('attachments', 'test.png'))
        mail.text_part { body("log message goes here") }
        expect(mail.mime_type).to eq 'multipart/mixed'
      end

      it "should add a part given a filename" do
        mail = Mail::Message.new
        mail.add_file(fixture_path('attachments', 'test.png'))
        expect(mail.parts.length).to eq 1 # First part is an empty text body
      end

      it "should give the part the right content type" do
        mail = Mail::Message.new
        mail.add_file(fixture_path('attachments', 'test.png'))
        expect(mail.parts.first[:content_type].content_type).to eq 'image/png'
      end

      it "should return attachment objects" do
        mail = Mail::Message.new
        mail.add_file(fixture_path('attachments', 'test.png'))
        expect(mail.attachments.first.class).to eq Mail::Part
      end

      it "should be return an aray of attachments" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture_path('attachments', 'test.png')
          add_file fixture_path('attachments', 'test.jpg')
          add_file fixture_path('attachments', 'test.pdf')
          add_file fixture_path('attachments', 'test.zip')
        end
        expect(mail.attachments.length).to eq 4
        mail.attachments.each { |a| expect(a.class).to eq Mail::Part }
      end

      it "should return the filename of each attachment" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture_path('attachments', 'test.png')
          add_file fixture_path('attachments', 'test.jpg')
          add_file fixture_path('attachments', 'test.pdf')
          add_file fixture_path('attachments', 'test.zip')
        end
        expect(mail.attachments[0].filename).to eq 'test.png'
        expect(mail.attachments[1].filename).to eq 'test.jpg'
        expect(mail.attachments[2].filename).to eq 'test.pdf'
        expect(mail.attachments[3].filename).to eq 'test.zip'
      end

      it "should return the type/subtype of each attachment" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture_path('attachments', 'test.png')
          add_file fixture_path('attachments', 'test.jpg')
          add_file fixture_path('attachments', 'test.pdf')
          add_file fixture_path('attachments', 'test.zip')
        end
        expect(mail.attachments[0].mime_type).to eq 'image/png'
        expect(mail.attachments[1].mime_type).to eq 'image/jpeg'
        expect(mail.attachments[2].mime_type).to eq 'application/pdf'
        expect(mail.attachments[3].mime_type).to eq 'application/zip'
      end

      it "should return the content of each attachment" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture_path('attachments', 'test.png')
          add_file fixture_path('attachments', 'test.jpg')
          add_file fixture_path('attachments', 'test.pdf')
          add_file fixture_path('attachments', 'test.zip')
        end

        tripped = mail.attachments[0].decoded
        original = read_raw_fixture('attachments', 'test.png')
        expect(tripped).to eq original
        tripped = mail.attachments[1].decoded
        original = read_raw_fixture('attachments', 'test.jpg')
        expect(tripped).to eq original
        tripped = mail.attachments[2].decoded
        original = read_raw_fixture('attachments', 'test.pdf')
        expect(tripped).to eq original
        tripped = mail.attachments[3].decoded
        original = read_raw_fixture('attachments', 'test.zip')
        expect(tripped).to eq original
      end

      it "should allow you to send in file data instead of having to read it" do
        file_data = read_raw_fixture('attachments', 'test.png')
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file(:filename => 'test.png', :content => file_data)
        end

        tripped = mail.attachments[0].decoded
        original = read_raw_fixture('attachments', 'test.png')
        expect(tripped).to eq original
      end

      it "should support :mime_type option" do
        mail = Mail::Message.new
        mail.add_file(:filename => 'test.png', :content => 'a', :mime_type=>'text/plain')
        expect(mail.attachments.first.content_type).to eq 'text/plain'
      end

      it "should be able to add a body before adding a file" do
        m = Mail.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          body    "Attached"
          add_file fixture_path('attachments', 'test.png')
        end
        expect(m.attachments.length).to eq 1
        expect(m.parts.length).to eq 2
        expect(m.parts[0].body).to eq "Attached"
        expect(m.parts[1].filename).to eq "test.png"
      end

      it "should allow you to add a body as text part if you have added a file" do
        m = Mail.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture_path('attachments', 'test.png')
          body    "Attached"
        end
        expect(m.parts.length).to eq 2
        expect(m.parts.first[:content_type].content_type).to eq 'image/png'
        expect(m.parts.last[:content_type].content_type).to eq 'text/plain'
      end

      it "should allow you to add a body as text part if you have added a file and not truncate after newlines - issue 208" do
        m = Mail.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture_path('attachments', 'test.png')
          body    "First Line\n\nSecond Line\n\nThird Line\n\n"
          #Note: trailing \n\n is stripped off by Mail::Part initialization
        end
        expect(m.parts.length).to eq 2
        expect(m.parts.first[:content_type].content_type).to eq 'image/png'
        expect(m.parts.last[:content_type].content_type).to eq 'text/plain'
        expect(m.parts.last.to_s).to match(/^First Line\r\n\r\nSecond Line\r\n\r\nThird Line/)
      end

      it "should not raise a warning if there is a charset defined and there are non ascii chars in the body" do
        body = "This is NOT plain text ASCII　− かきくけこ"
        mail = Mail.new
        mail.body = body
        mail.charset = 'UTF-8'
        mail.add_file fixture_path('attachments', 'test.png')
        expect { mail.to_s }.to_not output.to_stderr
      end


    end

end
