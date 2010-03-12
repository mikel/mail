# encoding: utf-8
class String #:nodoc:
  def to_crlf
    gsub(/\n|\r\n|\r/) { "\r\n" }
  end

  def to_lf
    gsub(/\n|\r\n|\r/) { "\n" }
  end

  unless method_defined?(:ascii_only?)
    # Provides all strings with the Ruby 1.9 method of .ascii_only? and
    # returns true or false
    US_ASCII_REGEXP = %Q{\x00-\x7f}
    def ascii_only?
      !(self =~ /[^#{US_ASCII_REGEXP}]/)
    end
  end

  unless method_defined?(:bytesize)
    alias :bytesize :length
  end

  unless method_defined?(:bytes)
    def bytes
      if block_given?
        scan(/./n) {|b| yield b[0]}
      else
        scan(/./n)
      end
    end
  end

  unless method_defined?(:lines)
    def lines
      if block_given?
        scan(/^.*$/) {|l| yield l}
      else
        scan(/^.*$/)
      end
    end
  end
end
