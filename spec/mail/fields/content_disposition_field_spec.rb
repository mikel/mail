require 'spec_helper'

describe Mail::ContentDispositionField do

  describe "initialization" do

    it "should initialize" do
      expect(doing { Mail::ContentDispositionField.new("attachment; filename=File") }).not_to raise_error
    end

    it "should accept a string with the field name" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      expect(c.name).to eq 'Content-Disposition'
      expect(c.value).to eq 'attachment; filename=File'
    end

    it "should accept a string without the field name" do
      c = Mail::ContentDispositionField.new('attachment; filename=File')
      expect(c.name).to eq 'Content-Disposition'
      expect(c.value).to eq 'attachment; filename=File'
    end

    it "should accept a nil value and generate a disposition type" do
      c = Mail::ContentDispositionField.new(nil)
      expect(c.name).to eq 'Content-Disposition'
      expect(c.value).not_to be_nil
    end

    it "should render encoded" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      expect(c.encoded).to eq "Content-Disposition: attachment;\r\n\sfilename=File\r\n"
    end

    it "should render encoded for inline" do
      c = Mail::ContentDispositionField.new('Content-Disposition: inline')
      expect(c.encoded).to eq "Content-Disposition: inline\r\n"
    end

    it "should wrap a filename in double quotation marks only if the filename contains spaces and does not already have double quotation marks" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=This is a bad filename.txt')
      expect(c.value).to eq 'attachment; filename="This is a bad filename.txt"'

      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=some.jpg')
      expect(c.value).to eq 'attachment; filename=some.jpg'

      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename="Bad filename but at least it is wrapped in quotes.txt"')
      expect(c.value).to eq 'attachment; filename="Bad filename but at least it is wrapped in quotes.txt"'
    end

    it "should render decoded" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      expect(c.decoded).to eq 'attachment; filename=File'
    end

    it "should render decoded inline" do
      c = Mail::ContentDispositionField.new('Content-Disposition: inline')
      expect(c.decoded).to eq 'inline'
    end

    it "should handle upper and mixed case INLINE and AttachMent" do
      c = Mail::ContentDispositionField.new('Content-Disposition: INLINE')
      expect(c.decoded).to eq 'inline'
      c = Mail::ContentDispositionField.new('Content-Disposition: AttachMent')
      expect(c.decoded).to eq 'attachment'
    end
  end

  describe "instance methods" do
    it "should give its disposition type" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      expect(c.disposition_type).to eq 'attachment'
      expect(c.parameters).to eql({"filename" => 'File'})
    end

    # see spec/fixtures/trec_2005_corpus/missing_content_disposition.eml
    it "should accept a blank disposition type" do
      c = Mail::ContentDispositionField.new('Content-Disposition: ')
      expect(c.disposition_type).not_to be_nil
    end
  end

end
