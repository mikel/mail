# encoding: utf-8
require 'spec_helper'

def encode_base64(str)
  Mail::Encodings::Base64.encode(str)
end

def check_decoded(actual, expected)
  if RUBY_VERSION >= '1.9'
    expect(actual.encoding).to eq Encoding::BINARY
    expect(actual).to eq expected.force_encoding(Encoding::BINARY)
  else
    expect(actual).to eq expected
  end
end

describe "Attachments" do

  before(:each) do
    @mail = Mail.new
    @test_png = File.open(fixture('attachments', 'test.png'), 'rb', &:read)
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
      @mail.attachments['てすと.txt'] = File.open(fixture('attachments', 'てすと.txt'), 'rb', &:read)
      expect(@mail.attachments).not_to be_blank
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
      expect(doing {@mail.attachments['test.png'] = { :content => base64_encoded_data,
                                               :encoding => 'weird_encoding' }}).to raise_error
    end

   it "should be able to call read on the attachment to return the decoded data" do
      @mail.attachments['test.png'] = { :content => @test_png }
      if RUBY_VERSION >= '1.9'
        expected = @mail.attachments[0].read.force_encoding(@test_png.encoding)
      else
        expected = @mail.attachments[0].read
      end
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
      mail.attachments['test.pdf'] = File.open(fixture('attachments', 'test.pdf'), 'rb', &:read)
      mail.attachments['test.gif'] = File.open(fixture('attachments', 'test.gif'), 'rb', &:read)
      mail.attachments['test.jpg'] = File.open(fixture('attachments', 'test.jpg'), 'rb', &:read)
      mail.attachments['test.zip'] = File.open(fixture('attachments', 'test.zip'), 'rb', &:read)
      expect(mail.attachments[0].filename).to eq 'test.pdf'
      expect(mail.attachments[1].filename).to eq 'test.gif'
      expect(mail.attachments[2].filename).to eq 'test.jpg'
      expect(mail.attachments[3].filename).to eq 'test.zip'
    end

  end

  describe "inline attachments" do

    it "should set the content_disposition to inline or attachment as appropriate" do
      mail = Mail.new
      mail.attachments['test.pdf'] = File.open(fixture('attachments', 'test.pdf'), 'rb', &:read)
      expect(mail.attachments['test.pdf'].content_disposition).to eq 'attachment; filename=test.pdf'
      mail.attachments.inline['test.png'] = File.open(fixture('attachments', 'test.png'), 'rb', &:read)
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
      @mail.attachments['test.gif'] = File.open(fixture('attachments', 'test.gif'), 'rb', &:read)
      @cid = @mail.attachments['test.gif'].content_id
    end

    it "should return a content-id for the attachment on creation if passed inline => true" do
      expect(@cid).not_to be_nil
    end

    it "should return a valid content-id on inline attachments" do
      expect(Mail::ContentIdField.new(@cid).errors).to be_empty
    end

    it "should provide a URL escaped content_id (without brackets) for use inside an email" do
      @inline = @mail.attachments['test.gif'].cid
      uri_parser = URI.const_defined?(:Parser) ? URI::Parser.new : URI
      expect(@inline).to eq uri_parser.escape(@cid.gsub(/^</, '').gsub(/>$/, ''))
    end
  end

  describe "setting the content type correctly" do
    it "should set the content type to multipart/mixed if none given and you add an attachment" do
      mail = Mail.new
      mail.attachments['test.pdf'] = File.open(fixture('attachments', 'test.pdf'), 'rb', &:read)
      mail.encoded
      expect(mail.mime_type).to eq 'multipart/mixed'
    end

    it "allows you to set the attachment before the content type" do
      mail = Mail.new
      mail.attachments["test.png"] = File.open(fixture('attachments', 'test.png'), 'rb', &:read)
      mail.body = "Lots of HTML"
      mail.mime_version = '1.0'
      mail.content_type = 'text/html; charset=UTF-8'
    end

  end

  describe "should handle filenames with non-7bit characters correctly" do
    it "should not raise an exception with a filename that contains a non-7bit-character" do
      filename = "f\u00f6\u00f6.b\u00e4r"
      if RUBY_VERSION >= '1.9'
        expect(filename.encoding).to eq Encoding::UTF_8
      end
      mail = Mail.new
      expect(doing {
        mail.attachments[filename] = File.open(fixture('attachments', 'test.pdf'), 'rb', &:read)
      }).not_to raise_error
    end
  end

end

describe "reading emails with attachments" do
  describe "test emails" do

    it "should find the attachment using content location" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_location.eml')))
      expect(mail.attachments.length).to eq 1
    end

    it "should find an attachment defined with 'name' and Content-Disposition: attachment" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_disposition.eml')))
      expect(mail.attachments.length).to eq 1
    end

    it "should use the content-type filename or name over the content-disposition filename" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_disposition.eml')))
      expect(mail.attachments[0].filename).to eq 'hello.rb'
    end

    it "should decode an attachment" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_pdf.eml')))
      expect(mail.attachments[0].decoded.length).to eq 1026
    end

    it "should find an attachment that has an encoded name value" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_with_encoded_name.eml')))
      expect(mail.attachments.length).to eq 1
      result = mail.attachments[0].filename
      if RUBY_VERSION >= '1.9'
        expected = "01 Quien Te Dij\212at. Pitbull.mp3".force_encoding(result.encoding)
      else
        expected = "01 Quien Te Dij\212at. Pitbull.mp3"
      end
      expect(result).to eq expected
    end

    it "should find an attachment that has a name not surrounded by quotes" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', "attachment_with_unquoted_name.eml")))
      expect(mail.attachments.length).to eq 1
      expect(mail.attachments.first.filename).to eq "This is a test.txt"
    end

    it "should find attachments inside parts with content-type message/rfc822" do
      mail = Mail.read(fixture(File.join("emails",
                                         "attachment_emails",
                                         "attachment_message_rfc822.eml")))
      expect(mail.attachments.length).to eq 1
      expect(mail.attachments[0].decoded.length).to eq 1026
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

    mail.attachments['test.zip'] = File.open(fixture('attachments', 'test.zip'), 'rb', &:read)
    mail.attachments['test.pdf'] = File.open(fixture('attachments', 'test.pdf'), 'rb', &:read)
    mail.attachments['test.gif'] = File.open(fixture('attachments', 'test.gif'), 'rb', &:read)
    mail.attachments['test.jpg'] = File.open(fixture('attachments', 'test.jpg'), 'rb', &:read)
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
