# encoding: utf-8
# frozen_string_literal: true

# This is not loaded if ActiveSupport is already loaded

# This is an almost cut and paste from ActiveSupport v3.0.6, copied in here so that Mail
# itself does not depend on ActiveSupport to avoid versioning conflicts

class String
  unless '1.9'.respond_to?(:force_encoding)
    # Returns the beginning of the string up to the +position+ treating the string as an array (where 0 is the first character).
    #
    # Examples:
    #   "hello".to(0)  # => "h"
    #   "hello".to(2)  # => "hel"
    #   "hello".to(10) # => "hello"
    def to(position)
      mb_chars[0..position].to_s
    end

    # Returns the first character of the string or the first +limit+ characters.
    #
    # Examples:
    #   "hello".first     # => "h"
    #   "hello".first(2)  # => "he"
    #   "hello".first(10) # => "hello"
    def first(limit = 1)
      if limit == 0
        ''
      elsif limit >= size
        self
      else
        mb_chars[0...limit].to_s
      end
    end
  else
    def to(position)
      self[0..position]
    end

    def first(limit = 1)
      if limit == 0
        ''
      elsif limit >= size
        self
      else
        to(limit - 1)
      end
    end
  end

  if Module.method(:const_get).arity == 1
    # Tries to find a constant with the name specified in the argument string:
    #
    #   "Module".constantize     # => Module
    #   "Test::Unit".constantize # => Test::Unit
    #
    # The name is assumed to be the one of a top-level constant, no matter whether
    # it starts with "::" or not. No lexical context is taken into account:
    #
    #   C = 'outside'
    #   module M
    #     C = 'inside'
    #     C               # => 'inside'
    #     "C".constantize # => 'outside', same as ::C
    #   end
    #
    # NameError is raised when the name is not in CamelCase or the constant is
    # unknown.
    def constantize
      names = self.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  else
    def constantize #:nodoc:
      names = self.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  end
end
