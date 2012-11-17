# encoding: utf-8
require 'spec_helper'

describe Mail::Address do

  describe "functionality" do

    it "should allow us to instantiate an empty address object and call inspect" do
      doing {
        Mail::Address.new.inspect
      }.should_not raise_error
    end

    it "should allow us to instantiate an empty address object and call to_s" do
      Mail::Address.new.to_s.should eq ''
    end

    it "should allow us to instantiate an empty address object and call format" do
      Mail::Address.new.format.should eq ''
    end

    it "should allow us to instantiate an empty address object and call address" do
      [nil, '', ' '].each do |input|
        Mail::Address.new(input).address.should eq nil
      end
    end

    it "should allow us to instantiate an empty address object and call local" do
      [nil, '', ' '].each do |input|
        Mail::Address.new(input).local.should eq nil
      end
    end

    it "should allow us to instantiate an empty address object and call domain" do
      [nil, '', ' '].each do |input|
        Mail::Address.new(input).domain.should eq nil
      end
    end

    ['"-Earnings...Notification-" <vodacom.co.rs>', '<56253817>'].each do |spammy_address|
      it "should allow for funky spammy address #{spammy_address}" do
        Mail::Address.new(spammy_address).address.should eq nil
      end
    end


    it "should give it's address back on :to_s if there is no display name" do
      parse_text = 'test@lindsaar.net'
      result     = 'test@lindsaar.net'
      Mail::Address.new(parse_text).to_s.should eq result
    end

    it "should give it's format back on :to_s if there is a display name" do
      parse_text = 'Mikel Lindsaar <test@lindsaar.net>'
      result     = 'Mikel Lindsaar <test@lindsaar.net>'
      Mail::Address.new(parse_text).to_s.should eq result
    end

    it "should give back the display name" do
      parse_text = 'Mikel Lindsaar <test@lindsaar.net>'
      result     = 'Mikel Lindsaar'
      a          = Mail::Address.new(parse_text)
      a.display_name.should eq result
    end

    it "should preserve the display name passed in" do
      parse_text = '"Mikel Lindsaar" <mikel@test.lindsaar.net>'
      result     = 'Mikel Lindsaar'
      a          = Mail::Address.new(parse_text)
      a.display_name.should eq result
    end

    it "should preserve the display name passed in with token unsafe chars" do
      parse_text = '"Mikel@@@Lindsaar" <mikel@test.lindsaar.net>'
      result     = 'Mikel@@@Lindsaar'
      a          = Mail::Address.new(parse_text)
      a.display_name.should eq result
    end

    it "should give back the local part" do
      parse_text = 'Mikel Lindsaar <test@lindsaar.net>'
      result     = 'test'
      a          = Mail::Address.new(parse_text)
      a.local.should eq result
    end

    it "should give back the domain" do
      parse_text = 'Mikel Lindsaar <test@lindsaar.net>'
      result     = 'lindsaar.net'
      a          = Mail::Address.new(parse_text)
      a.domain.should eq result
    end

    it "should give back the formated address" do
      parse_text = 'Mikel Lindsaar <test@lindsaar.net>'
      result     = 'Mikel Lindsaar <test@lindsaar.net>'
      a          = Mail::Address.new(parse_text)
      a.format.should eq result
    end

    it "should handle an address without a domain" do
      parse_text = 'test'
      result     = 'test'
      a          = Mail::Address.new(parse_text)
      a.address.should eq result
    end

    it "should handle comments" do
      parse_text = "Mikel Lindsaar (author) <test@lindsaar.net>"
      result     = ['author']
      a          = Mail::Address.new(parse_text)
      a.comments.should eq result
    end

    it "should handle multiple comments" do
      parse_text = "Mikel (first name) Lindsaar (author) <test@lindsaar.net>"
      result     = ['first name', 'author']
      a          = Mail::Address.new(parse_text)
      a.comments.should eq result
    end

    it "should give back the raw value" do
      parse_text = "Mikel (first name) Lindsaar (author) <test@lindsaar.net>"
      result     = "Mikel (first name) Lindsaar (author) <test@lindsaar.net>"
      a          = Mail::Address.new(parse_text)
      a.raw.should eq result
    end

  end

  describe "assigning values directly" do
    it "should allow you to assign an address" do
      a         = Mail::Address.new
      a.address = 'mikel@test.lindsaar.net'
      a.address.should eq 'mikel@test.lindsaar.net'
      a.format.should eq 'mikel@test.lindsaar.net'
    end

    it "should allow you to assign a display name" do
      a              = Mail::Address.new
      a.display_name = 'Mikel Lindsaar'
      a.display_name.should eq 'Mikel Lindsaar'
    end

    it "should return an empty format a display name and no address defined" do
      a              = Mail::Address.new
      a.display_name = 'Mikel Lindsaar'
      a.format.should eq ''
    end

    it "should allow you to assign an address and a display name" do
      a              = Mail::Address.new
      a.address      = 'mikel@test.lindsaar.net'
      a.display_name = 'Mikel Lindsaar'
      a.format.should eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end
  end

  describe "parsing" do

    describe "basic email addresses" do
      it "should handle all OK local parts" do
        [['aamine', 'aamine'],
         ['"Minero Aoki"', '"Minero Aoki"'],
         ['"!@#$%^&*()"', '"!@#$%^&*()"'],
         ['a.b.c', 'a.b.c']

        ].each do |(words, ok)|
          a = Mail::Address.new(words)
          a.local.should eq ok
        end
      end

      it "should handle all OK domains" do
        [['loveruby.net', 'loveruby.net'],
         ['"love ruby".net', '"love ruby".net'],
         ['a."love ruby".net', 'a."love ruby".net'],
         ['"!@#$%^&*()"', '"!@#$%^&*()"'],
         ['[192.168.1.1]', '[192.168.1.1]']

        ].each do |(words, ok)|
          a = Mail::Address.new(%Q|me@#{words}|)
          a.domain.should eq ok
        end
      end
    end

    describe "email addresses from the wild" do
      it "should handle |aamine@loveruby.net|" do
        address = Mail::Address.new('aamine@loveruby.net')
        address.should break_down_to({
                                         :display_name => nil,
                                         :address      => 'aamine@loveruby.net',
                                         :local        => 'aamine',
                                         :domain       => 'loveruby.net',
                                         :format       => 'aamine@loveruby.net',
                                         :comments     => nil,
                                         :raw          => 'aamine@loveruby.net'})
      end

      it "should handle |Minero Aoki <aamine@loveruby.net>|" do
        address = Mail::Address.new('Minero Aoki <aamine@loveruby.net>')
        address.should break_down_to({
                                         :display_name => 'Minero Aoki',
                                         :address      => 'aamine@loveruby.net',
                                         :local        => 'aamine',
                                         :domain       => 'loveruby.net',
                                         :format       => 'Minero Aoki <aamine@loveruby.net>',
                                         :comments     => nil,
                                         :raw          => 'Minero Aoki <aamine@loveruby.net>'})
      end

      it "should handle |Minero Aoki<aamine@loveruby.net>|" do
        address = Mail::Address.new('Minero Aoki<aamine@loveruby.net>')
        address.should break_down_to({
                                         :display_name => 'Minero Aoki',
                                         :address      => 'aamine@loveruby.net',
                                         :local        => 'aamine',
                                         :domain       => 'loveruby.net',
                                         :format       => 'Minero Aoki <aamine@loveruby.net>',
                                         :comments     => nil,
                                         :raw          => 'Minero Aoki<aamine@loveruby.net>'})
      end

      it 'should handle |"Minero Aoki" <aamine@loveruby.net>|' do
        address = Mail::Address.new('"Minero Aoki" <aamine@loveruby.net>')
        address.should break_down_to({
                                         :display_name => 'Minero Aoki',
                                         :address      => 'aamine@loveruby.net',
                                         :local        => 'aamine',
                                         :domain       => 'loveruby.net',
                                         :format       => 'Minero Aoki <aamine@loveruby.net>',
                                         :comments     => nil,
                                         :raw          => '"Minero Aoki" <aamine@loveruby.net>'})
      end

      it "should handle |Minero Aoki<aamine@0246.loveruby.net>|" do
        address = Mail::Address.new('Minero Aoki<aamine@0246.loveruby.net>')
        address.should break_down_to({
                                         :display_name => 'Minero Aoki',
                                         :address      => 'aamine@0246.loveruby.net',
                                         :local        => 'aamine',
                                         :domain       => '0246.loveruby.net',
                                         :format       => 'Minero Aoki <aamine@0246.loveruby.net>',
                                         :comments     => nil,
                                         :raw          => 'Minero Aoki<aamine@0246.loveruby.net>'})
      end

      it "should handle lots of dots" do
        1.upto(10) do |times|
          dots    = "." * times
          address = Mail::Address.new("hoge#{dots}test@docomo.ne.jp")
          address.should break_down_to({
                                           :display_name => nil,
                                           :address      => "hoge#{dots}test@docomo.ne.jp",
                                           :local        => "hoge#{dots}test",
                                           :domain       => 'docomo.ne.jp',
                                           :format       => "hoge#{dots}test@docomo.ne.jp",
                                           :comments     => nil,
                                           :raw          => "hoge#{dots}test@docomo.ne.jp"})
        end
      end

      it "should handle trailing dots" do
        1.upto(10) do |times|
          dots    = "." * times
          address = Mail::Address.new("hogetest#{dots}@docomo.ne.jp")
          address.should break_down_to({
                                           :display_name => nil,
                                           :address      => "hogetest#{dots}@docomo.ne.jp",
                                           :local        => "hogetest#{dots}",
                                           :domain       => 'docomo.ne.jp',
                                           :format       => "hogetest#{dots}@docomo.ne.jp",
                                           :comments     => nil,
                                           :raw          => "hogetest#{dots}@docomo.ne.jp"})
        end
      end

      it 'should handle |"Joe & J. Harvey" <ddd @Org>|' do
        address = Mail::Address.new('"Joe & J. Harvey" <ddd @Org>')
        address.should break_down_to({
                                         :name         => 'Joe & J. Harvey',
                                         :display_name => 'Joe & J. Harvey',
                                         :address      => 'ddd@Org',
                                         :domain       => 'Org',
                                         :local        => 'ddd',
                                         :format       => '"Joe & J. Harvey" <ddd@Org>',
                                         :comments     => nil,
                                         :raw          => '"Joe & J. Harvey" <ddd @Org>'})
      end

      it 'should handle |"spickett@tiac.net" <Sean.Pickett@zork.tiac.net>|' do
        address = Mail::Address.new('"spickett@tiac.net" <Sean.Pickett@zork.tiac.net>')
        address.should break_down_to({
                                         :name         => 'spickett@tiac.net',
                                         :display_name => 'spickett@tiac.net',
                                         :address      => 'Sean.Pickett@zork.tiac.net',
                                         :domain       => 'zork.tiac.net',
                                         :local        => 'Sean.Pickett',
                                         :format       => '"spickett@tiac.net" <Sean.Pickett@zork.tiac.net>',
                                         :comments     => nil,
                                         :raw          => '"spickett@tiac.net" <Sean.Pickett@zork.tiac.net>'})
      end

      it "should handle |rls@intgp8.ih.att.com (-Schieve,R.L.)|" do
        address = Mail::Address.new('rls@intgp8.ih.att.com (-Schieve,R.L.)')
        address.should break_down_to({
                                         :name         => '-Schieve,R.L.',
                                         :display_name => nil,
                                         :address      => 'rls@intgp8.ih.att.com',
                                         :comments     => ['-Schieve,R.L.'],
                                         :domain       => 'intgp8.ih.att.com',
                                         :local        => 'rls',
                                         :format       => 'rls@intgp8.ih.att.com (-Schieve,R.L.)',
                                         :raw          => 'rls@intgp8.ih.att.com (-Schieve,R.L.)'})
      end

      it "should handle |jrh%cup.portal.com@portal.unix.portal.com|" do
        address = Mail::Address.new('jrh%cup.portal.com@portal.unix.portal.com')
        address.should break_down_to({
                                         :name         => nil,
                                         :display_name => nil,
                                         :address      => 'jrh%cup.portal.com@portal.unix.portal.com',
                                         :comments     => nil,
                                         :domain       => 'portal.unix.portal.com',
                                         :local        => 'jrh%cup.portal.com',
                                         :format       => 'jrh%cup.portal.com@portal.unix.portal.com',
                                         :raw          => 'jrh%cup.portal.com@portal.unix.portal.com'})
      end

      it "should handle |astrachan@austlcm.sps.mot.com ('paul astrachan/xvt3')|" do
        address = Mail::Address.new("astrachan@austlcm.sps.mot.com ('paul astrachan/xvt3')")
        address.should break_down_to({
                                         :name         => "'paul astrachan/xvt3'",
                                         :display_name => nil,
                                         :address      => 'astrachan@austlcm.sps.mot.com',
                                         :comments     => ["'paul astrachan/xvt3'"],
                                         :domain       => 'austlcm.sps.mot.com',
                                         :local        => 'astrachan',
                                         :format       => "astrachan@austlcm.sps.mot.com ('paul astrachan/xvt3')",
                                         :raw          => "astrachan@austlcm.sps.mot.com ('paul astrachan/xvt3')"})
      end

      it "should handle 'TWINE57%SDELVB.decnet@SNYBUF.CS.SNYBUF.EDU (JAMES R. TWINE - THE NERD)'" do
        address = Mail::Address.new('TWINE57%SDELVB.decnet@SNYBUF.CS.SNYBUF.EDU (JAMES R. TWINE - THE NERD)')
        address.should break_down_to({
                                         :name         => 'JAMES R. TWINE - THE NERD',
                                         :display_name => nil,
                                         :address      => 'TWINE57%SDELVB.decnet@SNYBUF.CS.SNYBUF.EDU',
                                         :comments     => ['JAMES R. TWINE - THE NERD'],
                                         :domain       => 'SNYBUF.CS.SNYBUF.EDU',
                                         :local        => 'TWINE57%SDELVB.decnet',
                                         :format       => 'TWINE57%SDELVB.decnet@SNYBUF.CS.SNYBUF.EDU (JAMES R. TWINE - THE NERD)',
                                         :raw          => 'TWINE57%SDELVB.decnet@SNYBUF.CS.SNYBUF.EDU (JAMES R. TWINE - THE NERD)'})
      end

      it "should be able to handle 'David Apfelbaum <da0g+@andrew.cmu.edu>'" do
        address = Mail::Address.new('David Apfelbaum <da0g+@andrew.cmu.edu>')
        address.should break_down_to({
                                         :name         => 'David Apfelbaum',
                                         :display_name => 'David Apfelbaum',
                                         :address      => 'da0g+@andrew.cmu.edu',
                                         :comments     => nil,
                                         :domain       => 'andrew.cmu.edu',
                                         :local        => 'da0g+',
                                         :format       => 'David Apfelbaum <da0g+@andrew.cmu.edu>',
                                         :raw          => 'David Apfelbaum <da0g+@andrew.cmu.edu>'})
      end

      it 'should handle |"JAMES R. TWINE - THE NERD" <TWINE57%SDELVB%SNYDELVA.bitnet@CUNYVM.CUNY.EDU>|' do
        address = Mail::Address.new('"JAMES R. TWINE - THE NERD" <TWINE57%SDELVB%SNYDELVA.bitnet@CUNYVM.CUNY.EDU>')
        address.should break_down_to({
                                         :name         => 'JAMES R. TWINE - THE NERD',
                                         :display_name => 'JAMES R. TWINE - THE NERD',
                                         :address      => 'TWINE57%SDELVB%SNYDELVA.bitnet@CUNYVM.CUNY.EDU',
                                         :comments     => nil,
                                         :domain       => 'CUNYVM.CUNY.EDU',
                                         :local        => 'TWINE57%SDELVB%SNYDELVA.bitnet',
                                         :format       => '"JAMES R. TWINE - THE NERD" <TWINE57%SDELVB%SNYDELVA.bitnet@CUNYVM.CUNY.EDU>',
                                         :raw          => '"JAMES R. TWINE - THE NERD" <TWINE57%SDELVB%SNYDELVA.bitnet@CUNYVM.CUNY.EDU>'})
      end

      it "should handle '/G=Owen/S=Smith/O=SJ-Research/ADMD=INTERSPAN/C=GB/@mhs-relay.ac.uk'" do
        address = Mail::Address.new('/G=Owen/S=Smith/O=SJ-Research/ADMD=INTERSPAN/C=GB/@mhs-relay.ac.uk')
        address.should break_down_to({
                                         :name         => nil,
                                         :display_name => nil,
                                         :address      => '/G=Owen/S=Smith/O=SJ-Research/ADMD=INTERSPAN/C=GB/@mhs-relay.ac.uk',
                                         :comments     => nil,
                                         :domain       => 'mhs-relay.ac.uk',
                                         :local        => '/G=Owen/S=Smith/O=SJ-Research/ADMD=INTERSPAN/C=GB/',
                                         :format       => '/G=Owen/S=Smith/O=SJ-Research/ADMD=INTERSPAN/C=GB/@mhs-relay.ac.uk',
                                         :raw          => '/G=Owen/S=Smith/O=SJ-Research/ADMD=INTERSPAN/C=GB/@mhs-relay.ac.uk'})
      end

      it 'should handle |"Stephen Burke, Liverpool" <BURKE@vxdsya.desy.de>|' do
        address = Mail::Address.new('"Stephen Burke, Liverpool" <BURKE@vxdsya.desy.de>')
        address.should break_down_to({
                                         :name         => 'Stephen Burke, Liverpool',
                                         :display_name => 'Stephen Burke, Liverpool',
                                         :address      => 'BURKE@vxdsya.desy.de',
                                         :comments     => nil,
                                         :domain       => 'vxdsya.desy.de',
                                         :local        => 'BURKE',
                                         :format       => '"Stephen Burke, Liverpool" <BURKE@vxdsya.desy.de>',
                                         :raw          => '"Stephen Burke, Liverpool" <BURKE@vxdsya.desy.de>'})
      end

      it "should handle 'The Newcastle Info-Server <info-admin@newcastle.ac.uk>'" do
        address = Mail::Address.new('The Newcastle Info-Server <info-admin@newcastle.ac.uk>')
        address.should break_down_to({
                                         :name         => 'The Newcastle Info-Server',
                                         :display_name => 'The Newcastle Info-Server',
                                         :address      => 'info-admin@newcastle.ac.uk',
                                         :comments     => nil,
                                         :domain       => 'newcastle.ac.uk',
                                         :local        => 'info-admin',
                                         :format       => 'The Newcastle Info-Server <info-admin@newcastle.ac.uk>',
                                         :raw          => 'The Newcastle Info-Server <info-admin@newcastle.ac.uk>'})
      end

      it "should handle 'Suba.Peddada@eng.sun.com (Suba Peddada [CONTRACTOR])'" do
        address = Mail::Address.new('Suba.Peddada@eng.sun.com (Suba Peddada [CONTRACTOR])')
        address.should break_down_to({
                                         :name         => 'Suba Peddada [CONTRACTOR]',
                                         :display_name => nil,
                                         :address      => 'Suba.Peddada@eng.sun.com',
                                         :comments     => ['Suba Peddada [CONTRACTOR]'],
                                         :domain       => 'eng.sun.com',
                                         :local        => 'Suba.Peddada',
                                         :format       => 'Suba.Peddada@eng.sun.com (Suba Peddada [CONTRACTOR])',
                                         :raw          => 'Suba.Peddada@eng.sun.com (Suba Peddada [CONTRACTOR])'})
      end

      it "should handle 'Paul Manser (0032 memo) <a906187@tiuk.ti.com>'" do
        address = Mail::Address.new('Paul Manser (0032 memo) <a906187@tiuk.ti.com>')
        address.should break_down_to({
                                         :name         => 'Paul Manser',
                                         :display_name => 'Paul Manser',
                                         :address      => 'a906187@tiuk.ti.com',
                                         :comments     => ['0032 memo'],
                                         :domain       => 'tiuk.ti.com',
                                         :local        => 'a906187',
                                         :format       => 'Paul Manser <a906187@tiuk.ti.com> (0032 memo)',
                                         :raw          => 'Paul Manser (0032 memo) <a906187@tiuk.ti.com>'})
      end

      it 'should handle |"gregg (g.) woodcock" <woodcock@bnr.ca>|' do
        address = Mail::Address.new('"gregg (g.) woodcock" <woodcock@bnr.ca>')
        address.should break_down_to({
                                         :name         => 'gregg (g.) woodcock',
                                         :display_name => 'gregg (g.) woodcock',
                                         :address      => 'woodcock@bnr.ca',
                                         :comments     => nil,
                                         :domain       => 'bnr.ca',
                                         :local        => 'woodcock',
                                         :format       => '"gregg (g.) woodcock" <woodcock@bnr.ca>',
                                         :raw          => '"gregg (g.) woodcock" <woodcock@bnr.ca>'})
      end

      it 'should handle |Graham.Barr@tiuk.ti.com|' do
        address = Mail::Address.new('Graham.Barr@tiuk.ti.com')
        address.should break_down_to({
                                         :name         => nil,
                                         :display_name => nil,
                                         :address      => 'Graham.Barr@tiuk.ti.com',
                                         :comments     => nil,
                                         :domain       => 'tiuk.ti.com',
                                         :local        => 'Graham.Barr',
                                         :format       => 'Graham.Barr@tiuk.ti.com',
                                         :raw          => 'Graham.Barr@tiuk.ti.com'})
      end

      it "should handle |a909937 (Graham Barr          (0004 bodg))|" do
        address = Mail::Address.new('a909937 (Graham Barr          (0004 bodg))')
        address.should break_down_to({
                                         :name         => 'Graham Barr (0004 bodg)',
                                         :display_name => nil,
                                         :address      => 'a909937',
                                         :comments     => ['Graham Barr (0004 bodg)'],
                                         :domain       => nil,
                                         :local        => 'a909937',
                                         :format       => 'a909937 (Graham Barr \(0004 bodg\))',
                                         :raw          => 'a909937 (Graham Barr          (0004 bodg))'})
      end

      it "should handle |david d `zoo' zuhn <zoo@aggregate.com>|" do
        address = Mail::Address.new("david d `zoo' zuhn <zoo@aggregate.com>")
        address.should break_down_to({
                                         :name         => "david d `zoo' zuhn",
                                         :display_name => "david d `zoo' zuhn",
                                         :address      => 'zoo@aggregate.com',
                                         :comments     => nil,
                                         :domain       => 'aggregate.com',
                                         :local        => 'zoo',
                                         :format       => "david d `zoo' zuhn <zoo@aggregate.com>",
                                         :raw          => "david d `zoo' zuhn <zoo@aggregate.com>"})
      end

      it "should handle |(foo@bar.com (foobar), ned@foo.com (nedfoo) ) <kevin@goess.org>|" do
        address = Mail::Address.new('(foo@bar.com (foobar), ned@foo.com (nedfoo) ) <kevin@goess.org>')
        address.should break_down_to({
                                         :name         => 'foo@bar.com \(foobar\), ned@foo.com \(nedfoo\) ',
                                         :display_name => '(foo@bar.com \(foobar\), ned@foo.com \(nedfoo\) )',
                                         :address      => 'kevin@goess.org',
                                         :comments     => ['foo@bar.com (foobar), ned@foo.com (nedfoo) '],
                                         :domain       => 'goess.org',
                                         :local        => 'kevin',
                                         :format       => '"(foo@bar.com \\(foobar\\), ned@foo.com \(nedfoo\) )" <kevin@goess.org> (foo@bar.com \(foobar\), ned@foo.com \(nedfoo\) )',
                                         :raw          => '(foo@bar.com (foobar), ned@foo.com (nedfoo) ) <kevin@goess.org>'})
      end

      it "should handle |Pete(A wonderful ) chap) <pete(his account)@silly.test(his host)>|" do
        address = Mail::Address.new('Pete(A wonderful \) chap) <pete(his account)@silly.test(his host)>')
        address.should break_down_to({
                                         :name         => 'Pete',
                                         :display_name => 'Pete',
                                         :address      => 'pete(his account)@silly.test',
                                         :comments     => ['A wonderful \\) chap', 'his account', 'his host'],
                                         :domain       => 'silly.test',
                                         :local        => 'pete(his account)',
                                         :format       => 'Pete <pete(his account)@silly.test> (A wonderful \\) chap his account his host)',
                                         :raw          => 'Pete(A wonderful \\) chap) <pete(his account)@silly.test(his host)>'})
      end

      it "should handle |Joe Q. Public <john.q.public@example.com>|" do
        address = Mail::Address.new('Joe Q. Public <john.q.public@example.com>')
        address.should break_down_to({
                                         :name         => 'Joe Q. Public',
                                         :display_name => 'Joe Q. Public',
                                         :address      => 'john.q.public@example.com',
                                         :comments     => nil,
                                         :domain       => 'example.com',
                                         :local        => 'john.q.public',
                                         :format       => '"Joe Q. Public" <john.q.public@example.com>',
                                         :raw          => 'Joe Q. Public <john.q.public@example.com>'})
      end

      it "should handle |Mary Smith <@machine.tld:mary@example.net>|" do
        address = Mail::Address.new('Mary Smith <@machine.tld:mary@example.net>')
        address.should break_down_to({
                                         :name         => 'Mary Smith',
                                         :display_name => 'Mary Smith',
                                         :address      => '@machine.tld:mary@example.net',
                                         :comments     => nil,
                                         :domain       => 'example.net',
                                         :local        => '@machine.tld:mary',
                                         :format       => 'Mary Smith <@machine.tld:mary@example.net>',
                                         :raw          => 'Mary Smith <@machine.tld:mary@example.net>'})
      end

      it "should handle |jdoe@test   . example|" do
        pending
        address = Mail::Address.new('jdoe@test   . example')
        address.should break_down_to({
                                         :name         => 'jdoe@test.example',
                                         :display_name => 'jdoe@test.example',
                                         :address      => 'jdoe@test.example',
                                         :comments     => nil,
                                         :domain       => 'test.example',
                                         :local        => 'jdoe',
                                         :format       => 'jdoe@test.example',
                                         :raw          => 'jdoe@test.example'})
      end

      it "should handle |groupname+domain.com@example.com|" do
        address = Mail::Address.new('groupname+domain.com@example.com')
        address.should break_down_to({
                                         :name         => nil,
                                         :display_name => nil,
                                         :address      => 'groupname+domain.com@example.com',
                                         :comments     => nil,
                                         :domain       => 'example.com',
                                         :local        => 'groupname+domain.com',
                                         :format       => 'groupname+domain.com@example.com',
                                         :raw          => 'groupname+domain.com@example.com'})
      end

    end

  end

  describe "creating" do

    describe "parts of an address" do
      it "should add an address" do
        address         = Mail::Address.new
        address.address = "mikel@test.lindsaar.net"
        address.should break_down_to({:address => 'mikel@test.lindsaar.net'})
      end

      it "should add a display name" do
        address              = Mail::Address.new
        address.display_name = "Mikel Lindsaar"
        address.display_name.should eq 'Mikel Lindsaar'
      end
    end

  end

  describe "modifying an address" do
    it "should add an address" do
      address         = Mail::Address.new
      address.address = "mikel@test.lindsaar.net"
      address.should break_down_to({:address => 'mikel@test.lindsaar.net'})
    end

    it "should add a display name" do
      address              = Mail::Address.new
      address.display_name = "Mikel Lindsaar"
      address.display_name.should eq 'Mikel Lindsaar'
    end

    it "should take an address and a display name and join them" do
      address              = Mail::Address.new
      address.address      = "mikel@test.lindsaar.net"
      address.display_name = "Mikel Lindsaar"
      address.format.should eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should take a display name and an address and join them" do
      address              = Mail::Address.new
      address.display_name = "Mikel Lindsaar"
      address.address      = "mikel@test.lindsaar.net"
      address.format.should eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

  end

  describe "providing encoded and decoded outputs" do
    it "should provide an encoded output" do
      address              = Mail::Address.new
      address.display_name = "Mikel Lindsaar"
      address.address      = "mikel@test.lindsaar.net"
      address.encoded.should eq 'Mikel Lindsaar <mikel@test.lindsaar.net>'
    end

    it "should provide an encoded output for non us-ascii" do
      address              = Mail::Address.new
      address.display_name = "まける"
      address.address      = "mikel@test.lindsaar.net"
      if RUBY_VERSION >= '1.9'
        address.encoded.should eq '=?UTF-8?B?44G+44GR44KL?= <mikel@test.lindsaar.net>'
      else
        address.encoded.should eq '=?UTF8?B?44G+44GR44KL?= <mikel@test.lindsaar.net>'
      end
    end

    it "should provide an encoded output for non us-ascii" do
      address              = Mail::Address.new
      address.display_name = "まける"
      address.address      = "mikel@test.lindsaar.net"
      address.decoded.should eq '"まける" <mikel@test.lindsaar.net>'
    end

  end

end
