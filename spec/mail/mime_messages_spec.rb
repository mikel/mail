# encoding: utf-8
require 'spec_helper'

describe "MIME Emails" do

    describe "general helper methods" do

      it "should read a mime version from an email" do
        mail = Mail.new("Mime-Version: 1.0")
        mail.mime_version.should == '1.0'
      end

      it "should return nil if the email has no mime version" do
        mail = Mail.new("To: bob")
        mail.mime_version.should == nil
      end

      it "should read the content-transfer-encoding" do
        mail = Mail.new("Content-Transfer-Encoding: quoted-printable")
        mail.content_transfer_encoding.should == 'quoted-printable'
      end

      it "should read the content-description" do
        mail = Mail.new("Content-Description: This is a description")
        mail.content_description.should == 'This is a description'
      end

      it "should return the content-type" do
        mail = Mail.new("Content-Type: text/plain")
        mail.mime_type.should == 'text/plain'
      end

      it "should return the charset" do
        mail = Mail.new("Content-Type: text/plain; charset=utf-8")
        mail.charset.should == 'utf-8'
      end

      it "should allow you to set the charset" do
        mail = Mail.new
        mail.charset = 'utf-8'
        mail.charset.should == 'utf-8'
      end

      it "should return the main content-type" do
        mail = Mail.new("Content-Type: text/plain")
        mail.main_type.should == 'text'
      end

      it "should return the sub content-type" do
        mail = Mail.new("Content-Type: text/plain")
        mail.sub_type.should == 'plain'
      end

      it "should return the content-type parameters" do
        mail = Mail.new("Content-Type: text/plain; charset=US-ASCII; format=flowed")
        mail.content_type_parameters.should == {"charset" => 'US-ASCII', "format" => 'flowed'}
      end

      it "should recognize a multipart email" do
        mail = Mail.read(fixture('emails', 'mime_emails', 'raw_email7.eml'))
        mail.should be_multipart
      end

      it "should recognize a non multipart email" do
        mail = Mail.read(fixture('emails', 'plain_emails', 'basic_email.eml'))
        mail.should_not be_multipart
      end

      it "should not report the email as :attachment?" do
        mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_pdf.eml')))
        mail.attachment?.should == false
      end

      it "should report the email as :attachment?" do
        mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_only_email.eml')))
        mail.attachment?.should == true
      end

      it "should recognize an attachment part" do
        mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_pdf.eml')))
        mail.should_not be_attachment
        mail.parts[0].attachment?.should == false
        mail.parts[1].attachment?.should == true
      end

      it "should give how may (top level) parts there are" do
        mail = Mail.read(fixture('emails', 'mime_emails', 'raw_email7.eml'))
        mail.parts.length.should == 2
      end

      it "should give the content_type of each part" do
        mail = Mail.read(fixture('emails', 'mime_emails', 'raw_email11.eml'))
        mail.mime_type.should == 'multipart/alternative'
        mail.parts[0].mime_type.should == 'text/plain'
        mail.parts[1].mime_type.should == 'text/enriched'
      end

      it "should report the mail :has_attachments?" do
        mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_pdf.eml')))
        mail.should be_has_attachments
      end

    end

    describe "multipart emails" do
      it "should add a boundary if there is none defined and a part is added" do
        mail = Mail.new do
          part('This is a part')
          part('This is another part')
        end
        mail.boundary.should_not be_nil
      end

      it "should not add a boundary for a message that is only an attachment" do
        mail = Mail.new
        mail.attachments['test.png'] = "2938492384923849"
        mail.boundary.should be_nil
      end
    end

    describe "multipart/alternative emails" do

      it "should know what it's boundary is if it is a multipart document" do
        mail = Mail.new('Content-Type: multipart/mixed; boundary="--==Boundary"')
        mail.boundary.should == "--==Boundary"
      end

      it "should return nil if there is no content-type defined" do
        mail = Mail.new
        mail.boundary.should == nil
      end

      it "should allow you to assign a text part" do
        mail = Mail.new
        text_mail = Mail.new("This is Text")
        doing { mail.text_part = text_mail }.should_not raise_error
      end

      it "should assign the text part and allow you to reference" do
        mail = Mail.new
        text_mail = Mail.new("This is Text")
        mail.text_part = text_mail
        mail.text_part.should == text_mail
      end

      it "should allow you to assign a html part" do
        mail = Mail.new
        html_mail = Mail.new("<b>This is HTML</b>")
        doing { mail.text_part = html_mail }.should_not raise_error
      end

      it "should assign the html part and allow you to reference" do
        mail = Mail.new
        html_mail = Mail.new("<b>This is HTML</b>")
        mail.html_part = html_mail
        mail.html_part.should == html_mail
      end

      it "should add the html part and text part" do
        mail = Mail.new
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type = "text/html; charset=US-ASCII"
          body = "<b>This is HTML</b>"
        end
        mail.parts.length.should == 2
        mail.parts.first.class.should == Mail::Part
        mail.parts.last.class.should == Mail::Part
      end

      it "should set the content type to multipart/alternative if you use the html_part and text_part helpers" do
        mail = Mail.new
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type = "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        mail.to_s.should =~ %r|Content-Type: multipart/alternative;\s+boundary="#{mail.boundary}"|
      end

      it "should add the end boundary tag" do
        mail = Mail.new
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type = "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        mail.to_s.should =~ %r|#{mail.boundary}--|
      end

      it "should not put message-ids into parts" do
        mail = Mail.new('Subject: FooBar')
        mail.text_part = Mail::Part.new do
          body "This is Text"
        end
        mail.html_part = Mail::Part.new do
          content_type = "text/html; charset=US-ASCII"
          body "<b>This is HTML</b>"
        end
        mail.to_s
        mail.parts.first.message_id.should be_nil
        mail.parts.last.message_id.should be_nil
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
        mail.should be_multipart
        mail.parts.length.should == 2
        mail.text_part.class.should == Mail::Part
        mail.text_part.body.to_s.should == 'This is plain text'
        mail.html_part.class.should == Mail::Part
        mail.html_part.body.to_s.should == '<h1>This is HTML</h1>'
      end

      it "should detect an html_part in an existing email" do
        m = Mail.new(:content_type => 'multipart/alternative')
        m.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        m.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        m.text_part.body.decoded.should == 'PLAIN TEXT'
        m.html_part.body.decoded.should == 'HTML TEXT'
      end

      it "should detect a text_part in an existing email with plain text attachment" do
        m = Mail.new(:content_type => 'multipart/alternative')
        m.add_file(fixture('attachments', 'てすと.txt'))
        m.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        m.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        m.text_part.body.decoded.should == 'PLAIN TEXT'
        m.html_part.body.decoded.should == 'HTML TEXT'
      end

      it "should detect an html_part in a multi level mime email" do
        m = Mail.new(:content_type => 'multipart/mixed')
        a = Mail::Part.new(:content_type => 'text/script', :body => '12345')
        p = Mail::Part.new(:content_type => 'multipart/alternative')
        p.add_part(Mail::Part.new(:content_type => 'text/html', :body => 'HTML TEXT'))
        p.add_part(Mail::Part.new(:content_type => 'text/plain', :body => 'PLAIN TEXT'))
        m.add_part(p)
        m.add_part(a)
        m.text_part.body.decoded.should == 'PLAIN TEXT'
        m.html_part.body.decoded.should == 'HTML TEXT'
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

        m.text_part.body.decoded.should == 'PLAIN TEXT'
        m.html_part.body.decoded.should == 'HTML TEXT'
      end

    end

    describe "finding attachments" do

      it "should return an array of attachments" do
        mail = Mail.read(fixture('emails', 'attachment_emails', 'attachment_content_disposition.eml'))
        mail.attachments.length.should == 1
        mail.attachments.first.filename.should == 'hello.rb'
      end

      it "should return an array of attachments" do
        mail = Mail.read(fixture('emails', 'mime_emails', 'raw_email_with_nested_attachment.eml'))
        mail.attachments.length.should == 2
        mail.attachments[0].filename.should == 'byo-ror-cover.png'
        mail.attachments[1].filename.should == 'smime.p7s'
      end

    end

    describe "adding a file attachment" do

      it "should set to multipart/mixed if a text part and you add an attachment" do
        mail = Mail::Message.new
        mail.text_part { body("log message goes here") }
        mail.add_file(fixture('attachments', 'test.png'))
        mail.mime_type.should == 'multipart/mixed'
      end

      it "should set to multipart/mixed if you add an attachment and then a text part" do
        mail = Mail::Message.new
        mail.add_file(fixture('attachments', 'test.png'))
        mail.text_part { body("log message goes here") }
        mail.mime_type.should == 'multipart/mixed'
      end

      it "should add a part given a filename" do
        mail = Mail::Message.new
        mail.add_file(fixture('attachments', 'test.png'))
        mail.parts.length.should == 1 # First part is an empty text body
      end

      it "should give the part the right content type" do
        mail = Mail::Message.new
        mail.add_file(fixture('attachments', 'test.png'))
        mail.parts.first[:content_type].content_type.should == 'image/png'
      end

      it "should return attachment objects" do
        mail = Mail::Message.new
        mail.add_file(fixture('attachments', 'test.png'))
        mail.attachments.first.class.should == Mail::Part
      end

      it "should be return an aray of attachments" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture('attachments', 'test.png')
          add_file fixture('attachments', 'test.jpg')
          add_file fixture('attachments', 'test.pdf')
          add_file fixture('attachments', 'test.zip')
        end
        mail.attachments.length.should == 4
        mail.attachments.each { |a| a.class.should == Mail::Part }
      end

      it "should return the filename of each attachment" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture('attachments', 'test.png')
          add_file fixture('attachments', 'test.jpg')
          add_file fixture('attachments', 'test.pdf')
          add_file fixture('attachments', 'test.zip')
        end
        mail.attachments[0].filename.should == 'test.png'
        mail.attachments[1].filename.should == 'test.jpg'
        mail.attachments[2].filename.should == 'test.pdf'
        mail.attachments[3].filename.should == 'test.zip'
      end

      it "should return the type/subtype of each attachment" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture('attachments', 'test.png')
          add_file fixture('attachments', 'test.jpg')
          add_file fixture('attachments', 'test.pdf')
          add_file fixture('attachments', 'test.zip')
        end
        mail.attachments[0].mime_type.should == 'image/png'
        mail.attachments[1].mime_type.should == 'image/jpeg'
        mail.attachments[2].mime_type.should == 'application/pdf'
        mail.attachments[3].mime_type.should == 'application/zip'
      end

      it "should return the content of each attachment" do
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture('attachments', 'test.png')
          add_file fixture('attachments', 'test.jpg')
          add_file fixture('attachments', 'test.pdf')
          add_file fixture('attachments', 'test.zip')
        end
        if RUBY_VERSION >= '1.9'
          tripped = mail.attachments[0].decoded
          original = File.read(fixture('attachments', 'test.png')).force_encoding(Encoding::BINARY)
          tripped.should == original
          tripped = mail.attachments[1].decoded
          original = File.read(fixture('attachments', 'test.jpg')).force_encoding(Encoding::BINARY)
          tripped.should == original
          tripped = mail.attachments[2].decoded
          original = File.read(fixture('attachments', 'test.pdf')).force_encoding(Encoding::BINARY)
          tripped.should == original
          tripped = mail.attachments[3].decoded
          original = File.read(fixture('attachments', 'test.zip')).force_encoding(Encoding::BINARY)
          tripped.should == original
        else
          mail.attachments[0].decoded.should == File.read(fixture('attachments', 'test.png'))
          mail.attachments[1].decoded.should == File.read(fixture('attachments', 'test.jpg'))
          mail.attachments[2].decoded.should == File.read(fixture('attachments', 'test.pdf'))
          mail.attachments[3].decoded.should == File.read(fixture('attachments', 'test.zip'))
        end
      end

      it "should allow you to send in file data instead of having to read it" do
        file_data = File.read(fixture('attachments', 'test.png'))
        mail = Mail::Message.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file(:filename => 'test.png', :content => file_data)
        end
        if RUBY_VERSION >= '1.9'
          tripped = mail.attachments[0].decoded
          original = File.read(fixture('attachments', 'test.png')).force_encoding(Encoding::BINARY)
          tripped.should == original
        else
          mail.attachments[0].decoded.should == File.read(fixture('attachments', 'test.png'))
        end
      end

      it "should be able to add a body before adding a file" do
        m = Mail.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          body    "Attached"
          add_file fixture('attachments', 'test.png')
        end
        m.attachments.length.should == 1
        m.parts.length.should == 2
        m.parts[0].body.should == "Attached"
        m.parts[1].filename.should == "test.png"
      end

      it "should allow you to add a body as text part if you have added a file" do
        m = Mail.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture('attachments', 'test.png')
          body    "Attached"
        end
        m.parts.length.should == 2
        m.parts.first[:content_type].content_type.should == 'image/png'
        m.parts.last[:content_type].content_type.should == 'text/plain'
      end

      it "should allow you to add a body as text part if you have added a file and not truncate after newlines - issue 208" do
        m = Mail.new do
          from    'mikel@from.lindsaar.net'
          subject 'Hello there Mikel'
          to      'mikel@to.lindsaar.net'
          add_file fixture('attachments', 'test.png')
          body    "First Line\n\nSecond Line\n\nThird Line\n\n"
          #Note: trailing \n\n is stripped off by Mail::Part initialization
        end
        m.parts.length.should == 2
        m.parts.first[:content_type].content_type.should == 'image/png'
        m.parts.last[:content_type].content_type.should == 'text/plain'
        m.parts.last.to_s.should match /^First Line\r\n\r\nSecond Line\r\n\r\nThird Line/
      end

      it "should not raise a warning if there is a charset defined and there are non ascii chars in the body" do
        body = "This is NOT plain text ASCII　− かきくけこ"
        mail = Mail.new
        mail.body = body
        mail.charset = 'UTF-8'
        mail.add_file fixture('attachments', 'test.png')
        STDERR.should_not_receive(:puts)
        mail.to_s
      end


    end

end
