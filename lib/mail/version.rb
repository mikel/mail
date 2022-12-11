# frozen_string_literal: true
module Mail
  module VERSION

    MAJOR = 2
    MINOR = 9
    PATCH = 0
    BUILD = 'edge'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')

    def self.version
      STRING
    end

  end
end
