# encoding: utf-8
class String #:nodoc:
  
  if defined?(Mail::Multibyte)
    include Mail::Multibyte
  end
  
  def blank?
    self !~ /\S/
  end
  
  def to_crlf
    self.gsub(/\n|\r\n|\r/) { "\r\n" }
  end

  def to_lf
    self.gsub(/\n|\r\n|\r/) { "\n" }
  end

  if RUBY_VERSION <= "1.9"

    # Provides all strings with the Ruby 1.9 method of .ascii_only? and
    # returns true or false
    US_ASCII_REGEXP = %Q{\x00-\x7f}
    def ascii_only?
      !(self =~ /[^#{US_ASCII_REGEXP}]/)
    end
    
  end
  
end