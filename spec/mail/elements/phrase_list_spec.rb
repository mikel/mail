# encoding: utf-8
require 'spec_helper'

describe Mail::PhraseList do

  describe "parsing" do
    it "should parse a phrase list" do
      parse_text  = '"Mikel Lindsaar", "Mikel", you, somewhere'
      expect(doing { Mail::PhraseList.new(parse_text) }).not_to raise_error
    end

    it "should raise an error if the input is useless" do
      parse_text = nil
      expect(doing { Mail::PhraseList.new(parse_text) }).to raise_error
    end

    it "should not raise an error if the input is empty" do
      parse_text  = '""""""""""""""""'
      expect(Mail::PhraseList.new(parse_text).phrases).to eq [parse_text[1...-1]]
    end
  end
end
