# encoding: utf-8
module CustomMatchers
  class BreakDownTo
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target   = target
      @failed = false
      @expected.each_pair do |k,v|
        unless @target.send(k) == @expected[k]
          @failed = k
        end
      end
      !@failed
    end

    def failure_message
      "expected #{@failed} to be |#{@expected[@failed]}| " + 
      "but was |#{@target.send(@failed)}|"
    end

    def negative_failure_message
      "expected #{@failed} not to be |#{@expected[@failed]}| " +
      "and was |#{@target.send(@failed)}|"
    end
    
  end

  # Actual matcher that is exposed.
  def break_down_to(expected)
    BreakDownTo.new(expected)
  end
end
