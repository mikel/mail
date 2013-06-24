require 'spec_helper'

module Mail
  module CharsetCodec
    describe Base do
      let(:codec) { Base.new }

      describe '#remap_characters(value)' do
        it 'should id value' do
          expect(codec.remap_characters('encode_me')).to eq('encode_me')
        end
      end

      describe '#set_charset_on' do
        it 'should not change charset' do
          msg = Message.new
          expect {
            codec.set_charset_on(msg)
          }.to_not change(msg, :charset)
        end
      end

      describe '#preprocess' do
        it 'should return value itself' do
          expect(codec.preprocess('str')).to eq('str')
        end
      end

      describe '#preprocess_body_raw' do
        it 'should return value itself' do
          expect(codec.preprocess_body_raw('str')).to eq('str')
        end
      end

      describe '#encode' do
        it 'should return value itself' do
          expect(codec.encode('abcde')).to eq('abcde')
        end
      end

      describe '#encode_address(value)' do
        it 'should id value' do
          expect(codec.encode_address('encode_me')).to eq('encode_me')
        end
      end

      describe '#encode_crlf' do
        it 'should replace \r with =0D' do
          expect(codec.encode_crlf(".\r \r")).to eq(".=0D =0D")
        end

        it 'should replace \n with =0A' do
          expect(codec.encode_crlf("\n \n")).to eq("=0A =0A")
        end
      end

      describe '#decode_unstructured_field' do
        context 'when value is blank' do
          it 'should return nil' do
            expect(codec.decode_unstructured_field('')).to be_nil
          end
        end

        context 'when value is not blank' do
          it 'should be decoded by Encodings' do
            Encodings.should_receive(:decode_encode).with('val', :decode).and_return('decoded')
            expect(codec.decode_unstructured_field('val')).to eq('decoded')
          end
        end
      end

      describe '#decode_common_address' do
        it 'should use given address codec to decode' do
          address_codec = double('address_codec')
          address_codec.stub(:decode).with('val').and_return('decoded')
          expect(codec.decode_common_address(address_codec, 'val')).to eq('decoded')
        end
      end

      describe '#encode_common_address' do
        it 'should use given address codec to encode' do
          address_codec = double('address_codec')
          address_codec.stub(:encode).with('val', 'field_name').and_return('encoded')
          expect(codec.encode_common_address(address_codec, 'val', 'field_name')).to eq('encoded')
        end
      end
    end
  end
end
