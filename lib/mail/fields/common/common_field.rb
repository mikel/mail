# encoding: utf-8
module Mail
  module CommonField # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
    
    module InstanceMethods # :doc:
      
      def name=(value)
        @name = capitalize_field(value)
      end
      
      def name
        @name
      end
      
      def value=(value)
        @length = nil
        @tree = nil
        @element = nil
        @value = value
      end
      
      def value
        @value
      end
      
      def encoded
        value.blank? ? nil : "#{wrapped_value}\r\n"
      end
      
      def decoded
        value.blank? ? nil : "#{name}: #{value}\r\n"
      end
      
      def to_s
        decoded.to_s
      end
      
      def field_length
        @length ||= name.length + value.length + ': '.length
      end
      
      def responsible_for?( val )
        name.to_s.downcase == val.to_s.downcase
      end

      private

      def strip_field(field_name, string) 
        string.to_s.gsub(/#{field_name}:\s+/i, '')
      end


      # 2.2.3. Long Header Fields
      # 
      #  Each header field is logically a single line of characters comprising
      #  the field name, the colon, and the field body.  For convenience
      #  however, and to deal with the 998/78 character limitations per line,
      #  the field body portion of a header field can be split into a multiple
      #  line representation; this is called "folding".  The general rule is
      #  that wherever this standard allows for folding white space (not
      #  simply WSP characters), a CRLF may be inserted before any WSP.  For
      #  example, the header field:
      #  
      #          Subject: This is a test
      #  
      #  can be represented as:
      #  
      #          Subject: This
      #           is a test
      #  
      #  Note: Though structured field bodies are defined in such a way that
      #  folding can take place between many of the lexical tokens (and even
      #  within some of the lexical tokens), folding SHOULD be limited to
      #  placing the CRLF at higher-level syntactic breaks.  For instance, if
      #  a field body is defined as comma-separated values, it is recommended
      #  that folding occur after the comma separating the structured items in
      #  preference to other places where the field could be folded, even if
      #  it is allowed elsewhere.
      def wrapped_value # :nodoc:
        case
        when decoded.ascii_only? && field_length <= 78
          "#{name}: #{value}"
        when field_length <= 28 # non usascii chars take a LOT of chars to represent
          "#{name}: #{encode(value)}"
        else
          @folded_line = []
          @unfolded_line = value.clone
          fold("#{name}: ".length)
          folded = @folded_line.compact.join("\r\n\t")
          "#{name}: #{folded}"
        end
      end

      def fold(prepend = 0) # :nodoc:
        # Get the last whitespace character, OR we'll just choose 
        # 78 if there is no whitespace
        @unfolded_line.ascii_only? ? (limit = 78 - prepend) : (limit = 28 - prepend)
        wspp = @unfolded_line.slice(0..limit) =~ /[ \t][^ \T]*$/ || limit
        wspp = limit if wspp == 0
        @folded_line << encode(@unfolded_line.slice!(0...wspp))
        if @unfolded_line.length > limit
          fold
        else
          @folded_line << encode(@unfolded_line)
        end
      end

      def encode(value)
        if RUBY_VERSION < '1.9'
          Encodings.q_encode(value, $KCODE)
        else
          Encodings.q_encode(value, @value.encoding)
        end
      end
      


    end
    
    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end