# encoding: utf-8
require 'spec_helper'

describe "ContentDispositionParser" do

  subject(:parser){ Mail::Parsers::ContentDispositionParser.new }

  it "should work with unquoted dates" do
    parser.parse('attachment; filename="Scan213.pdf"; size=175632; creation-date=Tue, 14 Oct 2014 10:47:01 GMT; modification-date=Mon, 13 Oct 2014 09:44:52 GMT')
  end
end
