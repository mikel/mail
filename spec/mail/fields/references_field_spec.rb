# encoding: utf-8
require 'spec_helper'
# 
#    The "References:" field will contain the contents of the parent's
#    "References:" field (if any) followed by the contents of the parent's
#    "Message-ID:" field (if any).  If the parent message does not contain
#    a "References:" field but does have an "In-Reply-To:" field
#    containing a single message identifier, then the "References:" field
#    will contain the contents of the parent's "In-Reply-To:" field
#    followed by the contents of the parent's "Message-ID:" field (if
#    any).  If the parent has none of the "References:", "In-Reply-To:",
#    or "Message-ID:" fields, then the new message will have no
#    "References:" field.

describe Mail::ReferencesField do

  it "should initialize" do
    doing { Mail::ReferencesField.new("<1234@test.lindsaar.net>") }.should_not raise_error
  end

  it "should accept a string with the field name" do
    t = Mail::ReferencesField.new('References: <1234@test.lindsaar.net>')
    t.name.should eq 'References'
    t.value.should eq '<1234@test.lindsaar.net>'
    t.message_id.should eq '1234@test.lindsaar.net'
  end
  
  it "should accept a string without the field name" do
    t = Mail::ReferencesField.new('<1234@test.lindsaar.net>')
    t.name.should eq 'References'
    t.value.should eq '<1234@test.lindsaar.net>'
    t.message_id.should eq '1234@test.lindsaar.net'
  end

  it "should accept multiple message ids" do
    t = Mail::ReferencesField.new('<1234@test.lindsaar.net> <5678@test.lindsaar.net>')
    t.name.should eq 'References'
    t.value.should eq '<1234@test.lindsaar.net> <5678@test.lindsaar.net>'
    t.message_id.should eq '1234@test.lindsaar.net'
    t.message_ids.should eq ['1234@test.lindsaar.net', '5678@test.lindsaar.net']
    t.to_s.should eq '<1234@test.lindsaar.net> <5678@test.lindsaar.net>'
  end

  it "should accept no message ids" do
    t = Mail::ReferencesField.new('')
    t.name.should eq 'References'
    t.decoded.should eq nil
  end

  it "should output lines shorter than 998 chars" do
    k = Mail::ReferencesField.new('<Kohciuku@apholoVu.com> <foovohPu@Thegahsh.com> <UuseZeow@oocieBie.com> <UchaeKoo@eeJoukie.com> <ieKahque@ieGoochu.com> <aZaXaeva@ungaiGai.com> <sheiraiK@ookaiSha.com> <weijooPi@ahfuRaeh.com> <FiruJeur@weiphohP.com> <cuadoiQu@aiZuuqua.com> <YohGieVe@Reacepae.com> <Ieyechum@ephooGho.com> <uGhievoo@vusaeciM.com> <ouhieTha@leizaeTi.com> <ohgohGhu@jieNgooh.com> <ahNookah@oChiecoo.com> <taeWieTu@iuwiLooZ.com> <Kohraiji@AizohGoa.com> <hiQuaegh@eeluThii.com> <Uunaesoh@UogheeCh.com> <JeQuahMa@Thahchoh.com> <aaxohJoh@ahfaeCho.com> <Pahneehu@eehooChi.com> <angeoKah@Wahsaeme.com> <ietovoaV@muewaeZi.com> <aebiuZur@oteeYaiF.com> <pheiXahw@Muquahba.com> <aNgiaPha@bohliNge.com> <Eikawohf@IevaiQuu.com> <gihaeduZ@Raighiey.com> <Theequoh@hoamaeSa.com> <VeiVooyi@aimuQuoo.com> <ahGoocie@BohpheVi.com> <roivahPa@uPhoghai.com> <gioZohli@Gaochoow.com> <eireLair@phaevieR.com> <TahthaeC@oolaiBei.com> <phuYeika@leiKauPh.com> <BieYenoh@Xaebaalo.com> <xohvaeWa@ahghaeRe.com> <thoQuohV@Ubooheay.com> <pheeWohV@feicaeNg.com>')
    lines = k.encoded.split("\r\n\s")
    lines.each { |line| line.length.should < 998 }
  end

end
