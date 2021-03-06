module FileUtils
  class << self
    def delete(path)
      return unless File.exist?(path)

      File.delete(path)
    end

    def write(path, content)
      File.write(path, content.to_yaml)
    end

    def read(path)
      YAML.safe_load(File.read(path), [Symbol])
    end
  end
end
