
require 'spec_helper'

describe 'core_extensions/string' do

  describe "to_crlf" do

    it "should change a single LF to CRLF" do
      "\n".to_crlf.should eq "\r\n"
    end

    it "should change multiple LF to CRLF" do
      "\n\n".to_crlf.should eq "\r\n\r\n"
    end

    it "should change a single CR to CRLF" do
      "\r".to_crlf.should eq "\r\n"
    end

    it "should not change CRLF" do
      "\r\n".to_crlf.should eq "\r\n"
    end

    it "should not change multiple CRLF" do
      "\r\n\r\n".to_crlf.should eq "\r\n\r\n"
    end

    it "should handle a mix" do
      "\r \n\r\n".to_crlf.should eq "\r\n \r\n\r\n"
    end
  end

  describe "to_lf" do
    it "should change a single CR to LF" do
      "\r".to_lf.should eq "\n"
    end

    it "should change multiple LF to CRLF" do
      "\r\r".to_lf.should eq "\n\n"
    end

    it "should change a single CRLF to LF" do
      "\r\n".to_lf.should eq "\n"
    end

    it "should change multiple CR to LF" do
      "\r\n\r\n".to_lf.should eq "\n\n"
    end

    it "should not change LF" do
      "\n".to_lf.should eq "\n"
    end

    it "should not change multiple CRLF" do
      "\n\n".to_lf.should eq "\n\n"
    end

    it "should handle a mix" do
      "\r \n\r\n".to_lf.should eq "\n \n\n"
    end
  end

  describe 'constantize' do
    it 'should converts string to constant' do
      "Kernel".constantize.should eq Kernel
    end
  end

end
