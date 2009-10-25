# encoding: utf-8
#:nodoc:

# OK... serious code smell in here... I just took the whole multibyte_chars code out of 
# ActiveSupport.... hacked it to fit... like a mallet bashing a square peg... the thing
# fits in the hole... really!
#
# Bah... I'll get the first gem out and we'll fix this up.

require File.join(File.dirname(__FILE__), 'multibyte/chars')
require File.join(File.dirname(__FILE__), 'multibyte/exceptions')
require File.join(File.dirname(__FILE__), 'multibyte/unicode_database')

module Mail #:nodoc:
  module Multibyte
    # A list of all available normalization forms. See http://www.unicode.org/reports/tr15/tr15-29.html for more
    # information about normalization.
    NORMALIZATION_FORMS = [:c, :kc, :d, :kd]

    # The Unicode version that is supported by the implementation
    UNICODE_VERSION = '5.1.0'

    # The default normalization used for operations that require normalization. It can be set to any of the
    # normalizations in NORMALIZATION_FORMS.
    #
    # Example:
    #   Mail::Multibyte.default_normalization_form = :c
    def self.default_normalization_form=(val)
      @default_normalization_form = val
    end

    def self.default_normalization_form
      @default_normalization_form ||= :kc
    end

    # The proxy class returned when calling mb_chars. You can use this accessor to configure your own proxy
    # class so you can support other encodings. See the Mail::Multibyte::Chars implementation for
    # an example how to do this.
    #
    # Example:
    #   Mail::Multibyte.proxy_class = CharsForUTF32
    def self.proxy_class=(val)
      @proxy_class = val
    end

    def self.proxy_class
      @proxy_class ||= Mail::Multibyte::Chars
    end
    
    def length
      self.mb_chars.length
    end
    
    def slice!(*args)
      self.mb_chars.slice!(*args)
    end
    
    def slice(*args)
      self.mb_chars.slice(*args)
    end
  end
end
