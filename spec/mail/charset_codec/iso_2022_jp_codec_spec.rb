# encoding: UTF-8
require 'spec_helper'
 
require 'mail/charset_codec/iso_2022_jp_codec'

module Mail
  module CharsetCodec
    describe Iso2022JpCodec do
      let(:codec) { Iso2022JpCodec.new }
      describe '#remap_characters' do
        it 'should remap cahracters according to remap rules' do
          em_dash = [0x2014].pack("U")
          horizontal_bar = [0x2015].pack("U")

          raw = "#{horizontal_bar}#{em_dash}"
          remapped = "#{horizontal_bar}#{horizontal_bar}"
          expect(codec.remap_characters(raw)).to eq(remapped)
        end
      end

      describe '#set_charset_for' do
        context 'when message is passed as param' do
          it 'should set charset to iso-2022-jp if chanset nil' do
            msg = Message.new(:charset => nil)
            expect {
              Iso2022JpCodec.new.set_charset_on(msg)
            }.to change(msg, :charset).from(nil).to('iso-2022-jp')
          end

          it 'should not set charset if already set' do
            msg = Message.new(:charset => 'UTF-8')
            expect {
              Iso2022JpCodec.new.set_charset_on(msg)
            }.to_not change(msg, :charset)
          end
        end

        context 'when nil is passed as param' do
          it 'should not raise error' do
            expect {
              Iso2022JpCodec.new.set_charset_on(@nil)
            }.to_not raise_error
          end
        end
      end

      describe '#preprocess' do
        it 'should preprocess with ruby ver' do
          RubyVer.should_receive(:preprocess).with('iso-2022-jp', 'unprocessed').and_return('processed')
          expect(Iso2022JpCodec.new.preprocess('unprocessed')).to eq('processed')
        end
      end

      describe '#preprocess_body_raw' do
        it 'should preprocess_body_raw with ruby ver' do
          RubyVer.should_receive(:preprocess_body_raw).with('iso-2022-jp', 'unprocessed').and_return('processed')
          expect(Iso2022JpCodec.new.preprocess_body_raw('unprocessed')).to eq('processed')
        end
      end

      describe '#force_regexp_compatibility' do
        it 'should force encoding US-ASCII' do
          str = 'foo'
          expect(str.encoding).to_not eq('US-ASCII')
          codec.force_regexp_compatibility_on(str)
          expect(str.encoding).to eq(Encoding.find('US-ASCII'))
        end
      end

      describe '#encode' do
        context 'when value is an array' do
          let(:input) { ["あいうえお", "abcde", ""] }
          it 'should encode each element' do
            expect(codec.encode(input)).to eq(["=?ISO-2022-JP?B?GyRCJCIkJCQmJCgkKhsoQg==?=", "abcde", ""])
          end
        end

        context 'when value is strincg' do
          it 'should encode with iso-2022-jp' do
            expect(codec.encode("あいうえお")).to eq("=?ISO-2022-JP?B?GyRCJCIkJCQmJCgkKhsoQg==?=")
            expect(codec.encode("abcde")).to eq("abcde")
          end
        end
      end

      describe '#encode_address(value)' do
        context 'when array given' do
          it 'should encode each element' do
            addresses = ['"山田太郎" <taro@example.com>', '"John Doe" <jdoe@example.com>' 'encode_me']
            encoded_addresses = addresses.map {|elem| codec.encode_address(elem)}
            expect(codec.encode_address(addresses)).to eq(encoded_addresses)
          end
        end

        context 'when argument contains " <foo@example.com>" part' do
          it 'should encode input string' do
            address = '"山田太郎" <taro@example.com>'
            expect(codec.encode_address(address)).to eq("=?ISO-2022-JP?B?IhskQjszRURCQE86GyhCIg==?= <taro@example.com>")
          end
        end

        context 'when neither array nor containing address part' do
          it 'should be input itself' do
            expect(codec.encode_address('encode_me')).to eq('encode_me')
          end
        end
      end

      describe '#decode_unstructured_field' do
        it 'should return value itself' do
          expect(codec.decode_unstructured_field("あいうえお")).to eq("あいうえお")
          expect(codec.decode_unstructured_field("abcde")).to eq("abcde")
        end
      end

      describe '#decode_common_address' do
        it 'should return value itself' do
          expect(codec.decode_common_address('unused', "あいうえお")).to eq("あいうえお")
          expect(codec.decode_common_address('unused', "abcde")).to eq("abcde")
        end
      end
    end
  end
end
