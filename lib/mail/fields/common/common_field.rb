# encoding: utf-8
module Mail
  module CommonField # :nodoc:
    
    module ClassMethods # :nodoc:
      
    end
    
    module InstanceMethods # :doc:
      
      def strip_field(field_name, string)
        string.to_s.gsub(/#{field_name}:\s+/i, '')
      end
      
      def name=(value)
        @name = capitalize_field(value)
      end
      
      def name
        @name
      end
      
      def value=(value)
        @tree = nil
        @element = nil
        @value = value
      end
      
      def value
        @value
      end
      
      def to_s
        value.blank? ? '' : value
      end
      
      def encoded
        value.blank? ? nil : "#{do_encode}\r\n"
      end
      
      def encoded_to_s
        value.blank? ? '' : "#{name}: #{value}"
      end

      def responsible_for?( val )
        name.to_s.downcase == val.to_s.downcase
      end

      private


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
      def do_encode # :nodoc:
        case
        when encoded_to_s.length <= 78
          encoded_to_s
        when encoded_to_s.length > 78
          @folded_line = []
          @unfolded_line = encoded_to_s
          wspp = @unfolded_line =~ /[ \t]/
          fold
          @folded_line.join("\r\n\t")
        end
      end

      def fold # :nodoc:
        # Get the last whitespace character, OR we'll just choose 
        # 78 if there is no whitespace
        wspp = @unfolded_line.slice(0..78) =~ /[ \t][^ \T]*$/ || 78
        @folded_line << @unfolded_line.slice!(0...wspp)
        if @unfolded_line.length > 78
          fold
        else
          @folded_line << @unfolded_line
        end
      end


    end
    
    def self.included(receiver) # :nodoc:
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end