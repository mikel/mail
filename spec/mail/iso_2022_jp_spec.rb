# coding: utf-8

require 'spec_helper'
require 'nkf'

describe "mail with iso-2022-jp encoding" do
  it "should send with ISO-2022-JP encoding" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from '山田太郎 <taro@example.com>'
      sender 'X事務局 <info@example.com>'
      reply_to 'X事務局 <info@example.com>'
      to '佐藤花子 <hanako@example.com>'
      cc 'X事務局 <info@example.com>'
      resent_from '山田太郎 <taro@example.com>'
      resent_sender 'X事務局 <info@example.com>'
      resent_to '佐藤花子 <hanako@example.com>'
      resent_cc 'X事務局 <info@example.com>'
      subject '日本語 件名'
      body '日本語本文'
    end

    mail.charset.should eq 'ISO-2022-JP'
    NKF.guess(mail.subject).should eq NKF::JIS
    mail[:from].encoded.should eq "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n"
    mail[:sender].encoded.should eq "Sender: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n"
    mail[:reply_to].encoded.should eq "Reply-To: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n"
    mail[:to].encoded.should eq "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n"
    mail[:cc].encoded.should eq "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n"
    mail[:resent_from].encoded.should eq "Resent-From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>\r\n"
    mail[:resent_to].encoded.should eq "Resent-To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>\r\n"
    mail[:resent_cc].encoded.should eq "Resent-Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>\r\n"
    mail[:subject].encoded.should eq "Subject: =?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=\?=\r\n"
    NKF.guess(mail.body.encoded).should eq NKF::JIS
  end

  it "should not encode empty subject" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from '山田太郎 <taro@example.com>'
      to '佐藤花子 <hanako@example.com>'
      subject ''
      body '日本語本文'
    end

    mail.charset.should eq 'ISO-2022-JP'
    mail[:subject].encoded.should eq "Subject: \r\n"
  end

  it "should not encode when the subject includes only ascii characters" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from '山田太郎 <taro@example.com>'
      to '佐藤花子 <hanako@example.com>'
      subject 'Hello!'
      body '日本語本文'
    end

    mail.charset.should eq 'ISO-2022-JP'
    mail[:subject].encoded.should eq "Subject: Hello!\r\n"
  end

  it "should not encode when the subject is already encoded" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from '山田太郎 <taro@example.com>'
      to '佐藤花子 <hanako@example.com>'
      subject "=?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=\?="
      body '日本語本文'
    end

    mail.charset.should eq 'ISO-2022-JP'
    mail[:subject].encoded.should eq "Subject: =?ISO-2022-JP?B?GyRCRnxLXDhsGyhCIBskQjdvTD4bKEI=\?=\r\n"
  end

  it "should handle array correctly" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from [ '山田太郎 <taro@example.com>', '山田次郎 <jiro@example.com>' ]
      to [ '佐藤花子 <hanako@example.com>', '佐藤好子 <yoshiko@example.com>' ]
      cc [ 'X事務局 <info@example.com>',  '事務局長 <boss@example.com>' ]
      subject '日本語件名'
      body '日本語本文'
    end

    mail[:from].encoded.should eq "From: =?ISO-2022-JP?B?GyRCOzNFREJATzobKEI=?= <taro@example.com>, \r\n =?ISO-2022-JP?B?GyRCOzNFRDwhTzobKEI=?= <jiro@example.com>\r\n"
    mail[:to].encoded.should eq "To: =?ISO-2022-JP?B?GyRCOjRGIzJWO1IbKEI=?= <hanako@example.com>, \r\n =?ISO-2022-JP?B?GyRCOjRGIzklO1IbKEI=?= <yoshiko@example.com>\r\n"
    mail[:cc].encoded.should eq "Cc: =?ISO-2022-JP?B?WBskQjt2TDM2SRsoQg==?= <info@example.com>, \r\n =?ISO-2022-JP?B?GyRCO3ZMMzZJRDkbKEI=?= <boss@example.com>\r\n"
  end

  if RUBY_VERSION >= '1.9'
    it "should raise exeception if the encoding of subject is not UTF-8" do
      doing {
        Mail.new(:charset => 'ISO-2022-JP') do
          from [ '山田太郎 <taro@example.com>' ]
          to [ '佐藤花子 <hanako@example.com>' ]
          subject NKF.nkf("-Wj", '日本語 件名')
          body '日本語本文'
        end
      }.should raise_error(Mail::InvalidEncodingError)
    end

    it "should raise exeception if the encoding of mail body is not UTF-8" do
      doing {
        Mail.new(:charset => 'ISO-2022-JP') do
          from [ '山田太郎 <taro@example.com>' ]
          to [ '佐藤花子 <hanako@example.com>' ]
          subject '日本語件名'
          body NKF.nkf("-Wj", '日本語本文')
        end
      }.should raise_error(Mail::InvalidEncodingError)
    end
  end

  it "should handle wave dash (U+301C) and fullwidth tilde (U+FF5E) correctly" do
    wave_dash = [0x301c].pack("U")
    fullwidth_tilde = [0xff5e].pack("U")

    text1 = "#{wave_dash}#{fullwidth_tilde}"
    text2 = "#{wave_dash}#{wave_dash}"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text1
      body text1
    end

    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{text2}\r\n"
    mail.body.encoded.should eq "\e$B!A!A\e(B"
    NKF.nkf('-w', mail.body.encoded).should eq text2
  end

  it "should handle minus sign (U+2212) and fullwidth hypen minus (U+ff0d) correctly" do
    minus_sign = [0x2212].pack("U")
    fullwidth_hyphen_minus = [0xff0d].pack("U")

    text1 = "#{minus_sign}#{fullwidth_hyphen_minus}"
    text2 = "#{minus_sign}#{minus_sign}"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text1
      body text1
    end

    mail[:subject].encoded.should eq "Subject: =?ISO-2022-JP?B?GyRCIV0hXRsoQg==?=\r\n"
    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{text2}\r\n"
    mail.body.encoded.should eq "\e$B!]!]\e(B"
    NKF.nkf('-w', mail.body.encoded).should eq text2
  end

  it "should handle em dash (U+2014) and horizontal bar (U+2015) correctly" do
    em_dash = [0x2014].pack("U")
    horizontal_bar = [0x2015].pack("U")

    text1 = "#{em_dash}#{horizontal_bar}"
    text2 = "#{em_dash}#{em_dash}"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text1
      body text1
    end

    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{text2}\r\n"
    mail.body.encoded.should eq "\e$B!=!=\e(B"
    NKF.nkf('-w', mail.body.encoded).should eq text2
  end

  it "should handle double vertical line (U+2016) and parallel to (U+2225) correctly" do
    double_vertical_line = [0x2016].pack("U")
    parallel_to = [0x2225].pack("U")

    text1 = "#{double_vertical_line}#{parallel_to}"
    text2 = "#{double_vertical_line}#{double_vertical_line}"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text1
      body text1
    end

    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{text2}\r\n"
    mail.body.encoded.should eq "\e$B!B!B\e(B"
    NKF.nkf('-w', mail.body.encoded).should eq text2
  end

  # FULLWIDTH REVERSE SOLIDUS (0xff3c) ＼
  # FULLWIDTH CENT SIGN       (0xffe0) ￠
  # FULLWIDTH POUND SIGN      (0xffe1) ￡
  # FULLWIDTH NOT SIGN        (0xffe2) ￢
  it "should handle some special characters correctly" do
    special_characters = [0xff3c, 0xffe0, 0xffe1, 0xffe2].pack("U")

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject special_characters
      body special_characters
    end

    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{special_characters}\r\n"
    NKF.nkf('-w', mail.body.encoded).should eq special_characters
  end

  it "should handle numbers in circle correctly" do
    text = "①②③④⑤⑥⑦⑧⑨"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{text}\r\n"
    NKF.nkf('-w', mail.body.encoded).should eq text
  end

  it "should handle 'hashigodaka' and 'tatsusaki' correctly" do
    text = "髙﨑"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    NKF.nkf('-mw', mail[:subject].encoded).should eq "Subject: #{text}\r\n"
    mail[:subject].encoded.should eq "Subject: =?ISO-2022-JP?B?GyRCfGJ5dRsoQg==?=\r\n"
    NKF.nkf('-w', mail.body.encoded).should eq text

    if RUBY_VERSION >= '1.9'
      mail.body.encoded.force_encoding('ascii-8bit').should eq NKF.nkf('--oc=CP50220 -j', text).force_encoding('ascii-8bit')
    else
      mail.body.encoded.should eq NKF.nkf('--oc=CP50220 -j', text)
    end
  end

  it "should handle hankaku kana correctly" do
    text = "ｱｲｳｴｵ"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    NKF.nkf('-mxw', mail[:subject].encoded).should eq "Subject: #{text}\r\n"
    NKF.nkf('-xw', mail.body.encoded).should eq text
  end

  it "should handle frozen texts correctly" do
    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject "text".freeze
      body "text".freeze
    end

    NKF.nkf('-mxw', mail[:subject].encoded).should eq "Subject: text\r\n"
    NKF.nkf('-xw', mail.body.encoded).should eq "text"
  end

  it "should convert ibm special characters correctly" do
    text = "髙﨑"
    j = NKF.nkf('--oc=CP50220 -j', text)
    Base64.encode64(j).gsub("\n", "").should eq "GyRCfGJ5dRsoQg=="
  end

  it "should convert wave dash to zenkaku" do
    fullwidth_tilde = "～"
    fullwidth_tilde.unpack("C*").should eq [0xef, 0xbd, 0x9e]
    wave_dash = "〜"
    wave_dash.unpack("C*").should eq [0xe3, 0x80, 0x9c]

    j = NKF.nkf('--oc=CP50220 -j', fullwidth_tilde)
    NKF.nkf("-w", j).should eq wave_dash
  end

  it "should keep hankaku kana as is" do
    text = "ｱｲｳｴｵ"
    j = NKF.nkf('--oc=CP50220 -x -j', text)
    e = Base64.encode64(j).gsub("\n", "")
    e.should eq "GyhJMTIzNDUbKEI="
    NKF.nkf("-xw", j).should eq "ｱｲｳｴｵ"
  end

  it "should replace unconvertable characters with question marks" do
    text = "(\xe2\x88\xb0\xe2\x88\xb1\xe2\x88\xb2)"

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject text
      body text
    end

    NKF.nkf('-mJwx', mail[:subject].encoded).should eq "Subject: (???)\r\n"
    NKF.nkf('-Jwx', mail.body.encoded).should eq "(???)"
  end

  it "should encode the text part of multipart mail" do
    text = 'こんにちは、世界！'

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject 'Greetings'
    end

    mail.html_part = Mail::Part.new do
      content_type "text/html; charset=UTF-8"
      body "<p>#{text}</p>"
    end

    mail.text_part = Mail::Part.new do
      body text
    end

    NKF.guess(mail.text_part.body.encoded).should eq NKF::JIS
  end

  it "should not encode the text part of multipart mail if the charset is set" do
    text = 'こんにちは、世界！'

    mail = Mail.new(:charset => 'ISO-2022-JP') do
      from 'taro@example.com'
      to 'hanako@example.com'
      subject 'Greetings'
    end

    mail.html_part = Mail::Part.new do
      content_type "text/html; charset=UTF-8"
      body "<p>#{text}</p>"
    end

    mail.text_part = Mail::Part.new(:charset => 'UTF-8') do
      body text
    end

    mail.text_part.body.encoded.should eq text
  end
end
