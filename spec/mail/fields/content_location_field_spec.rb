require 'spec_helper'

describe Mail::ContentLocationField do

  # Content-Location Header Field
  # 
  describe "initialization" do

    it "should initialize" do
      doing { Mail::ContentLocationField.new("Content-Location", "7bit") }.should_not raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::ContentLocationField.new('Content-Location: photo.jpg')
      t.name.should == 'Content-Location'
      t.value.should == 'photo.jpg'
    end

    it "should accept a string without the field name" do
      t = Mail::ContentLocationField.new('photo.jpg')
      t.name.should == 'Content-Location'
      t.value.should == 'photo.jpg'
    end

    it "should render an encoded field" do
      t = Mail::ContentLocationField.new('photo.jpg')
      t.encoded.should == "Content-Location: photo.jpg\r\n"
    end

    it "should render a decoded field" do
      t = Mail::ContentLocationField.new('photo.jpg')
      t.decoded.should == 'photo.jpg'
    end

  end

  describe "parsing the value" do
    
    it "should return an encoding string unquoted" do
      t = Mail::ContentLocationField.new('"A quoted filename.jpg"')
      t.location.should == 'A quoted filename.jpg'
    end
    
  end

end
