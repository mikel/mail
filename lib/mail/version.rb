# encoding: utf-8
module Mail
  module VERSION
    
    def self.version
      YAML.load_file(File.join(File.dirname(__FILE__), '../../', 'VERSION.yml'))
    end
    
    MAJOR = version[:major]
    MINOR = version[:minor]
    PATCH = version[:patch]
    BUILD = version[:build]

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
