require File.dirname(__FILE__) + '/../spec_helper'

require 'mail'

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


end