# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

def encode_base64(str)
  Mail::Encodings::Base64.encode(str)
end

def check_decoded(actual, expected)
  expect(actual.encoding).to eq Encoding::BINARY
  expect(actual).to eq expected.dup.force_encoding(Encoding::BINARY)
end

describe "Attachments" do

  before(:each) do
    @mail = Mail.new
    @test_png = read_raw_fixture('attachments', 'test.png')
  end

  describe "from direct content" do
    it "should work" do
      @mail.attachments['test.png'] = @test_png
      expect(@mail.attachments['test.png'].filename).to eq 'test.png'
      check_decoded(@mail.attachments[0].decoded, @test_png)
    end

    it "should work out magically the mime_type" do
      @mail.attachments['test.png'] = @test_png
      expect(@mail.attachments[0].mime_type).to eq 'image/png'
    end

    it "should assign the filename" do
      @mail.attachments['test.png'] = @test_png
      expect(@mail.attachments[0].filename).to eq 'test.png'
    end

    it "should assign mime-encoded multibyte filename" do
      @mail.attachments['てすと.txt'] = read_raw_fixture('attachments', 'てすと.txt')
      expect(Mail::Utilities.blank?(@mail.attachments)).not_to eq true
      expect(Mail::Encodings.decode_encode(@mail.attachments[0].filename, :decode)).to eq 'てすと.txt'
    end
  end

  describe "from a supplied Hash" do
    it "should work" do
      @mail.attachments['test.png'] = { :content => @test_png }
      expect(@mail.attachments[0].filename).to eq 'test.png'
      check_decoded(@mail.attachments[0].decoded, @test_png)
    end

    it "should allow you to override the content_type" do
      @mail.attachments['test.png'] = { :content => @test_png,
                                        :content_type => "application/x-gzip" }
      expect(@mail.attachments[0].content_type).to eq 'application/x-gzip'
    end

    it "should allow you to override the mime_type" do
      @mail.attachments['test.png'] = { :content => @test_png,
                                        :mime_type => "application/x-gzip" }
      expect(@mail.attachments[0].mime_type).to eq 'application/x-gzip'
    end

    it "should allow you to override the mime_type" do
      @mail.attachments['invoice.jpg'] = { :data => "you smiling",
                                           :mime_type => "image/x-jpg",
                                           :transfer_encoding => "base64" }
      expect(@mail.attachments[0].mime_type).to eq 'image/x-jpg'
    end

  end

  describe "decoding and encoding" do

    it "should set its content_transfer_encoding" do
      @mail.attachments['test.png'] = { :content => @test_png }
      @mail.ready_to_send!
      expect(@mail.attachments[0].content_transfer_encoding).to eq 'base64'
    end

    it "should encode its body to base64" do
      @mail.attachments['test.png'] = { :content => @test_png }
      @mail.ready_to_send!
      expect(@mail.attachments[0].encoded).to include(encode_base64(@test_png))
    end

    it "should allow you to pass in an encoded attachment with an encoding" do
      encoded_data = encode_base64(@test_png)
      @mail.attachments['test.png'] = { :content => encoded_data,
                                        :encoding => 'base64' }
      check_decoded(@mail.attachments[0].decoded, @test_png)
    end

    it "should allow you set a mime type and encoding without overriding the encoding" do
      encoded = encode_base64('<foo/>')
      @mail.attachments['test.png'] = { :mime_type => 'text/xml', :content => encoded, :encoding => 'base64' }
      expect(@mail.attachments[0].content_transfer_encoding).to eq 'base64'
      check_decoded(@mail.attachments[0].decoded, '<foo/>')
    end

    it "should not allow you to pass in an encoded attachment with an unknown encoding" do
      base64_encoded_data = encode_base64(@test_png)
      expect {@mail.attachments['test.png'] = { :content => base64_encoded_data,
                                               :encoding => 'weird_encoding' }}.to raise_error(/Do not know how to handle Content Transfer Encoding weird_encoding/)
    end

   it "should be able to call read on the attachment to return the decoded data" do
      @mail.attachments['test.png'] = { :content => @test_png }
      expected = @mail.attachments[0].read.force_encoding(@test_png.encoding)
      expect(expected).to eq @test_png
    end

    it "should only add one newline between attachment body and boundary" do
      contents = "I have\ntwo lines with trailing newlines\n\n"
      @mail.attachments['text.txt'] = { :content => contents}
      encoded = @mail.encoded
      regex = /\r\n#{Regexp.escape(contents.gsub(/\n/, "\r\n"))}\r\n--#{@mail.boundary}--\r\n\Z/
      expect(encoded).to match regex
    end

  end

  describe "multiple attachments" do

    it "should allow you to pass in more than one attachment" do
      mail = Mail.new
      mail.attachments['test.pdf'] = read_raw_fixture('attachments', 'test.pdf')
      mail.attachments['test.gif'] = read_raw_fixture('attachments', 'test.gif')
      mail.attachments['test.jpg'] = read_raw_fixture('attachments', 'test.jpg')
      mail.attachments['test.zip'] = read_raw_fixture('attachments', 'test.zip')
      expect(mail.attachments[0].filename).to eq 'test.pdf'
      expect(mail.attachments[1].filename).to eq 'test.gif'
      expect(mail.attachments[2].filename).to eq 'test.jpg'
      expect(mail.attachments[3].filename).to eq 'test.zip'
    end

  end

  describe "inline attachments" do

    it "should set the content_disposition to inline or attachment as appropriate" do
      mail = Mail.new
      mail.attachments['test.pdf'] = read_raw_fixture('attachments', 'test.pdf')
      expect(mail.attachments['test.pdf'].content_disposition).to eq 'attachment; filename=test.pdf'
      mail.attachments.inline['test.png'] = read_raw_fixture('attachments', 'test.png')
      expect(mail.attachments.inline['test.png'].content_disposition).to eq 'inline; filename=test.png'
    end

    it "should return a cid" do
      mail = Mail.new
      mail.attachments.inline['test.png'] = @test_png
      expect(mail.attachments['test.png'].url).to eq "cid:#{mail.attachments['test.png'].cid}"
    end

    it "should respond true to inline?" do
      mail = Mail.new
      mail.attachments.inline['test.png'] = @test_png
      expect(mail.attachments['test.png']).to be_inline
    end
  end

  describe "getting the content ID from an attachment" do
    before(:each) do
      @mail = Mail.new
      @mail.attachments['test.gif'] = read_raw_fixture('attachments', 'test.gif')
      expect(@mail.attachments['test.gif'].has_content_id?).to be_falsey
      @mail.attachments['test.gif'].add_content_id
      @cid = @mail.attachments['test.gif'].content_id
      expect(@cid).not_to be_nil
    end

    it "should return a valid content-id on inline attachments" do
      field = Mail::ContentIdField.new(@cid)
      expect(field.errors).to be_empty
    end

    it "should provide a URL escaped content_id (without brackets) for use inside an email" do
      @inline = @mail.attachments['test.gif'].cid
      expect(@inline).to eq Mail::Utilities.uri_parser.escape(@cid.gsub(/^</, '').gsub(/>$/, ''))
    end
  end

  describe "setting the content type correctly" do
    it "should set the content type to multipart/mixed if none given and you add an attachment" do
      mail = Mail.new
      mail.attachments['test.pdf'] = read_raw_fixture('attachments', 'test.pdf')
      mail.encoded
      expect(mail.mime_type).to eq 'multipart/mixed'
    end

    it "allows you to set the attachment before the content type" do
      mail = Mail.new
      mail.attachments["test.png"] = read_raw_fixture('attachments', 'test.png')
      mail.body = "Lots of HTML"
      mail.mime_version = '1.0'
      mail.content_type = 'text/html; charset=UTF-8'
    end

  end

  describe "should handle filenames with non-7bit characters correctly" do
    it "should not raise an exception with a filename that contains a non-7bit-character" do
      filename = "f\u00f6\u00f6.b\u00e4r"
      expect(filename.encoding).to eq Encoding::UTF_8
      mail = Mail.new
      expect {
        mail.attachments[filename] = read_raw_fixture('attachments', 'test.pdf')
      }.not_to raise_error
    end
  end

end

describe "reading emails with attachments" do
  describe "test emails" do

    it "should find the attachment using content location" do
      mail = read_fixture('emails/attachment_emails/attachment_content_location.eml')
      expect(mail.attachments.length).to eq 1
    end

    it "should find an attachment defined with 'name' and Content-Disposition: attachment" do
      mail = read_fixture('emails/attachment_emails/attachment_content_disposition.eml')
      expect(mail.attachments.length).to eq 1
    end

    it "should use the content-disposition filename over the content-type filename or name" do
      mail = read_fixture('emails/attachment_emails/attachment_content_disposition.eml')
      expect(mail.attachments[0].filename).to eq 'api.rb'
    end

    it "should decode an attachment" do
      mail = read_fixture('emails/attachment_emails/attachment_pdf.eml')
      expect(mail.attachments[0].decoded.length).to eq 1026
    end

    it "should decode an attachment with linefeeds" do
      mail = read_fixture('emails/attachment_emails/attachment_pdf_lf.eml')
      expect(mail.attachments.size).to eq(1)
      expect(mail.attachments[0].decoded.length).to eq 1026
    end

    it "should find an attachment that has an encoded name value" do
      mail = read_fixture('emails/attachment_emails/attachment_with_encoded_name.eml')
      expect(mail.attachments.length).to eq 1
      result = mail.attachments[0].filename
      replace = '�'
      expected = "01 Quien Te Dij#{replace}at. Pitbull.mp3"
      expect(result).to eq expected
    end

    it "should find an attachment that has an base64 encoded name value" do
      mail = read_fixture('emails/attachment_emails/attachment_with_base64_encoded_name.eml')
      expect(mail.attachments.length).to eq 1
      result = mail.attachments[0].filename
      expect(result).to eq "This is a test.pdf"
    end

    it "should find an attachment that has a name not surrounded by quotes" do
      mail = read_fixture('emails/attachment_emails/attachment_with_unquoted_name.eml')
      expect(mail.attachments.length).to eq 1
      expect(mail.attachments.first.filename).to eq "This is a test.txt"
    end

    it "should decode an attachment without ascii compatible filename" do
      mail = read_fixture('emails/attachment_emails/attachment_nonascii_filename.eml')
      expect(mail.attachments.length).to eq 1
      expect(mail.attachments.first.filename).to eq "ciële.txt"
    end

    it "should find attachments inside parts with content-type message/rfc822" do
      mail = read_fixture('emails/attachment_emails/attachment_message_rfc822.eml')
      expect(mail.attachments.length).to eq 1
      expect(mail.attachments[0].decoded.length).to eq 1026
    end

    it "attach filename decoding (issue 83)" do
      mail = Mail.new(Mail::Utilities.to_crlf(<<-limitMAIL))
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
      #~ puts Mail::Encodings.decode_encode(mail.attachments[0].filename, :decode)
      expect(mail.attachments[0].filename).to eq "Foto0009.jpg"
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

    mail.attachments['test.zip'] = read_raw_fixture('attachments', 'test.zip')
    mail.attachments['test.pdf'] = read_raw_fixture('attachments', 'test.pdf')
    mail.attachments['test.gif'] = read_raw_fixture('attachments', 'test.gif')
    mail.attachments['test.jpg'] = read_raw_fixture('attachments', 'test.jpg')
    expect(mail.attachments[0].filename).to eq 'test.zip'
    expect(mail.attachments[1].filename).to eq 'test.pdf'
    expect(mail.attachments[2].filename).to eq 'test.gif'
    expect(mail.attachments[3].filename).to eq 'test.jpg'


    mail2 = Mail.new(mail.encoded)
    expect(mail2.attachments[0].filename).to eq 'test.zip'
    expect(mail2.attachments[1].filename).to eq 'test.pdf'
    expect(mail2.attachments[2].filename).to eq 'test.gif'
    expect(mail2.attachments[3].filename).to eq 'test.jpg'
  end
end
