# encoding: utf-8

require 'spec_helper'

def encode_base64(str)
  Mail::Encodings::Base64.encode(str)
end

def check_decoded(actual, expected)
  if RUBY_VERSION >= '1.9'
    actual.should eql expected.force_encoding(Encoding::BINARY)
  else
    actual.should eql expected
  end
end

describe "Attachments" do

  before(:each) do
    @mail = Mail.new
  end

  describe "from direct content" do
    it "should work" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = File.read(fixture('attachments', 'test.png'))
      @mail.attachments['test.png'].filename.should eql 'test.png'
      check_decoded(@mail.attachments[0].decoded, file_data)
    end

    it "should work out magically the mime_type" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = File.read(fixture('attachments', 'test.png'))
      @mail.attachments[0].mime_type.should eql 'image/png'
    end

    it "should assign the filename" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = file_data
      @mail.attachments[0].filename.should eql 'test.png'
    end

    it "should assign mime-encoded multibyte filename" do
      file_data = File.read(filename = fixture('attachments', 'てすと.txt'))
      @mail.attachments['てすと.txt'] = file_data
      @mail.attachments.should_not be_blank
      Mail::Encodings.decode_encode(@mail.attachments[0].filename, :decode).should eql 'てすと.txt'
    end
  end

  describe "from a supplied Hash" do
    it "should work" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = { :content => file_data }
      @mail.attachments[0].filename.should eql 'test.png'
      check_decoded(@mail.attachments[0].decoded, file_data)
    end

    it "should allow you to override the content_type" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = { :content => file_data,
                                        :content_type => "application/x-gzip" }
      @mail.attachments[0].content_type.should eql 'application/x-gzip'
    end

    it "should allow you to override the mime_type" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = { :content => file_data,
                                        :mime_type => "application/x-gzip" }
      @mail.attachments[0].mime_type.should eql 'application/x-gzip'
    end

    it "should allow you to override the mime_type" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['invoice.jpg'] = { :data => "you smiling",
                                           :mime_type => "image/x-jpg",
                                           :transfer_encoding => "base64" }
      @mail.attachments[0].mime_type.should eql 'image/x-jpg'
    end

  end

  describe "decoding and encoding" do

    it "should set it's content_transfer_encoding" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = { :content => file_data }
      @mail.ready_to_send!
      @mail.attachments[0].content_transfer_encoding.should eql 'base64'
    end

    it "should encode it's body to base64" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = { :content => file_data }
      @mail.ready_to_send!
      @mail.attachments[0].encoded.should include(encode_base64(file_data))
    end

    it "should allow you to pass in an encoded attachment with an encoding" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      encoded_data = encode_base64(file_data)
      @mail.attachments['test.png'] = { :content => encoded_data,
                                        :encoding => 'base64' }
      check_decoded(@mail.attachments[0].decoded, file_data)
    end

    it "should not allow you to pass in an encoded attachment with an unknown encoding" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      base64_encoded_data = encode_base64(file_data)
      doing {@mail.attachments['test.png'] = { :content => base64_encoded_data,
                                               :encoding => 'weird_encoding' }}.should raise_error
    end

   it "should be able to call read on the attachment to return the decoded data" do
      file_data = File.read(filename = fixture('attachments', 'test.png'))
      @mail.attachments['test.png'] = { :content => file_data }
      if RUBY_VERSION >= '1.9'
        expected = @mail.attachments[0].read.force_encoding(file_data.encoding)
      else
        expected = @mail.attachments[0].read
      end
      expected.should eql file_data
    end

  end

  describe "multiple attachments" do

    it "should allow you to pass in more than one attachment" do
      mail = Mail.new
      mail.attachments['test.pdf'] = File.read(fixture('attachments', 'test.pdf'))
      mail.attachments['test.gif'] = File.read(fixture('attachments', 'test.gif'))
      mail.attachments['test.jpg'] = File.read(fixture('attachments', 'test.jpg'))
      mail.attachments['test.zip'] = File.read(fixture('attachments', 'test.zip'))
      mail.attachments[0].filename.should eql 'test.pdf'
      mail.attachments[1].filename.should eql 'test.gif'
      mail.attachments[2].filename.should eql 'test.jpg'
      mail.attachments[3].filename.should eql 'test.zip'
    end

  end

  describe "inline attachments" do

    it "should set the content_disposition to inline or attachment as appropriate" do
      mail = Mail.new
      mail.attachments['test.pdf'] = File.read(fixture('attachments', 'test.pdf'))
      mail.attachments['test.pdf'].content_disposition.should eql 'attachment; filename=test.pdf'
      mail.attachments.inline['test.png'] = File.read(fixture('attachments', 'test.png'))
      mail.attachments.inline['test.png'].content_disposition.should eql 'inline; filename=test.png'
    end

    it "should return a cid" do
      mail = Mail.new
      mail.attachments.inline['test.png'] = File.read(fixture('attachments', 'test.png'))
      mail.attachments['test.png'].url.should eql "cid:#{mail.attachments['test.png'].cid}"
    end

    it "should respond true to inline?" do
      mail = Mail.new
      mail.attachments.inline['test.png'] = File.read(fixture('attachments', 'test.png'))
      mail.attachments['test.png'].should be_inline
    end
  end

  describe "getting the content ID from an inline attachment" do
    before(:each) do
      @mail = Mail.new
      @mail.attachments['test.gif'] = File.read(fixture('attachments', 'test.gif'))
      @cid = @mail.attachments['test.gif'].content_id
    end

    it "should return a content-id for the attachment on creation if passed inline => true" do
      @cid.should_not be_nil
    end

    it "should return a valid content-id on inline attachments" do
      Mail::ContentIdField.new(@cid).errors.should be_empty
    end

    it "should provide a URL escaped content_id (without brackets) for use inside an email" do
      @inline = @mail.attachments['test.gif'].cid
      uri_parser = URI.const_defined?(:Parser) ? URI::Parser.new : URI
      @inline.should eql uri_parser.escape(@cid.gsub(/^</, '').gsub(/>$/, ''))
    end
  end

  describe "setting the content type correctly" do
    it "should set the content type to multipart/mixed if none given and you add an attachment" do
      mail = Mail.new
      mail.attachments['test.pdf'] = File.read(fixture('attachments', 'test.pdf'))
      mail.encoded
      mail.mime_type.should eql 'multipart/mixed'
    end
  end

end

describe "reading emails with attachments" do
  describe "test emails" do

    it "should find the attachment using content location" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_location.eml')))
      mail.attachments.length.should eql 1
    end

    it "should find an attachment defined with 'name' and Content-Disposition: attachment" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_disposition.eml')))
      mail.attachments.length.should eql 1
    end

    it "should use the content-type filename or name over the content-disposition filename" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_disposition.eml')))
      mail.attachments[0].filename.should eql 'hello.rb'
    end

    it "should decode an attachment" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_pdf.eml')))
      mail.attachments[0].decoded.length.should eql 1026
    end

    it "should find an attachment that has an encoded name value" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_with_encoded_name.eml')))
      mail.attachments.length.should eql 1
      result = mail.attachments[0].filename
      if RUBY_VERSION >= '1.9'
        expected = "01 Quien Te Dij\212at. Pitbull.mp3".force_encoding(result.encoding)
      else
        expected = "01 Quien Te Dij\212at. Pitbull.mp3"
      end
      result.should eql expected
    end

    it "should find attachments inside parts with content-type message/rfc822" do
      mail = Mail.read(fixture(File.join("emails",
                                         "attachment_emails",
                                         "attachment_message_rfc822.eml")))
      mail.attachments.length.should eql 1
      mail.attachments[0].decoded.length.should eql 1026
    end

    it "attach filename decoding (issue 83)" do
      data = <<-limitMAIL
Subject: aaa
From: aaa@aaa.com
To: bbb@aaa.com
Content-Type: multipart/mixed; boundary=0016e64c0af257c3a7048b69e1ac

--0016e64c0af257c3a7048b69e1ac
Content-Type: multipart/alternative; boundary=0016e64c0af257c3a1048b69e1aa

--0016e64c0af257c3a1048b69e1aa
Content-Type: text/plain; charset=ISO-8859-1

aaa

--0016e64c0af257c3a1048b69e1aa
Content-Type: text/html; charset=ISO-8859-1

aaa<br>

--0016e64c0af257c3a1048b69e1aa--
--0016e64c0af257c3a7048b69e1ac
Content-Type: text/plain; charset=US-ASCII; name="=?utf-8?b?Rm90bzAwMDkuanBn?="
Content-Disposition: attachment; filename="=?utf-8?b?Rm90bzAwMDkuanBn?="
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbneqxxy0

YWFhCg==
--0016e64c0af257c3a7048b69e1ac--
limitMAIL
      mail = Mail.new(data)
      #~ puts Mail::Encodings.decode_encode(mail.attachments[0].filename, :decode)
      mail.attachments[0].filename.should eql "Foto0009.jpg"
    end

  end
end

describe "attachment order" do
  it "should be preserved instead  when content type exists" do
    mail = Mail.new do
      to "aaaa@aaaa.aaa"
      from "aaaa2@aaaa.aaa"
      subject "a subject"
      date Time.now
      text_part do
        content_type 'text/plain; charset=UTF-8'
        body "a \nsimplebody\n"
      end
    end

    mail.attachments['test.zip'] = File.read(fixture('attachments', 'test.zip'))
    mail.attachments['test.pdf'] = File.read(fixture('attachments', 'test.pdf'))
    mail.attachments['test.gif'] = File.read(fixture('attachments', 'test.gif'))
    mail.attachments['test.jpg'] = File.read(fixture('attachments', 'test.jpg'))
    mail.attachments[0].filename.should eql 'test.zip'
    mail.attachments[1].filename.should eql 'test.pdf'
    mail.attachments[2].filename.should eql 'test.gif'
    mail.attachments[3].filename.should eql 'test.jpg'


    mail2 = Mail.new(mail.encoded)
    mail2.attachments[0].filename.should eql 'test.zip'
    mail2.attachments[1].filename.should eql 'test.pdf'
    mail2.attachments[2].filename.should eql 'test.gif'
    mail2.attachments[3].filename.should eql 'test.jpg'
  end
end
