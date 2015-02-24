require "configuration_loader/version"

require "multi_json"
require "yaml"

class ConfigurationLoader

  def self.load(path)
    new.load(path)
  end

  def load(path)
    raw = open(path).read
    case format = File.extname(path)
    when '.json'
      MultiJson.load(raw)
    when '.yaml', '.yml'
      YAML.load(raw)
    else
      raise "unknown format: #{format}"
    end
  end

end
