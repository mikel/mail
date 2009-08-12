require File.dirname(__FILE__) + '/../../spec_helper'

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
    it "should description" do
      
    end
  end

end
