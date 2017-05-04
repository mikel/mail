# encoding: utf-8
# frozen_string_literal: true
class String #:nodoc:
  def not_ascii_only?
    !ascii_only?
  end
end
