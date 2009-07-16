module CustomMatchers
  class BreakDownTo
    def initialize(expected)
      @expected = expected
    end

    def matches?(target)
      @target   = target
      @expected[:display_name] == target.display_name ? @display  = nil : @display  = 'failed'
      @expected[:address]      == target.address      ? @address  = nil : @address  = 'failed'
      @expected[:local]        == target.local        ? @local    = nil : @local    = 'failed'
      @expected[:domain]       == target.domain       ? @domain   = nil : @domain   = 'failed'
      @expected[:format]       == target.format       ? @format   = nil : @format   = 'failed'
      @expected[:comments]     == target.comments     ? @comments = nil : @comments = 'failed'
      !(@display || @address || @local || @domain || @format || @comments)
    end

    def failure_message
      "expected #{failure_part} to be |#{@expected[failure_part]}| " + 
      "but was |#{@target.send(failure_part)}|"
    end

    def megative_failure_message
      "expected #{failure_part} not to be |#{@expected[failure_part]}| " +
      "and was |#{@target.send(failure_part)}|"
    end
    
    def failure_part
      case
      when @display
        :display_name
      when @address
        :address
      when @local
        :local
      when @domain
        :domain
      when @format
        :format
      when @comments
        :comments
      end
    end

  end

  # Actual matcher that is exposed.
  def break_down_to(expected)
    BreakDownTo.new(expected)
  end
end
