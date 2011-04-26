require 'spec_helper'

describe Mail::ContentDispositionField do

  describe "initialization" do

    it "should initialize" do
      doing { Mail::ContentDispositionField.new("attachment; filename=File") }.should_not raise_error
    end

    it "should accept a string with the field name" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.name.should == 'Content-Disposition'
      c.value.should == 'attachment; filename=File'
    end

    it "should accept a string without the field name" do
      c = Mail::ContentDispositionField.new('attachment; filename=File')
      c.name.should == 'Content-Disposition'
      c.value.should == 'attachment; filename=File'
    end

    it "should accept a nil value and generate a disposition type" do
      c = Mail::ContentDispositionField.new(nil)
      c.name.should == 'Content-Disposition'
      c.value.should_not be_nil
    end

    it "should render encoded" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.encoded.should == "Content-Disposition: attachment;\r\n\sfilename=File\r\n"
    end

    it "should render encoded for inline" do
      c = Mail::ContentDispositionField.new('Content-Disposition: inline')
      c.encoded.should == "Content-Disposition: inline\r\n"
    end

    it "should render decoded" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.decoded.should == 'attachment; filename=File'
    end

    it "should render decoded inline" do
      c = Mail::ContentDispositionField.new('Content-Disposition: inline')
      c.decoded.should == 'inline'
    end

    it "should handle upper and mixed case INLINE and AttachMent" do
      c = Mail::ContentDispositionField.new('Content-Disposition: INLINE')
      c.decoded.should == 'inline'
      c = Mail::ContentDispositionField.new('Content-Disposition: AttachMent')
      c.decoded.should == 'attachment'
    end
  end

  describe "instance methods" do
    it "should give it's disposition type" do
      c = Mail::ContentDispositionField.new('Content-Disposition: attachment; filename=File')
      c.disposition_type.should == 'attachment'
      c.parameters.should == {"filename" => 'File'}
    end

    # see spec/fixtures/trec_2005_corpus/missing_content_disposition.eml
    it "should accept a blank disposition type" do
      c = Mail::ContentDispositionField.new('Content-Disposition: ')
      c.disposition_type.should_not be_nil
    end
  end

end
