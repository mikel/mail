# encoding: utf-8
require 'spec_helper'

describe Mail::ResentMessageIdField do

  it "should initialize" do
    expect(doing { Mail::ResentMessageIdField.new("<1234@test.lindsaar.net>") }).not_to raise_error
  end

  it "should accept a string with the field name" do
    t = Mail::ResentMessageIdField.new('Resent-Message-ID: <1234@test.lindsaar.net>')
    expect(t.name).to eq 'Resent-Message-ID'
    expect(t.value).to eq '<1234@test.lindsaar.net>'
    expect(t.message_id).to eq '1234@test.lindsaar.net'
  end
  
  it "should accept a string without the field name" do
    t = Mail::ResentMessageIdField.new('<1234@test.lindsaar.net>')
    expect(t.name).to eq 'Resent-Message-ID'
    expect(t.value).to eq '<1234@test.lindsaar.net>'
    expect(t.message_id).to eq '1234@test.lindsaar.net'
  end

  it "should output lines shorter than 998 chars" do
    k = Mail::ResentMessageIdField.new('<Kohciuku@apholoVu.com> <foovohPu@Thegahsh.com> <UuseZeow@oocieBie.com> <UchaeKoo@eeJoukie.com> <ieKahque@ieGoochu.com> <aZaXaeva@ungaiGai.com> <sheiraiK@ookaiSha.com> <weijooPi@ahfuRaeh.com> <FiruJeur@weiphohP.com> <cuadoiQu@aiZuuqua.com> <YohGieVe@Reacepae.com> <Ieyechum@ephooGho.com> <uGhievoo@vusaeciM.com> <ouhieTha@leizaeTi.com> <ohgohGhu@jieNgooh.com> <ahNookah@oChiecoo.com> <taeWieTu@iuwiLooZ.com> <Kohraiji@AizohGoa.com> <hiQuaegh@eeluThii.com> <Uunaesoh@UogheeCh.com> <JeQuahMa@Thahchoh.com> <aaxohJoh@ahfaeCho.com> <Pahneehu@eehooChi.com> <angeoKah@Wahsaeme.com> <ietovoaV@muewaeZi.com> <aebiuZur@oteeYaiF.com> <pheiXahw@Muquahba.com> <aNgiaPha@bohliNge.com> <Eikawohf@IevaiQuu.com> <gihaeduZ@Raighiey.com> <Theequoh@hoamaeSa.com> <VeiVooyi@aimuQuoo.com> <ahGoocie@BohpheVi.com> <roivahPa@uPhoghai.com> <gioZohli@Gaochoow.com> <eireLair@phaevieR.com> <TahthaeC@oolaiBei.com> <phuYeika@leiKauPh.com> <BieYenoh@Xaebaalo.com> <xohvaeWa@ahghaeRe.com> <thoQuohV@Ubooheay.com> <pheeWohV@feicaeNg.com>')
    lines = k.encoded.split("\r\n\s")
    lines.each { |line| expect(line.length).to be < 998 }
  end
end
