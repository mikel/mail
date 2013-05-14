module Mail
  class Preprocessor
    WAVE_DASH = [0x301c].pack("U")
    FULLWIDTH_TILDE = [0xff5e].pack("U")
    MINUS_SIGN = [0x2212].pack("U")
    FULLWIDTH_HYPHEN_MINUS = [0xff0d].pack("U")
    EM_DASH = [0x2014].pack("U")
    HORIZONTAL_BAR = [0x2015].pack("U")
    DOUBLE_VERTICAL_LINE = [0x2016].pack("U")
    PARALLEL_TO = [0x2225].pack("U")

    def self.process(value)
      value.to_s.
        gsub(/#{WAVE_DASH}/, FULLWIDTH_TILDE).
        gsub(/#{MINUS_SIGN}/, FULLWIDTH_HYPHEN_MINUS).
        gsub(/#{EM_DASH}/, HORIZONTAL_BAR).
        gsub(/#{DOUBLE_VERTICAL_LINE}/, PARALLEL_TO)
    end
  end
end
