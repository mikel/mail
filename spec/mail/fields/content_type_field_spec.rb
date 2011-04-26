require 'spec_helper'

describe Mail::ContentTypeField do
  # Content-Type Header Field
  #
  # The purpose of the Content-Type field is to describe the data
  # contained in the body fully enough that the receiving user agent can
  # pick an appropriate agent or mechanism to present the data to the
  # user, or otherwise deal with the data in an appropriate manner. The
  # value in this field is called a media type.
  #
  # HISTORICAL NOTE:  The Content-Type header field was first defined in
  # RFC 1049.  RFC 1049 used a simpler and less powerful syntax, but one
  # that is largely compatible with the mechanism given here.
  #
  # The Content-Type header field specifies the nature of the data in the
  # body of an entity by giving media type and subtype identifiers, and
  # by providing auxiliary information that may be required for certain
  # media types.  After the media type and subtype names, the remainder
  # of the header field is simply a set of parameters, specified in an
  # attribute=value notation.  The ordering of parameters is not
  # significant.
  #
  # In general, the top-level media type is used to declare the general
  # type of data, while the subtype specifies a specific format for that
  # type of data.  Thus, a media type of "image/xyz" is enough to tell a
  # user agent that the data is an image, even if the user agent has no
  # knowledge of the specific image format "xyz".  Such information can
  # be used, for example, to decide whether or not to show a user the raw
  # data from an unrecognized subtype -- such an action might be
  # reasonable for unrecognized subtypes of text, but not for
  # unrecognized subtypes of image or audio.  For this reason, registered
  # subtypes of text, image, audio, and video should not contain embedded
  # information that is really of a different type.  Such compound
  # formats should be represented using the "multipart" or "application"
  # types.
  #
  # Parameters are modifiers of the media subtype, and as such do not
  # fundamentally affect the nature of the content.  The set of
  # meaningful parameters depends on the media type and subtype.  Most
  # parameters are associated with a single specific subtype.  However, a
  # given top-level media type may define parameters which are applicable
  # to any subtype of that type.  Parameters may be required by their
  # defining content type or subtype or they may be optional. MIME
  # implementations must ignore any parameters whose names they do not
  # recognize.
  #
  # For example, the "charset" parameter is applicable to any subtype of
  # "text", while the "boundary" parameter is required for any subtype of
  # the "multipart" media type.
  #
  # There are NO globally-meaningful parameters that apply to all media
  # types.  Truly global mechanisms are best addressed, in the MIME
  # model, by the definition of additional Content-* header fields.
  #
  # An initial set of seven top-level media types is defined in RFC 2046.
  # Five of these are discrete types whose content is essentially opaque
  # as far as MIME processing is concerned.  The remaining two are
  # composite types whose contents require additional handling by MIME
  # processors.
  #
  # This set of top-level media types is intended to be substantially
  # complete.  It is expected that additions to the larger set of
  # supported types can generally be accomplished by the creation of new
  # subtypes of these initial types.  In the future, more top-level types
  # may be defined only by a standards-track extension to this standard.
  # If another top-level type is to be used for any reason, it must be
  # given a name starting with "X-" to indicate its non-standard status
  # and to avoid a potential conflict with a future official name.
  #
  describe "initialization" do

    it "should initialize" do
      doing { Mail::ContentTypeField.new("<1234@test.lindsaar.net>") }.should_not raise_error
    end

    it "should accept a string with the field name" do
      c = Mail::ContentTypeField.new('Content-Type: text/plain')
      c.name.should == 'Content-Type'
      c.value.should == 'text/plain'
    end

    it "should accept a string without the field name" do
      c = Mail::ContentTypeField.new('text/plain')
      c.name.should == 'Content-Type'
      c.value.should == 'text/plain'
    end

    it "should accept a nil value and generate a content_type" do
      c = Mail::ContentTypeField.new('Content-Type', nil)
      c.name.should == 'Content-Type'
      c.value.should_not be_nil
    end

    it "should render encoded" do
      c = Mail::ContentTypeField.new('Content-Type: text/plain')
      c.encoded.should == "Content-Type: text/plain\r\n"
    end

    it "should render encoded with parameters" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII; format=flowed')
      c.encoded.should == %Q{Content-Type: text/plain;\r\n\scharset=US-ASCII;\r\n\sformat=flowed\r\n}
    end

    it "should render quoted values encoded" do
      c = Mail::ContentTypeField.new('text/plain; example="foo bar"')
      c.encoded.should == %Q{Content-Type: text/plain;\r\n\sexample="foo bar"\r\n}
    end

    it "should render decoded" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII; format=flowed')
      c.decoded.should == 'text/plain; charset=US-ASCII; format=flowed'
    end

    it "should render quoted values decoded" do
      c = Mail::ContentTypeField.new('text/plain; example="foo bar"')
      c.decoded.should == 'text/plain; example="foo bar"'
    end

    it "should render " do
      c = Mail::ContentTypeField.new('message/delivery-status')
      c.main_type.should == 'message'
      c.sub_type.should == 'delivery-status'
    end
  end

  describe "instance methods" do
    it "should return a content_type" do
      c = Mail::ContentTypeField.new('text/plain')
      c.content_type.should == 'text/plain'
    end

    it "should return a content_type for the :string method" do
      c = Mail::ContentTypeField.new('text/plain')
      c.string.should == 'text/plain'
    end

    it "should return a main_type" do
      c = Mail::ContentTypeField.new('text/plain')
      c.main_type.should == 'text'
    end

    it "should return a sub_type" do
      c = Mail::ContentTypeField.new('text/plain')
      c.main_type.should == 'text'
    end

    it "should return a parameter as a hash" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII')
      c.parameters.should == {"charset" => 'US-ASCII'}
    end

    it "should return multiple parameters as a hash" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII; format=flowed')
      c.parameters.should == {"charset" => 'US-ASCII', "format" => 'flowed'}
    end

    it "should return boundry parameters" do
      c = Mail::ContentTypeField.new('multipart/mixed; boundary=Apple-Mail-13-196941151')
      c.parameters.should == {"boundary" => 'Apple-Mail-13-196941151'}
    end

    it "should be indifferent with the access" do
      c = Mail::ContentTypeField.new('multipart/mixed; boundary=Apple')
      c.parameters[:boundary].should == "Apple"
      c.parameters['boundary'].should == "Apple"
    end

  end

  describe "class methods" do
    it "should give back an initialized instance with a unique boundary" do
      boundary = Mail::ContentTypeField.with_boundary('multipart/mixed')
      boundary.encoded.should =~ %r{Content-Type: multipart/mixed;\r\n\sboundary="--==_mimepart_[\w]+_[\w]+"\r\n}
    end

    it "should give back an initialized instance with different type with a unique boundary" do
      boundary = Mail::ContentTypeField.with_boundary('multipart/alternative')
      boundary.encoded.should =~ %r{Content-Type: multipart/alternative;\r\n\sboundary="--==_mimepart_[\w]+_[\w]+"\r\n}
    end

    it "should give unique boundaries" do
      boundary1 = Mail::ContentTypeField.with_boundary('multipart/alternative').parameters['boundary']
      0.upto(250) do
        boundary2 = Mail::ContentTypeField.with_boundary('multipart/alternative').parameters['boundary']
        boundary1.should_not == boundary2
      end
    end

  end

  describe "Testing a bunch of email Content-Type fields" do

    it "should handle 'application/octet-stream; name*=iso-2022-jp'ja'01%20Quien%20Te%20Dij%8aat.%20Pitbull.mp3'" do
      string = %q{application/octet-stream; name*=iso-2022-jp'ja'01%20Quien%20Te%20Dij%8aat.%20Pitbull.mp3}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'application/octet-stream'
      c.main_type.should == 'application'
      c.sub_type.should == 'octet-stream'
      c.parameters.should == {'name*' => "iso-2022-jp'ja'01%20Quien%20Te%20Dij%8aat.%20Pitbull.mp3"}
    end

    it "should handle 'application/pdf;'" do
      string = %q{application/pdf;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'application/pdf'
      c.main_type.should == 'application'
      c.sub_type.should == 'pdf'
      c.parameters.should == {}
    end

    it "should handle 'application/pdf; name=\"broken.pdf\"'" do
      string = %q{application/pdf; name="broken.pdf"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'application/pdf'
      c.main_type.should == 'application'
      c.sub_type.should == 'pdf'
      c.parameters.should == {"name" => "broken.pdf"}
    end

    it "should handle 'application/pkcs7-signature;'" do
      string = %q{application/pkcs7-signature;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'application/pkcs7-signature'
      c.main_type.should == 'application'
      c.sub_type.should == 'pkcs7-signature'
      c.parameters.should == {}
    end

    it "should handle 'application/pkcs7-signature; name=smime.p7s'" do
      string = %q{application/pkcs7-signature; name=smime.p7s}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'application/pkcs7-signature'
      c.main_type.should == 'application'
      c.sub_type.should == 'pkcs7-signature'
      c.parameters.should == {"name" => "smime.p7s"}
    end

    it "should handle 'application/x-gzip; NAME=blah.gz'" do
      string = %q{application/x-gzip; NAME=blah.gz}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'application/x-gzip'
      c.main_type.should == 'application'
      c.sub_type.should == 'x-gzip'
      c.parameters.should == {"NAME" => "blah.gz"}
    end

    it "should handle 'image/jpeg'" do
      string = %q{image/jpeg}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'image/jpeg'
      c.main_type.should == 'image'
      c.sub_type.should == 'jpeg'
      c.parameters.should == {}
    end

    it "should handle 'image/jpeg'" do
      string = %q{image/jpeg}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'image/jpeg'
      c.main_type.should == 'image'
      c.sub_type.should == 'jpeg'
      c.parameters.should == {}
    end

    it "should handle 'image/jpeg;'" do
      string = %q{image/jpeg}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'image/jpeg'
      c.main_type.should == 'image'
      c.sub_type.should == 'jpeg'
      c.parameters.should == {}
    end

    it "should handle 'image/png;'" do
      string = %q{image/png}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'image/png'
      c.main_type.should == 'image'
      c.sub_type.should == 'png'
      c.parameters.should == {}
    end

    it "should handle 'message/delivery-status'" do
      string = %q{message/delivery-status}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'message/delivery-status'
      c.main_type.should == 'message'
      c.sub_type.should == 'delivery-status'
      c.parameters.should == {}
    end

    it "should handle 'message/rfc822'" do
      string = %q{message/rfc822}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'message/rfc822'
      c.main_type.should == 'message'
      c.sub_type.should == 'rfc822'
      c.parameters.should == {}
    end

    it "should handle 'multipart/alternative;'" do
      string = %q{multipart/alternative;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {}
    end

    it "should handle 'multipart/alternative; boundary=\"----=_NextPart_000_0093_01C81419.EB75E850\"'" do
      string = %q{multipart/alternative; boundary="----=_NextPart_000_0093_01C81419.EB75E850"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {"boundary" =>"----=_NextPart_000_0093_01C81419.EB75E850"}
    end

    it "should handle 'multipart/alternative; boundary=----=_NextPart_000_0093_01C81419.EB75E850'" do
      string = %q{multipart/alternative; boundary="----=_NextPart_000_0093_01C81419.EB75E850"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {"boundary" =>"----=_NextPart_000_0093_01C81419.EB75E850"}
    end

    it "should handle 'Multipart/Alternative;boundary=MuLtIpArT_BoUnDaRy'" do
      string = %q{Multipart/Alternative; boundary=MuLtIpArT_BoUnDaRy}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {"boundary" =>"MuLtIpArT_BoUnDaRy"}
    end

    it "should handle 'Multipart/Alternative;boundary=MuLtIpArT_BoUnDaRy'" do
      string = %q{Multipart/Alternative;boundary=MuLtIpArT_BoUnDaRy}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {"boundary" =>"MuLtIpArT_BoUnDaRy"}
    end

    it "should handle 'multipart/mixed'" do
      string = %q{multipart/mixed}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/mixed'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'mixed'
      c.parameters.should == {}
    end

    it "should handle 'multipart/mixed;'" do
      string = %q{multipart/mixed;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/mixed'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'mixed'
      c.parameters.should == {}
    end

    it "should handle 'multipart/mixed; boundary=Apple-Mail-13-196941151'" do
      string = %q{multipart/mixed; boundary=Apple-Mail-13-196941151}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/mixed'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'mixed'
      c.parameters.should == {"boundary" => "Apple-Mail-13-196941151"}
    end

    it "should handle 'multipart/mixed; boundary=mimepart_427e4cb4ca329_133ae40413c81ef'" do
      string = %q{multipart/mixed; boundary=mimepart_427e4cb4ca329_133ae40413c81ef}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/mixed'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'mixed'
      c.parameters.should == {"boundary" => "mimepart_427e4cb4ca329_133ae40413c81ef"}
    end

    it "should handle 'multipart/report; report-type=delivery-status;'" do
      string = %q{multipart/report; report-type=delivery-status;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/report'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'report'
      c.parameters.should == {"report-type" => "delivery-status"}
    end

    it "should handle 'multipart/signed;'" do
      string = %q{multipart/signed;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/signed'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'signed'
      c.parameters.should == {}
    end

    it "should handle 'text/enriched;'" do
      string = %q{text/enriched;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/enriched'
      c.main_type.should == 'text'
      c.sub_type.should == 'enriched'
      c.parameters.should == {}
    end

    it "should handle 'text/html;'" do
      string = %q{text/html;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/html'
      c.main_type.should == 'text'
      c.sub_type.should == 'html'
      c.parameters.should == {}
    end

    it "should handle 'text/html; charset=iso-8859-1;'" do
      string = %q{text/html; charset=iso-8859-1;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/html'
      c.main_type.should == 'text'
      c.sub_type.should == 'html'
      c.parameters.should == {"charset" => 'iso-8859-1'}
    end

    it "should handle 'TEXT/PLAIN; charset=ISO-8859-1;'" do
      string = %q{TEXT/PLAIN; charset=ISO-8859-1;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'ISO-8859-1'}
    end

    it "should handle 'text/plain'" do
      string = %q{text/plain}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {}
    end

    it "should handle 'text/plain;'" do
      string = %q{text/plain;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {}
    end

    it "should handle 'text/plain; charset=ISO-8859-1'" do
      string = %q{text/plain; charset=ISO-8859-1}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'ISO-8859-1'}
    end

    it "should handle 'text/plain; charset=ISO-8859-1;'" do
      string = %q{text/plain; charset=ISO-8859-1; format=flowed}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'ISO-8859-1', "format" => 'flowed'}
    end

    it "should handle 'text/plain; charset=us-ascii;'" do
      string = %q{text/plain; charset=us-ascii}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'us-ascii'}
    end

    it "should handle 'text/plain; charset=US-ASCII; format=flowed'" do
      string = %q{text/plain; charset=US-ASCII; format=flowed}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'US-ASCII', "format" => 'flowed'}
    end

    it "should handle 'text/plain; charset=US-ASCII; format=flowed'" do
      string = %q{text/plain; charset=US-ASCII; format=flowed}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'US-ASCII', "format" => 'flowed'}
    end

    it "should handle 'text/plain; charset=utf-8'" do
      string = %q{text/plain; charset=utf-8}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'utf-8'}
    end

    it "should handle 'text/plain; charset=utf-8'" do
      string = %q{text/plain; charset=X-UNKNOWN}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/plain'
      c.main_type.should == 'text'
      c.sub_type.should == 'plain'
      c.parameters.should == {"charset" => 'X-UNKNOWN'}
    end

    it "should handle 'text/x-ruby-script;'" do
      string = %q{text/x-ruby-script;}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/x-ruby-script'
      c.main_type.should == 'text'
      c.sub_type.should == 'x-ruby-script'
      c.parameters.should == {}
    end

    it "should handle 'text/x-ruby-script; name=\"hello.rb\"'" do
      string = %q{text/x-ruby-script; name="hello.rb"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'text/x-ruby-script'
      c.main_type.should == 'text'
      c.sub_type.should == 'x-ruby-script'
      c.parameters.should == {"name" => 'hello.rb'}
    end

    it "should handle 'multipart/mixed; boundary=\"=_NextPart_Lycos_15031600484464_ID\"" do
      string = %q{multipart/mixed; boundary="=_NextPart_Lycos_15031600484464_ID"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/mixed'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'mixed'
      c.parameters.should == {"boundary" => '=_NextPart_Lycos_15031600484464_ID'}
    end

    it "should handle 'multipart/alternative; boundary=----=_=NextPart_000_0093_01C81419.EB75E850" do
      string = %q{multipart/alternative; boundary=----=_=NextPart_000_0093_01C81419.EB75E850}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {"boundary" => '----=_=NextPart_000_0093_01C81419.EB75E850'}
    end

    it "should handle 'multipart/alternative; boundary=\"----=_=NextPart_000_0093_01C81419.EB75E850\"" do
      string = %q{multipart/alternative; boundary="----=_=NextPart_000_0093_01C81419.EB75E850"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/alternative'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'alternative'
      c.parameters.should == {"boundary" => '----=_=NextPart_000_0093_01C81419.EB75E850'}
    end

    it "should handle 'multipart/related;boundary=1_4626B816_9F1690;Type=\"application/smil\";Start=\"<mms.smil.txt>\"'" do
      string = %q{multipart/related;boundary=1_4626B816_9F1690;Type="application/smil";Start="<mms.smil.txt>"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'multipart/related'
      c.main_type.should == 'multipart'
      c.sub_type.should == 'related'
      c.parameters.should == {"boundary" => '1_4626B816_9F1690', "Type" => 'application/smil', "Start" => '<mms.smil.txt>'}
    end

    it "should handle 'IMAGE/JPEG; name=\"IM 006.jpg\"'" do
      string = %q{IMAGE/JPEG; name="IM 006.jpg"}
      c = Mail::ContentTypeField.new(string)
      c.content_type.should == 'image/jpeg'
      c.main_type.should == 'image'
      c.sub_type.should == 'jpeg'
      c.parameters.should == {"name" => "IM 006.jpg"}
    end

  end

  describe "finding a filename" do

    it "should locate a filename if there is a filename" do
      string = %q{application/octet-stream; filename=mikel.jpg}
      c = Mail::ContentTypeField.new(string)
      c.filename.should == 'mikel.jpg'
    end

    it "should locate a name if there is no filename" do
      string = %q{application/octet-stream; name=mikel.jpg}
      c = Mail::ContentTypeField.new(string)
      c.filename.should == 'mikel.jpg'
    end

    it "should locate an encoded name as a filename" do
      string = %q{application/octet-stream; name*=iso-2022-jp'ja'01%20Quien%20Te%20Dij%91at.%20Pitbull.mp3}
      c = Mail::ContentTypeField.new(string)
      if RUBY_VERSION >= '1.9'
        expected = "01 Quien Te Dij\221at. Pitbull.mp3".force_encoding(Encoding::BINARY)
        result = c.filename.force_encoding(Encoding::BINARY)
      else
        expected = "01 Quien Te Dij\221at. Pitbull.mp3"
        result = c.filename
      end
      expected.should == result
    end

    it "should encode a non us-ascii filename" do
      @original = $KCODE if RUBY_VERSION < '1.9'
      Mail.defaults do
        param_encode_language('jp')
      end
      c = Mail::ContentTypeField.new('application/octet-stream')
      string = "01 Quien Te Dij\221at. Pitbull.mp3"
      if RUBY_VERSION >= '1.9'
        string.force_encoding('SJIS')
        result = %Q{Content-Type: application/octet-stream;\r\n\sfilename*=shift_jis'jp'01%20Quien%20Te%20Dij%91%61t.%20Pitbull.mp3\r\n}
      else
        storedkcode = $KCODE
        $KCODE = 'SJIS'
        result = %Q{Content-Type: application/octet-stream;\r\n\sfilename*=sjis'jp'01%20Quien%20Te%20Dij%91at.%20Pitbull.mp3\r\n}
      end
      c.filename = string
      c.parameters.should == {"filename" => string}
      c.encoded.should == result
      $KCODE = @original if RUBY_VERSION < '1.9'
    end

  end

  describe "handling badly formated content-type fields" do

    it "should handle missing sub-type on a text content type" do
      c = Mail::ContentTypeField.new('Content-Type: text')
      c.content_type.should == 'text/plain'
    end

    it "should handle missing ; after content-type" do
      c = Mail::ContentTypeField.new('Content-Type: multipart/mixed boundary="----=_NextPart_000_000F_01C17754.8C3CAF30"')
      c.content_type.should == 'multipart/mixed'
      c.parameters['boundary'].should == '----=_NextPart_000_000F_01C17754.8C3CAF30'
    end

  end

  describe "initializing with an array" do
    it "should initialize with an array" do
      c = Mail::ContentTypeField.new(['text', 'html', {'charset' => 'UTF-8'}])
      c.content_type.should == 'text/html'
      c.parameters['charset'].should == 'UTF-8'
    end

    it "should allow many parameters to be passed in" do
      c = Mail::ContentTypeField.new(['text', 'html', {"format"=>"flowed", "charset"=>"utf-8"}])
      c.content_type.should == 'text/html'
      c.parameters['charset'].should == 'utf-8'
      c.parameters['format'].should == 'flowed'
    end
  end

  describe "special case values needing sanity" do
    it "should handle 'text/plain;ISO-8559-1'" do
      c = Mail::ContentTypeField.new('text/plain;ISO-8559-1')
      c.string.should == 'text/plain'
      c.parameters['charset'].should == 'iso-8559-1'
    end

    it "should handle text; params" do
      c = Mail::ContentTypeField.new('text; charset=utf-8')
      c.string.should == 'text/plain'
      c.parameters['charset'].should == 'utf-8'
    end

    it 'should handle text/html; charset="charset="GB2312""' do
      c = Mail::ContentTypeField.new('text/html; charset="charset="GB2312""')
      c.string.should == 'text/html'
      c.parameters['charset'].should == 'gb2312'
    end

    it "should handle application/octet-stream; name=archiveshelp1[1].htm" do
      c = Mail::ContentTypeField.new('application/octet-stream; name=archiveshelp1[1].htm')
      c.string.should == 'application/octet-stream'
      c.parameters['name'].should == 'archiveshelp1[1].htm'
    end

    it 'should handle text/plain;; format="flowed"' do
      c = Mail::ContentTypeField.new('text/plain;; format="flowed"')
      c.string.should == 'text/plain'
      c.parameters['format'].should == 'flowed'
    end

    it 'set an empty content type to text/plain' do
      c = Mail::ContentTypeField.new('')
      c.string.should == 'text/plain'
    end

    it "should just ignore illegal params like audio/x-midi;\r\n\sname=Part .exe" do
      c = Mail::ContentTypeField.new("audio/x-midi;\r\n\sname=Part .exe")
      c.string.should == 'audio/x-midi'
      c.parameters['name'].should == nil
    end

    it "should handle: rfc822; format=flowed; charset=iso-8859-15" do
      c = Mail::ContentTypeField.new("rfc822; format=flowed; charset=iso-8859-15")
      c.string.should == 'text/plain'
      c.parameters['format'].should == 'flowed'
      c.parameters['charset'].should == 'iso-8859-15'
    end

    it "should just get the mime type if all else fails with some real garbage" do
      c = Mail::ContentTypeField.new("text/html; format=flowed; charset=iso-8859-15  Mime-Version: 1.0")
      c.string.should == 'text/html'
    end

  end

end
