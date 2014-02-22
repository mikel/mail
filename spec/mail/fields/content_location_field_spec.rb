require 'spec_helper'

describe Mail::ContentLocationField do

  # Content-Location Header Field
  # 
  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ContentLocationField.new("Content-Location", "7bit") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::ContentLocationField.new('Content-Location: photo.jpg')
      expect(t.name).to eq 'Content-Location'
      expect(t.value).to eq 'photo.jpg'
    end

    it "should accept a string without the field name" do
      t = Mail::ContentLocationField.new('photo.jpg')
      expect(t.name).to eq 'Content-Location'
      expect(t.value).to eq 'photo.jpg'
    end

    it "should render an encoded field" do
      t = Mail::ContentLocationField.new('photo.jpg')
      expect(t.encoded).to eq "Content-Location: photo.jpg\r\n"
    end

    it "should render a decoded field" do
      t = Mail::ContentLocationField.new('photo.jpg')
      expect(t.decoded).to eq 'photo.jpg'
    end

  end

  describe "parsing the value" do
    
    it "should return an encoding string unquoted" do
      t = Mail::ContentLocationField.new('"A quoted filename.jpg"')
      expect(t.location).to eq 'A quoted filename.jpg'
    end
    
  end

end
