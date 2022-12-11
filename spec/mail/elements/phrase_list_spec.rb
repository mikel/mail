# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::PhraseList do

  describe "parsing" do
    it "should parse a phrase list" do
      parse_text  = '"Mikel Lindsaar", "Mikel", you, somewhere'
      expect { Mail::PhraseList.new(parse_text) }.not_to raise_error
    end

    it "treats nil as an empty list" do
      list = Mail::PhraseList.new(nil)
      expect(list.phrases).to eq []
    end

    it "should not raise an error if the input is useless" do
      parse_text  = '""""""""""""""""'
      expect(Mail::PhraseList.new(parse_text).phrases).to eq [parse_text[1...-1]]
    end
  end
end
