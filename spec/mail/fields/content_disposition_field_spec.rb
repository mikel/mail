require 'spec_helper'

describe Mail::ContentDispositionField do

  describe "initialization" do

    it "should initialize" do
      doing { Mail::ContentDispositionField.new("attachment; filename=File") }.should_not raise_error
    end

    it "should accept a string with the field name" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.name.should eq 'Content-Disposition'
      c.value.should eq 'attachment; filename=File'
    end

    it "should accept a string without the field name" do
      c = Mail::ContentDispositionField.new('attachment; filename=File')
      c.name.should eq 'Content-Disposition'
      c.value.should eq 'attachment; filename=File'
    end

    it "should accept a nil value and generate a disposition type" do
      c = Mail::ContentDispositionField.new(nil)
      c.name.should eq 'Content-Disposition'
      c.value.should_not be_nil
    end

    it "should render encoded" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.encoded.should eq "Content-Disposition: attachment;\r\n\sfilename=File\r\n"
    end

    it "should render encoded for inline" do
      c = Mail::ContentDispositionField.new('Content-Disposition: inline')
      c.encoded.should eq "Content-Disposition: inline\r\n"
    end

    it "should wrap a filename in double quotation marks only if the filename contains spaces and does not already have double quotation marks" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=This is a bad filename.txt')
      c.value.should eq 'attachment; filename="This is a bad filename.txt"'

      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=some.jpg')
      c.value.should eq 'attachment; filename=some.jpg'

      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename="Bad filename but at least it is wrapped in quotes.txt"')
      c.value.should eq 'attachment; filename="Bad filename but at least it is wrapped in quotes.txt"'
    end

    it "should render decoded" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.decoded.should eq 'attachment; filename=File'
    end

    it "should render decoded inline" do
      c = Mail::ContentDispositionField.new('Content-Disposition: inline')
      c.decoded.should eq 'inline'
    end

    it "should handle upper and mixed case INLINE and AttachMent" do
      c = Mail::ContentDispositionField.new('Content-Disposition: INLINE')
      c.decoded.should eq 'inline'
      c = Mail::ContentDispositionField.new('Content-Disposition: AttachMent')
      c.decoded.should eq 'attachment'
    end
  end

  describe "instance methods" do
    it "should give it's disposition type" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.disposition_type.should eq 'attachment'
      c.parameters.should eql({"filename" => 'File'})
    end

    # see spec/fixtures/trec_2005_corpus/missing_content_disposition.eml
    it "should accept a blank disposition type" do
      c = Mail::ContentDispositionField.new('Content-Disposition: ')
      c.disposition_type.should_not be_nil
    end
  end

end
