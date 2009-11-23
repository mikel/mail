# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

def encode_base64( str )
  Mail::Encodings::Base64.encode(str)
end

describe "creating an attachment" do
  
  it "should create an attachment from an absolute path" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    att = Mail::Attachment.new(:filename => fixture('attachments', 'test.png'))
    if RUBY_VERSION >= '1.9'
      att.decoded.should == file_data.force_encoding(Encoding::BINARY)
    else
      att.decoded.should == file_data
    end
  end
  
  it "should handle alias :read to :decoded" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    att = Mail::Attachment.new(:filename => fixture('attachments', 'test.png'))
    if RUBY_VERSION >= '1.9'
      att.read.should == file_data.force_encoding(Encoding::BINARY)
    else
      att.read.should == file_data
    end
  end
  
  it "should work out it's filename" do
    att = Mail::Attachment.new(:filename => fixture('attachments', 'test.png'))
    att.filename.should == 'test.png'
  end
  
  it "should give back a mime_type" do
    att = Mail::Attachment.new(:filename => fixture('attachments', 'test.png'))
    att.mime_type.should == 'image/png'
  end
  
  it "should allow you to override the mime_type" do
    att = Mail::Attachment.new(:filename => fixture('attachments', 'test.png'),
                               :mime_type => 'image/jpg')
    att.mime_type.should == 'image/jpg'
  end
  
  it "should allow you to pass in data explicitly" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    att = Mail::Attachment.new(:filename => 'test.png',
                               :data => file_data)
    if RUBY_VERSION >= '1.9'
      att.decoded.should == file_data.force_encoding(Encoding::BINARY)
    else
      att.decoded.should == file_data
    end
  end
  
  it "should allow you to pass in a mime type and file data" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    att = Mail::Attachment.new(:filename => 'test.png',
                               :data => file_data,
                               :mime_type => 'image/jpg')
    att.mime_type.should == 'image/jpg'
    if RUBY_VERSION >= '1.9'
      att.decoded.should == file_data.force_encoding(Encoding::BINARY)
    else
      att.decoded.should == file_data
    end
  end
  
  it "should encode it's body to base64 when you call 'encoded'" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    att = Mail::Attachment.new(:filename => 'test.png',
                               :data => file_data)
    att.encoded.should == encode_base64(file_data)
  end
  
  it "should allow you to pass in an encoded attachment with an encoding" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    encoded_data = encode_base64(file_data)
    att = Mail::Attachment.new(:filename => 'test.png',
                               :data => encoded_data,
                               :encoding => 'base64')
    att.encoded.should == encoded_data
    if RUBY_VERSION >= '1.9'
      att.decoded.should == file_data.force_encoding(Encoding::BINARY)
    else
      att.decoded.should == file_data
    end
  end
  
  it "should allow you to pass in an encoded attachment with an unknown encoding" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    encoded_data = encode_base64(file_data)
    att = Mail::Attachment.new(:filename => 'test.png',
                               :data => encoded_data,
                               :encoding => 'weird_encoding')
    att.encoded.should == encoded_data
  end
  
  it "should raise an error if it doesn't know how to decode" do
    file_data = File.read(filename = fixture('attachments', 'test.png'))
    encoded_data = encode_base64(file_data)
    att = Mail::Attachment.new(:filename => 'test.png',
                               :data => encoded_data,
                               :encoding => 'weird_encoding')
    doing { att.decoded }.should raise_error(Mail::Attachment::UnknownEncodingType)
  end
    
  it "should not put the whole path into the filename" do
    att = Mail::Attachment.new({:content_type=>"image/jpeg",
                                :content_disposition=>"attachment",
                                :data=>"123456789",
                                :content_transfer_encoding=>"base64",
                                :filename=>fixture('attachments', 'test.png')})
    att.filename.should == 'test.png'
  end

end

describe "reading emails with attachments" do
  describe "test emails" do
    
    it "should find the attachment using content location" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_location.eml')))
      mail.attachments.length.should == 1
    end

    it "should find an attachment defined with 'name' and Content-Disposition: attachment" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_disposition.eml')))
      mail.attachments.length.should == 1
    end

    it "should use the content-type filename or name over the content-disposition filename" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_content_disposition.eml')))
      mail.attachments.first.filename.should == 'hello.rb'
    end
    
    it "should decode an attachment" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_pdf.eml')))
      mail.attachments.first.decoded.length.should == 1026
    end
    
    it "should find an attachment that has an encoded name value" do
      mail = Mail.read(fixture(File.join('emails', 'attachment_emails', 'attachment_with_encoded_name.eml')))
      mail.attachments.length.should == 1
      result = mail.attachments.first.filename
      if RUBY_VERSION >= '1.9'
        expected = "01 Quien Te Dij\212at. Pitbull.mp3".force_encoding(result.encoding)
      else
        expected = "01 Quien Te Dij\212at. Pitbull.mp3"
      end
      result.should == expected
    end

  end
end
