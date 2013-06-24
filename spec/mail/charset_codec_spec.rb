require 'spec_helper'
 
require 'mail/charset_codec'

module Mail
  class TestCodec < CharsetCodec::Base
  end

  describe CharsetCodec do
    let(:codec) { CharsetCodec.new }
    let(:test_codec) { TestCodec.new }
    before do
      @original_codecs = CharsetCodec.instance_variable_get(:@codecs).clone
    end

    after do
      # clear @codecs in CharsetCodec
      CharsetCodec.instance_variable_set(:@codecs, @original_codecs)
    end

    describe '.find' do
      it 'should find if name registered' do
        CharsetCodec.register('base', test_codec)
        expect(CharsetCodec.find('base')).to eq(test_codec)
      end

      it 'should be CharsetCodec instance if name not present in codecs' do
        expect(CharsetCodec.find(:non_existent)).to be_instance_of(CharsetCodec::Base)
      end
    end

    describe '.register' do
      it 'should register codec' do
        CharsetCodec.register('name', test_codec)
        expect(CharsetCodec.instance_variable_get(:@codecs)['name']).to eq(test_codec)
      end

      it 'should be case-insensitive' do
        CharsetCodec.register('NaME', test_codec)
        expect(CharsetCodec.instance_variable_get(:@codecs)['name']).to eq(test_codec)
      end
    end

    describe '.find_by_encoding_of' do
      context 'when argument responds to encoding' do
        it 'should find by parameter encoding' do
          utf8codec = TestCodec.new
          CharsetCodec.register('UTF-8', utf8codec)
          string = 'string'.encode(Encoding.find('UTF-8'))
          expect(CharsetCodec.find_by_encoding_of(string)).to eq(utf8codec)
        end

        it 'should return default if none found' do
          string = 'string'.encode(Encoding.find('UTF-8'))
          expect(CharsetCodec.find_by_encoding_of(string)).to be_instance_of(CharsetCodec::Base)
        end
      end

      context 'when argument does not respond to encoding' do
        it 'should be CharsetCodec' do
          expect(CharsetCodec.find_by_encoding_of(1)).to be_instance_of(CharsetCodec::Base)
        end
      end
    end

  end
end
