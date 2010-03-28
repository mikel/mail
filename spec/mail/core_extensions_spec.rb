# encoding: utf-8
require 'spec_helper'

describe Object do

  describe "blank method" do
    it "should say nil is blank" do
      nil.should be_blank
    end

    it "should say false is blank" do
      false.should be_blank
    end

    it "should say true is not blank" do
      true.should_not be_blank
    end

    it "should say an empty array is blank" do
      [].should be_blank
    end

    it "should say an empty hash is blank" do
      {}.should be_blank
    end

    it "should say an empty string is blank" do
      ''.should be_blank
      " ".should be_blank
      a = ''; 1000.times { a << ' ' }
      a.should be_blank
      "\t \n\n".should be_blank
    end
  end

  describe "not blank method" do
    it "should say a number is not blank" do
      1.should_not be_blank
    end
    
    it "should say a valueless hash is not blank" do
      {:one => nil, :two => nil}.should_not be_blank
    end
    
    it "should say a hash containing an empty hash is not blank" do
      {:key => {}}.should_not be_blank
    end
  end

  describe "to_lf method on String" do
    it "should leave lf as lf" do
      "\n".to_lf.should == "\n"
    end

    it "should clean just cr to lf" do
      "\r".to_lf.should == "\n"
    end

    it "should leave crlf as lf" do
      "\r\n".to_lf.should == "\n"
    end
    
    it "should handle japanese characters" do
      string = "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
      string.to_lf.should == "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\n\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\n\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\n\n"
    end
  end

  describe "to_crlf method on String" do
    it "should clean just lf to crlf" do
      "\n".to_crlf.should == "\r\n"
    end

    it "should clean just cr to crlf" do
      "\r".to_crlf.should == "\r\n"
    end

    it "should leave crlf as crlf" do
      "\r\n".to_crlf.should == "\r\n"
    end

    it "should handle japanese characters" do
      string = "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
      string.to_crlf.should == "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
    end
    
  end

  describe "methods on NilClass" do
    it "should return empty string on to_crlf" do
      nil.to_crlf.should == ''
    end

    it "should return empty string on to_lf" do
      nil.to_lf.should == ''
    end
  end

end