require 'yaml'

module Mail
  module YAML
    # unsafe loading compatible with Psych 3.x and Psych 4.x
    if ::YAML.respond_to?(:unsafe_load)
      def self.load(yaml)
        ::YAML.unsafe_load(yaml)
      end
    else
      def self.load(yaml)
        ::YAML.load(yaml)
      end
    end
  end
end
