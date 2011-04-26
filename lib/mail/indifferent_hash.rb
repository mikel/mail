module Mail
  # Sort of like ActiveSupport HashWithIndifferentAccess, but lighter
  class IndifferentHash < Hash
    def initialize(other=nil)
      if other.is_a?(Hash)
        self.default = other.default
        self.update(other)
      else
        super
      end
    end

    def [](key_name)
      super(key_name.to_sym)
    end

    def []=(k, v)
      super(k.to_sym, v)
    end

    def update(other_hash)
      super(other_hash.inject({}) {|c, (k, v)| c[k.to_sym] = v; c})
    end
    alias merge! update
  end
end
