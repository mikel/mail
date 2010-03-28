require 'spec_helper'
require 'mail/fields/common/common_message_id'

describe Mail::CommonMessageId do
  
  describe "encoding and decoding fields" do
    
    it "should allow us to encode a message id field" do
      field = Mail::MessageIdField.new('<ThisIsANonUniqueMessageId@me.com>')
      field.encoded.should == "Message-ID: <ThisIsANonUniqueMessageId@me.com>\r\n"
    end
    
    it "should allow us to encode a message id field" do
      field = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      field.encoded.should == "Message-ID: <1234@test.lindsaar.net>\r\n"
    end
    
    it "should allow us to encode an in reply to field" do
      field = Mail::InReplyToField.new('<1234@test.lindsaar.net>')
      field.encoded.should == "In-Reply-To: <1234@test.lindsaar.net>\r\n"
    end

    it "should allow us to decode a message id field" do
      field = Mail::MessageIdField.new('<1234@test.lindsaar.net>')
      field.decoded.should == "<1234@test.lindsaar.net>"
    end
    
  end
  
end
