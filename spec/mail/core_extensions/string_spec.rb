
require 'spec_helper'

describe 'core_extensions/string' do

  describe 'constantize' do
    it 'should converts string to constant' do
      expect("Kernel".constantize).to eq Kernel
    end
  end

end
