# encoding: utf-8

class NilClass #:nodoc:
  def blank?
    true
  end
  
  def to_crlf
    ''
  end
  
  def to_lf
    ''
  end
end
