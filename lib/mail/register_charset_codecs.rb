require 'mail/charset_codec/iso_2022_jp_codec'
Mail::CharsetCodec.register 'iso-2022-jp', Mail::CharsetCodec::Iso2022JpCodec.new
