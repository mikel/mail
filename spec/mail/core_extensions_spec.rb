# encoding: utf-8
require 'spec_helper'

describe Object do

  describe "blank method" do
    it "should say nil is blank" do
      expect(nil).to be_blank
    end

    it "should say false is blank" do
      expect(false).to be_blank
    end

    it "should say true is not blank" do
      expect(true).not_to be_blank
    end

    it "should say an empty array is blank" do
      expect([]).to be_blank
    end

    it "should say an empty hash is blank" do
      expect({}).to be_blank
    end

    it "should say an empty string is blank" do
      expect('').to be_blank
      expect(" ").to be_blank
      a = ''; 1000.times { a << ' ' }
      expect(a).to be_blank
      expect("\t \n\n").to be_blank
    end
  end

  describe "not blank method" do
    it "should say a number is not blank" do
      expect(1).not_to be_blank
    end
    
    it "should say a valueless hash is not blank" do
      expect({:one => nil, :two => nil}).not_to be_blank
    end
    
    it "should say a hash containing an empty hash is not blank" do
      expect({:key => {}}).not_to be_blank
    end
  end

  describe "to_lf method on String" do
    it "should leave lf as lf" do
      expect("\n".to_lf).to eq "\n"
    end

    it "should clean just cr to lf" do
      expect("\r".to_lf).to eq "\n"
    end

    it "should leave crlf as lf" do
      expect("\r\n".to_lf).to eq "\n"
    end
    
    it "should handle japanese characters" do
      string = "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
      expect(string.to_lf).to eq "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\n\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\n\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\n\n"
    end
  end

  describe "to_crlf method on String" do
    it "should clean just lf to crlf" do
      expect("\n".to_crlf).to eq "\r\n"
    end

    it "should clean just cr to crlf" do
      expect("\r".to_crlf).to eq "\r\n"
    end

    it "should leave crlf as crlf" do
      expect("\r\n".to_crlf).to eq "\r\n"
    end

    it "should handle japanese characters" do
      string = "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
      expect(string.to_crlf).to eq "\343\201\202\343\201\210\343\201\206\343\201\210\343\201\212\r\n\r\n\343\201\213\343\201\215\343\201\217\343\201\221\343\201\223\r\n\r\n\343\201\225\343\201\227\343\201\244\343\201\233\343\201\235\r\n\r\n"
    end
    
  end

  describe "methods on NilClass" do
    it "should return empty string on to_crlf" do
      expect(nil.to_crlf).to eq ''
    end

    it "should return empty string on to_lf" do
      expect(nil.to_lf).to eq ''
    end
  end

end
