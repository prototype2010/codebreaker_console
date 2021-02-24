require_relative '../initializer'

module FileUtils
  class << self
    def write(path, content)
      File.write(path, content.to_yaml)
    end

    def read(path)
      YAML.safe_load(File.read(path), [Symbol])
    end
  end
end
