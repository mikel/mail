require 'spec_helper'

describe Mail::ContentDescriptionField do
  # Content-Description Header Field
  #
  # The ability to associate some descriptive information with a given
  # body is often desirable.  For example, it may be useful to mark an
  # "image" body as "a picture of the Space Shuttle Endeavor."  Such text
  # may be placed in the Content-Description header field.  This header
  # field is always optional.
  #
  #   description := "Content-Description" ":" *text
  #
  # The description is presumed to be given in the US-ASCII character
  # set, although the mechanism specified in RFC 2047 may be used for
  # non-US-ASCII Content-Description values.
  #
  
  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ContentDescriptionField.new("Content-Description: This is a description") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      t = Mail::ContentDescriptionField.new('Content-Description: This is a description')
      expect(t.name).to eq 'Content-Description'
      expect(t.value).to eq 'This is a description'
    end

    it "should accept a string without the field name" do
      t = Mail::ContentDescriptionField.new('This is a description')
      expect(t.name).to eq 'Content-Description'
      expect(t.value).to eq 'This is a description'
    end

  end

end
