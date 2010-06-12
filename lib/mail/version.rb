# encoding: utf-8
module Mail
  module VERSION
    
    def self.version
      version_hash = {}
      File.read(File.join(File.dirname(__FILE__), '../', 'VERSION')).each_line do |line|
        type, value = line.chomp.split(":")
        next if type =~ /^\s+$/  || value =~ /^\s+$/
        version_hash[type] = value
      end
      version_hash
    end
    
    MAJOR = version['major']
    MINOR = version['minor']
    PATCH = version['patch']
    BUILD = version['build']

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
