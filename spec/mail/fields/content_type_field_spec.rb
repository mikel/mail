# frozen_string_literal: true
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
      expect { Mail::ContentTypeField.new("<1234@test.lindsaar.net>") }.not_to raise_error
    end

    it "should accept a string without the field name" do
      c = Mail::ContentTypeField.new('text/plain')
      expect(c.name).to eq 'Content-Type'
      expect(c.value).to eq 'text/plain'
    end

    it "should accept a nil value and generate a content_type" do
      c = Mail::ContentTypeField.new('Content-Type', nil)
      expect(c.name).to eq 'Content-Type'
      expect(c.value).not_to be_nil
    end

    it "should render encoded" do
      c = Mail::ContentTypeField.new('text/plain')
      expect(c.encoded).to eq "Content-Type: text/plain\r\n"
    end

    it "should render encoded with parameters" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII; format=flowed')
      expect(c.encoded).to eq %Q{Content-Type: text/plain;\r\n\scharset=US-ASCII;\r\n\sformat=flowed\r\n}
    end

    it "should render quoted values encoded" do
      c = Mail::ContentTypeField.new('text/plain; example="foo bar"')
      expect(c.encoded).to eq %Q{Content-Type: text/plain;\r\n\sexample="foo bar"\r\n}
    end

    it "should render decoded" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII; format=flowed')
      expect(c.decoded).to eq 'text/plain; charset=US-ASCII; format=flowed'
    end

    it "should render quoted values decoded" do
      c = Mail::ContentTypeField.new('text/plain; example="foo bar"')
      expect(c.decoded).to eq 'text/plain; example="foo bar"'
    end

    it "should render " do
      c = Mail::ContentTypeField.new('message/delivery-status')
      expect(c.main_type).to eq 'message'
      expect(c.sub_type).to eq 'delivery-status'
    end

    it "should wrap a filename in double quotation marks only if the filename contains spaces and does not already have double quotation marks" do
      c = Mail::ContentTypeField.new('text/plain; name=This is a bad filename.txt')
      expect(c.value).to eq 'text/plain; name="This is a bad filename.txt"'

      c = Mail::ContentTypeField.new('image/jpg; name=some.jpg; size=100')
      expect(c.value).to eq 'image/jpg; name=some.jpg; size=100'

      c = Mail::ContentTypeField.new('text/plain; name="Bad filename but at least it is wrapped in quotes.txt"')
      expect(c.value).to eq 'text/plain; name="Bad filename but at least it is wrapped in quotes.txt"'
    end

    it "should only wrap filenames in double quotation marks" do
      c = Mail::ContentTypeField.new("image/jpg;\r\n\sname=some .jpg\r\n\ssize=100")
      expect(c.value).to eq %Q{image/jpg;\r\n\sname="some .jpg"\r\n\ssize=100}
    end
  end

  describe "instance methods" do
    it "should return a content_type" do
      c = Mail::ContentTypeField.new('text/plain')
      expect(c.content_type).to eq 'text/plain'
    end

    it "should return a content_type for the :string method" do
      c = Mail::ContentTypeField.new('text/plain')
      expect(c.string).to eq 'text/plain'
    end

    it "should return a main_type" do
      c = Mail::ContentTypeField.new('text/plain')
      expect(c.main_type).to eq 'text'
    end

    it "should return a sub_type" do
      c = Mail::ContentTypeField.new('text/plain')
      expect(c.main_type).to eq 'text'
    end

    it "should return a parameter as a hash" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII')
      expect(c.parameters).to eql({"charset" => 'US-ASCII'})
    end

    it "should return multiple parameters as a hash" do
      c = Mail::ContentTypeField.new('text/plain; charset=US-ASCII; format=flowed')
      expect(c.parameters).to eql({"charset" => 'US-ASCII', "format" => 'flowed'})
    end

    it "should return boundry parameters" do
      c = Mail::ContentTypeField.new('multipart/mixed; boundary=Apple-Mail-13-196941151')
      expect(c.parameters).to eql({"boundary" => 'Apple-Mail-13-196941151'})
    end

    it "should be indifferent with the access" do
      c = Mail::ContentTypeField.new('multipart/mixed; boundary=Apple')
      expect(c.parameters[:boundary]).to eq "Apple"
      expect(c.parameters['boundary']).to eq "Apple"
    end

  end

  describe "class methods" do
    it "should give back an initialized instance with a unique boundary" do
      boundary = Mail::ContentTypeField.with_boundary('multipart/mixed')
      expect(boundary.encoded).to match(%r{Content-Type: multipart/mixed;\r\n\sboundary="--==_mimepart_[\w]+_[\w]+"\r\n})
    end

    it "should give back an initialized instance with different type with a unique boundary" do
      boundary = Mail::ContentTypeField.with_boundary('multipart/alternative')
      expect(boundary.encoded).to match(%r{Content-Type: multipart/alternative;\r\n\sboundary="--==_mimepart_[\w]+_[\w]+"\r\n})
    end

    it "should give unique boundaries" do
      boundary1 = Mail::ContentTypeField.with_boundary('multipart/alternative').parameters['boundary']
      0.upto(250) do
        boundary2 = Mail::ContentTypeField.with_boundary('multipart/alternative').parameters['boundary']
        expect(boundary1).not_to eq(boundary2)
      end
    end

  end

  describe "Testing a bunch of email Content-Type fields" do

    it "should handle 'application/octet-stream; name*=iso-2022-jp'ja'01%20Quien%20Te%20Dij%8aat.%20Pitbull.mp3'" do
      string = %q{application/octet-stream; name*=iso-2022-jp'ja'01%20Quien%20Te%20Dij%8aat.%20Pitbull.mp3}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'application/octet-stream'
      expect(c.main_type).to eq 'application'
      expect(c.sub_type).to eq 'octet-stream'
      expect(c.parameters).to eql({'name*' => "iso-2022-jp'ja'01%20Quien%20Te%20Dij%8aat.%20Pitbull.mp3"})
    end

    it "should handle 'application/pdf;'" do
      string = %q{application/pdf;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'application/pdf'
      expect(c.main_type).to eq 'application'
      expect(c.sub_type).to eq 'pdf'
      expect(c.parameters).to eql({})
    end

    it "should handle 'application/pdf; name=\"broken.pdf\"'" do
      string = %q{application/pdf; name="broken.pdf"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'application/pdf'
      expect(c.main_type).to eq 'application'
      expect(c.sub_type).to eq 'pdf'
      expect(c.parameters).to eql({"name" => "broken.pdf"})
    end

    it "should handle 'application/pkcs7-signature;'" do
      string = %q{application/pkcs7-signature;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'application/pkcs7-signature'
      expect(c.main_type).to eq 'application'
      expect(c.sub_type).to eq 'pkcs7-signature'
      expect(c.parameters).to eql({})
    end

    it "should handle 'application/pkcs7-signature; name=smime.p7s'" do
      string = %q{application/pkcs7-signature; name=smime.p7s}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'application/pkcs7-signature'
      expect(c.main_type).to eq 'application'
      expect(c.sub_type).to eq 'pkcs7-signature'
      expect(c.parameters).to eql({"name" => "smime.p7s"})
    end

    it "should handle 'application/x-gzip; NAME=blah.gz'" do
      string = %q{application/x-gzip; NAME=blah.gz}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'application/x-gzip'
      expect(c.main_type).to eq 'application'
      expect(c.sub_type).to eq 'x-gzip'
      expect(c.parameters).to eql({"NAME" => "blah.gz"})
    end

    it "should handle 'image/jpeg'" do
      string = %q{image/jpeg}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'image/jpeg'
      expect(c.main_type).to eq 'image'
      expect(c.sub_type).to eq 'jpeg'
      expect(c.parameters).to eql({})
    end

    it "should handle 'image/jpeg'" do
      string = %q{image/jpeg}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'image/jpeg'
      expect(c.main_type).to eq 'image'
      expect(c.sub_type).to eq 'jpeg'
      expect(c.parameters).to eql({})
    end

    it "should handle 'image/jpeg;'" do
      string = %q{image/jpeg}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'image/jpeg'
      expect(c.main_type).to eq 'image'
      expect(c.sub_type).to eq 'jpeg'
      expect(c.parameters).to eql({})
    end

    it "should handle 'image/png;'" do
      string = %q{image/png}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'image/png'
      expect(c.main_type).to eq 'image'
      expect(c.sub_type).to eq 'png'
      expect(c.parameters).to eql({})
    end

    it "should handle 'message/delivery-status'" do
      string = %q{message/delivery-status}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'message/delivery-status'
      expect(c.main_type).to eq 'message'
      expect(c.sub_type).to eq 'delivery-status'
      expect(c.parameters).to eql({})
    end

    it "should handle 'message/rfc822'" do
      string = %q{message/rfc822}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'message/rfc822'
      expect(c.main_type).to eq 'message'
      expect(c.sub_type).to eq 'rfc822'
      expect(c.parameters).to eql({})
    end

    it "should handle 'multipart/alternative;'" do
      string = %q{multipart/alternative;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({})
    end

    it "should handle 'multipart/alternative; boundary=\"----=_NextPart_000_0093_01C81419.EB75E850\"'" do
      string = %q{multipart/alternative; boundary="----=_NextPart_000_0093_01C81419.EB75E850"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({"boundary" =>"----=_NextPart_000_0093_01C81419.EB75E850"})
    end

    it "should handle 'multipart/alternative; boundary=----=_NextPart_000_0093_01C81419.EB75E850'" do
      string = %q{multipart/alternative; boundary="----=_NextPart_000_0093_01C81419.EB75E850"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({"boundary" =>"----=_NextPart_000_0093_01C81419.EB75E850"})
    end

    it "should handle 'Multipart/Alternative;boundary=MuLtIpArT_BoUnDaRy'" do
      string = %q{Multipart/Alternative; boundary=MuLtIpArT_BoUnDaRy}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({"boundary" =>"MuLtIpArT_BoUnDaRy"})
    end

    it "should handle 'Multipart/Alternative;boundary=MuLtIpArT_BoUnDaRy'" do
      string = %q{Multipart/Alternative;boundary=MuLtIpArT_BoUnDaRy}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({"boundary" =>"MuLtIpArT_BoUnDaRy"})
    end

    it %(should handle 'multipart/alternative; boundary="----jkhkjgyurlkmn789809";; charset="us-ascii"') do
      string = %(multipart/alternative; boundary="----jkhkjgyurlkmn789809";; charset="us-ascii")
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.parameters['boundary']).to eq('----jkhkjgyurlkmn789809')
    end

    it "should handle 'multipart/mixed'" do
      string = %q{multipart/mixed}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'mixed'
      expect(c.parameters).to eql({})
    end

    it "should handle 'multipart/mixed;'" do
      string = %q{multipart/mixed;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'mixed'
      expect(c.parameters).to eql({})
    end

    it "should handle 'multipart/mixed; boundary=Apple-Mail-13-196941151'" do
      string = %q{multipart/mixed; boundary=Apple-Mail-13-196941151}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'mixed'
      expect(c.parameters).to eql({"boundary" => "Apple-Mail-13-196941151"})
    end

    it "should handle 'multipart/mixed; boundary=mimepart_427e4cb4ca329_133ae40413c81ef'" do
      string = %q{multipart/mixed; boundary=mimepart_427e4cb4ca329_133ae40413c81ef}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'mixed'
      expect(c.parameters).to eql({"boundary" => "mimepart_427e4cb4ca329_133ae40413c81ef"})
    end

    it "should handle 'multipart/report; report-type=delivery-status;'" do
      string = %q{multipart/report; report-type=delivery-status;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/report'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'report'
      expect(c.parameters).to eql({"report-type" => "delivery-status"})
    end

    it "should handle 'multipart/signed;'" do
      string = %q{multipart/signed;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/signed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'signed'
      expect(c.parameters).to eql({})
    end

    it "should handle 'text/enriched;'" do
      string = %q{text/enriched;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/enriched'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'enriched'
      expect(c.parameters).to eql({})
    end

    it "should handle 'text/html;'" do
      string = %q{text/html;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/html'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'html'
      expect(c.parameters).to eql({})
    end

    it "should handle 'text/html; charset=iso-8859-1;'" do
      string = %q{text/html; charset=iso-8859-1;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/html'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'html'
      expect(c.parameters).to eql({"charset" => 'iso-8859-1'})
    end

    it "should handle 'TEXT/PLAIN; charset=ISO-8859-1;'" do
      string = %q{TEXT/PLAIN; charset=ISO-8859-1;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'ISO-8859-1'})
    end

    it "should handle 'text/plain'" do
      string = %q{text/plain}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({})
    end

    it "should handle 'text/plain;'" do
      string = %q{text/plain;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({})
    end

    it "should handle 'text/plain; charset=ISO-8859-1'" do
      string = %q{text/plain; charset=ISO-8859-1}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'ISO-8859-1'})
    end

    it "should handle 'text/plain; charset=ISO-8859-1;'" do
      string = %q{text/plain; charset=ISO-8859-1; format=flowed}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'ISO-8859-1', "format" => 'flowed'})
    end

    it "should handle 'text/plain; charset=us-ascii;'" do
      string = %q{text/plain; charset=us-ascii}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'us-ascii'})
    end

    it "should handle 'text/plain; charset=US-ASCII; format=flowed'" do
      string = %q{text/plain; charset=US-ASCII; format=flowed}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'US-ASCII', "format" => 'flowed'})
    end

    it "should handle 'text/plain; charset=US-ASCII; format=flowed'" do
      string = %q{text/plain; charset=US-ASCII; format=flowed}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'US-ASCII', "format" => 'flowed'})
    end

    it "should handle 'text/plain; charset=utf-8'" do
      string = %q{text/plain; charset=utf-8}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'utf-8'})
    end

    it "should handle 'text/plain; charset=utf-8'" do
      string = %q{text/plain; charset=X-UNKNOWN}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/plain'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'plain'
      expect(c.parameters).to eql({"charset" => 'X-UNKNOWN'})
    end

    it "should handle 'text/x-ruby-script;'" do
      string = %q{text/x-ruby-script;}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/x-ruby-script'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'x-ruby-script'
      expect(c.parameters).to eql({})
    end

    it "should handle 'text/x-ruby-script; name=\"hello.rb\"'" do
      string = %q{text/x-ruby-script; name="hello.rb"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'text/x-ruby-script'
      expect(c.main_type).to eq 'text'
      expect(c.sub_type).to eq 'x-ruby-script'
      expect(c.parameters).to eql({"name" => 'hello.rb'})
    end

    it "should handle 'multipart/mixed; boundary=\"=_NextPart_Lycos_15031600484464_ID\"" do
      string = %q{multipart/mixed; boundary="=_NextPart_Lycos_15031600484464_ID"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'mixed'
      expect(c.parameters).to eql({"boundary" => '=_NextPart_Lycos_15031600484464_ID'})
    end

    it "should handle 'multipart/mixed; boundary=\"=_NextPart_2rfkindysadvnqw3nerasdf\";windows-852" do
      string = %q{multipart/mixed; boundary="=_NextPart_2rfkindysadvnqw3nerasdf";windows-852}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'mixed'
      expect(c.parameters).to eql({"boundary" => '=_NextPart_2rfkindysadvnqw3nerasdf', "windows-852" => ''})
    end

    it "should handle 'multipart/alternative; boundary=----=_=NextPart_000_0093_01C81419.EB75E850" do
      string = %q{multipart/alternative; boundary=----=_=NextPart_000_0093_01C81419.EB75E850}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({"boundary" => '----=_=NextPart_000_0093_01C81419.EB75E850'})
    end

    it "should handle 'multipart/alternative; boundary=\"----=_=NextPart_000_0093_01C81419.EB75E850\"" do
      string = %q{multipart/alternative; boundary="----=_=NextPart_000_0093_01C81419.EB75E850"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/alternative'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'alternative'
      expect(c.parameters).to eql({"boundary" => '----=_=NextPart_000_0093_01C81419.EB75E850'})
    end

    it "should handle 'multipart/related;boundary=1_4626B816_9F1690;Type=\"application/smil\";Start=\"<mms.smil.txt>\"'" do
      string = %q{multipart/related;boundary=1_4626B816_9F1690;Type="application/smil";Start="<mms.smil.txt>"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'multipart/related'
      expect(c.main_type).to eq 'multipart'
      expect(c.sub_type).to eq 'related'
      expect(c.parameters).to eql({"boundary" => '1_4626B816_9F1690', "Type" => 'application/smil', "Start" => '<mms.smil.txt>'})
    end

    it "should handle 'IMAGE/JPEG; name=\"IM 006.jpg\"'" do
      string = %q{IMAGE/JPEG; name="IM 006.jpg"}
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'image/jpeg'
      expect(c.main_type).to eq 'image'
      expect(c.sub_type).to eq 'jpeg'
      expect(c.parameters).to eql({"name" => "IM 006.jpg"})
    end

    it "should handle 'unknown/unknown'" do
      string = %(unknown/unknown; charset=iso-8859-1; name=IMSTP19.gif)
      c = Mail::ContentTypeField.new(string)
      expect(c.content_type).to eq 'unknown/unknown'
      expect(c.main_type).to eq 'unknown'
      expect(c.sub_type).to eq 'unknown'
      expect(c.parameters).to eql('charset' => 'iso-8859-1', 'name' => 'IMSTP19.gif')
    end

  end

  describe "finding a filename" do

    it "should locate a filename if there is a filename" do
      string = %q{application/octet-stream; filename=mikel.jpg}
      c = Mail::ContentTypeField.new(string)
      expect(c.filename).to eq 'mikel.jpg'
    end

    it "should locate a name if there is no filename" do
      string = %q{application/octet-stream; name=mikel.jpg}
      c = Mail::ContentTypeField.new(string)
      expect(c.filename).to eq 'mikel.jpg'
    end

    it "should return an empty string when filename or name is empty" do
      string = %q{application/octet-stream; filename=""}
      c = Mail::ContentTypeField.new(string)
      expect(c.filename).to eq ''

      string = %q{application/octet-stream; name=""}
      c = Mail::ContentTypeField.new(string)
      expect(c.filename).to eq ''
    end

    it "should locate an encoded name as a filename" do
      string = %q{application/octet-stream; name*=iso-2022-jp'ja'01%20Quien%20Te%20Dijo%20feat.%20Pitbull.mp3}
      c = Mail::ContentTypeField.new(string)
      expected = "01 Quien Te Dijo feat. Pitbull.mp3"
      result = c.filename
      expect(expected).to eq result
    end

    it "should encode a non us-ascii filename" do
      Mail.defaults do
        param_encode_language('jp')
      end
      c = Mail::ContentTypeField.new('application/octet-stream')
      string = "01 Quien Te Dij\221at. Pitbull.mp3"
      string = string.dup.force_encoding('SJIS')
      result = %Q{Content-Type: application/octet-stream;\r\n\sfilename*=windows-31j'jp'01%20Quien%20Te%20Dij%91%61t.%20Pitbull.mp3\r\n}
      c.filename = string
      expect(c.parameters).to eql({"filename" => string})
      expect(c.encoded).to eq result
    end

  end

  describe "handling badly formated content-type fields" do

    it "should handle missing sub-type on a text content type" do
      c = Mail::ContentTypeField.new('text')
      expect(c.content_type).to eq 'text/plain'
    end

    it "should handle missing ; after content-type" do
      c = Mail::ContentTypeField.new('multipart/mixed boundary="----=_NextPart_000_000F_01C17754.8C3CAF30"')
      expect(c.content_type).to eq 'multipart/mixed'
      expect(c.parameters['boundary']).to eq '----=_NextPart_000_000F_01C17754.8C3CAF30'
    end

  end

  describe "initializing with an array" do
    it "should initialize with an array" do
      c = Mail::ContentTypeField.new(['text', 'html', {'charset' => 'UTF-8'}])
      expect(c.content_type).to eq 'text/html'
      expect(c.parameters['charset']).to eq 'UTF-8'
    end

    it "should allow many parameters to be passed in" do
      c = Mail::ContentTypeField.new(['text', 'html', {"format"=>"flowed", "charset"=>"utf-8"}])
      expect(c.content_type).to eq 'text/html'
      expect(c.parameters['charset']).to eq 'utf-8'
      expect(c.parameters['format']).to eq 'flowed'
    end
  end

  describe "special case values needing sanity" do
    it "should handle 'text/plain;ISO-8559-1'" do
      c = Mail::ContentTypeField.new('text/plain;ISO-8559-1')
      expect(c.string).to eq 'text/plain'
      expect(c.parameters['charset']).to eq 'iso-8559-1'
    end

    it "should handle 'text/plain; charset = \"iso-8859-1\"'" do
      c = Mail::ContentTypeField.new('text/plain; charset = "iso-8859-1"')
      expect(c.string).to eq 'text/plain'
      expect(c.parameters['charset']).to eq 'iso-8859-1'
    end

    it "should handle text; params" do
      c = Mail::ContentTypeField.new('text; charset=utf-8')
      expect(c.string).to eq 'text/plain'
      expect(c.parameters['charset']).to eq 'utf-8'
    end

    it 'should handle text/html; charset="charset="GB2312""' do
      c = Mail::ContentTypeField.new('text/html; charset="charset="GB2312""')
      expect(c.string).to eq 'text/html'
      expect(c.parameters['charset']).to eq 'gb2312'
    end

    it "should handle application/octet-stream; name=archiveshelp1[1].htm" do
      c = Mail::ContentTypeField.new('application/octet-stream; name=archiveshelp1[1].htm')
      expect(c.string).to eq 'application/octet-stream'
      expect(c.parameters['name']).to eq 'archiveshelp1[1].htm'
    end

    it 'should handle text/plain;; format="flowed"' do
      c = Mail::ContentTypeField.new('text/plain;; format="flowed"')
      expect(c.string).to eq 'text/plain'
      expect(c.parameters['format']).to eq 'flowed'
    end

    it 'set an empty content type to text/plain' do
      c = Mail::ContentTypeField.new('')
      expect(c.string).to eq 'text/plain'
    end

    it "should just ignore illegal params like audio/x-midi;\r\n\sname=Part .exe" do
      c = Mail::ContentTypeField.new("audio/x-midi;\r\n\sname=Part .exe")
      expect(c.string).to eq 'audio/x-midi'
      expect(c.parameters['name']).to be_nil
    end

    it "should handle: rfc822; format=flowed; charset=iso-8859-15" do
      c = Mail::ContentTypeField.new("rfc822; format=flowed; charset=iso-8859-15")
      expect(c.string).to eq 'text/plain'
      expect(c.parameters['format']).to eq 'flowed'
      expect(c.parameters['charset']).to eq 'iso-8859-15'
    end

    it "should just get the mime type if all else fails with some real garbage" do
      c = Mail::ContentTypeField.new("text/html; format=flowed; charset=iso-8859-15  Mime-Version: 1.0")
      expect(c.string).to eq 'text/html'
    end

    it "shouldn't include separating semicolon in parameter value when sanitizing" do
      c = Mail::ContentTypeField.new(%Q{Multipart/Related;boundary=boundary123?WUT; type="application/xml";})
      expect(c.parameters['boundary']).to eq 'boundary123?WUT'
    end

  end

end
