# encoding: utf-8
# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Mail::YAML do

  describe "#load" do

    it 'loads YAML' do
      expect(Mail::YAML.load('{}')).to eq({})
    end
  end
end
