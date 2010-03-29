# encoding: utf-8
require 'spec_helper'

describe Mail::CommonField do

  describe "multi-charset support" do
    it "should leave ascii alone" do
      field = Mail::SubjectField.new("This is a test")
      field.encoded.should == "Subject: This is a test\r\n"
      field.decoded.should == "This is a test"
    end
    
    it "should encode a utf-8 string as utf-8 quoted printable" do
      original = $KCODE
      value = "かきくけこ"
      if RUBY_VERSION < '1.9'
        $KCODE = 'u'
        result = "Subject: =?UTF-8?B?44GL44GN44GP44GR44GT?=\r\n"
      else
        value.force_encoding('UTF-8')
        result = "Subject: =?UTF-8?B?44GL44GN44GP44GR44GT?=\r\n"
      end
      field = Mail::SubjectField.new(value)
      field.encoded.should == result
      field.decoded.should == value
      field.value.should == value
      $KCODE = original
    end

    it "should wrap an encoded at 60 characters" do
      original = $KCODE
      value = "かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ かきくけこ"
      if RUBY_VERSION < '1.9'
        $KCODE = 'u'
        result = "Subject: =?UTF-8?B?44GL44GN44GP44GR44GTIOOBi+OBjeOBj+OBkeOBkw==?=\r\n\t=?UTF-8?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZM=?=\r\n\t=?UTF-8?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZM=?=\r\n\t=?UTF-8?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZM=?=\r\n\t=?UTF-8?B?IOOBi+OBjeOBj+OBkeOBkw==?=\r\n"
      else
        value.force_encoding('UTF-8')
        result = "Subject: =?UTF-8?B?44GL44GN44GP44GR44GTIOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHj?= =?UTF-8?B?gZMg44GL44GN44GP44GR44GTIOOBi+OBjeOBj+OBkeOBkw==?=\r\n\t=?UTF-8?B?IOOBi+OBjeOBj+OBkeOBkyDjgYvjgY3jgY/jgZHjgZMg44GL44GN44GP44GR?= =?UTF-8?B?44GTIOOBi+OBjeOBj+OBkeOBkw==?=\r\n"
      end
      field = Mail::SubjectField.new(value)
      field.encoded.should == result
      field.decoded.should == value
      field.value.should == value
      $KCODE = original
    end
  
    it "should handle charsets in assigned addresses" do
      pending
      value = '"かきくけこ" <mikel@test.lindsaar.net>'
      RUBY_VERSION < '1.9' ? $KCODE = 'u' : value.force_encoding('UTF-8')
      field = Mail::FromField.new(value)
      field.encoded.should == "From: =?UTF8?B?44GL44GN44GP44GR44GT?=\r\n\t <mikel@test.lindsaar.net>\r\n"
      field.decoded.should == value
      field.value.should == value
    end
    
  end

end
