# encoding: utf-8
module Mail
  module Utilities
    
    module ClassMethods
    
    end
  
    module InstanceMethods
    
      include Patterns
      
      # Returns true if the string supplied is free from characters not allowed as an ATOM
      def atom_safe?( str )
        not ATOM_UNSAFE === str
      end

      # If the string supplied has ATOM unsafe characters in it, will return the string quoted 
      # in double quotes, otherwise returns the string unmodified
      def quote_atom( str )
        (ATOM_UNSAFE === str) ? dquote(str) : str
      end

      # If the string supplied has PHRASE unsafe characters in it, will return the string quoted 
      # in double quotes, otherwise returns the string unmodified
      def quote_phrase( str )
        (PHRASE_UNSAFE === str) ? dquote(str) : str
      end

      # Returns true if the string supplied is free from characters not allowed as a TOKEN
      def token_safe?( str )
        not TOKEN_UNSAFE === str
      end

      # If the string supplied has TOKEN unsafe characters in it, will return the string quoted 
      # in double quotes, otherwise returns the string unmodified
      def quote_token( str )
        (TOKEN_UNSAFE === str) ? dquote(str) : str
      end

      # Wraps supplied string in double quotes unless it is already wrapped
      # Returns double quoted string
      def dquote( str ) #:nodoc:
        unless str =~ /^".*?"$/
          '"' + str.gsub(/["\\]/n) {|s| '\\' + s } + '"'
        else
          str
        end
      end
      
      # Unwraps supplied string from inside double quotes
      # Returns unquoted string
      def unquote( str )
        str =~ /^"(.*?)"$/ ? $1 : str
      end
      
      # Wraps a string in parenthesis 
      def paren( str )
        unless str =~ /^\(.*?\)$/
          '(' + str.gsub(/[\(\)]/n) {|s| '\\' + s } + ')'
        else
          str
        end
      end
      
      # Unwraps a string in parenthesis 
      def unparen( str )
        str =~ /^\((.*?)\)$/ ? $1 : str
      end
      
      # Escapes any parenthesis in a string that are unescaped this uses
      # a Ruby 1.9.1 regexp feature of negative look behind
      def escape_paren( str )
        re = /(?<!\\)([\(\)])/          # Only match unescaped parens
        str.gsub(re) { |s| '\\' + s }
      end
      
      # Matches two objects with their to_s values case insensitively
      def match_to_s( obj1, obj2 )
        obj1.to_s.downcase == obj2.to_s.downcase
      end
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end