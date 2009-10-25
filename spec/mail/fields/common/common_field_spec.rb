# encoding: utf-8
require File.dirname(__FILE__) + '/../../../spec_helper'

describe Mail::CommonField do

  describe "multi-charset support" do
    it "should leave ascii alone" do
      field = Mail::SubjectField.new("Subject", "This is a test")
      field.encoded.should == "Subject: This is a test\r\n"
    end
    
    if RUBY_VERSION < '1.9'
    
      it "should encode a utf-8 string as utf-8 quoted printable" do
        $KCODE = 'u'
        value = "かきくけこ"
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?UTF8?B?44GL44GN44GP44GR44GT?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end

      it "should encode a SJIS string as SJIS quoted printable" do
        $KCODE = 's'
        value = "かきくけこ"
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?SJIS?B?44GL44GN44GP44GR44GT?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end

      it "should wrap an encoded at 60 characters" do
        $KCODE = 's'
        value = "かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ"
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?SJIS?B?44GL44GN44GP44GR44GTIOOBi+OBjeOBj+OBkeOBkw==?=\r\n\t=?SJIS?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZMg44GL44GN4w==?=\r\n\t=?SJIS?B?gY/jgZHjgZM=?=\r\n\t=?SJIS?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZMg44GL44GN4w==?=\r\n\t=?SJIS?B?gY/jgZHjgZMg44GL44GN44GP44GR44GT?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
    
      it "should handle charsets in addresses" do
        $KCODE = 'u'
        value = "かきくけこ <mikel@test.lindsaar.net>"
        field = Mail::FromField.new("From", value)
        field.encoded.should == "From: =?UTF8?B?44GL44GN44GP44GR44GT?=\r\n\t <mikel@test.lindsaar.net>\r\n"
        field.decoded.should == "From: #{value}\r\n"
        field.value.should == value
      end
    
    else
    
      it "should encode a utf-8 string as utf-8 quoted printable" do
        value = "かきくけこ"
        value = value.force_encoding('UTF-8')
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?UTF-8?B?44GL44GN44GP44GR44GT?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
      
      it "should encode a iso-8559 string as iso-8559 quoted printable" do
        value = "かきくけこ"
        value = value.force_encoding('ISO-8859-1')
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?ISO-8859-1?B?44GL44GN44GP44GR44GT?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
    
      it "should wrap an encoded at 60 characters" do
        value = "かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ"
        value = value.force_encoding('UTF-8')
        field = Mail::SubjectField.new("Subject", value)
        field.encoded.should == "Subject: =?UTF-8?B?44GL44GN44GP44GR44GTIOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHj\ngZMg44GL44GN44GP44GR44GTIOOBi+OBjeOBj+OBkeOBkw==?=\r\n\t=?UTF-8?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZMg44GL44GN44GP44GR\n44GTIOOBi+OBjeOBj+OBkeOBkw==?=\r\n"
        field.decoded.should == "Subject: #{value}\r\n"
        field.value.should == value
      end
      
      it "should handle charsets in addresses" do
        value = "かきくけこ <mikel@test.lindsaar.net>"
        value = value.force_encoding('UTF-8')
        field = Mail::FromField.new("From", value)
        field.encoded.should == "From: =?UTF-8?B?44GL44GN44GP44GR44GTIDxtaWtlbEB0ZXN0LmxpbmRzYWFyLm5ldD4=?=\r\n"
        field.decoded.should == "From: #{value}\r\n"
        field.value.should == value
      end
    
    end
    
  end

end
