require "configuration_loader/version"

class ConfigurationLoader

  def self.load(path)
    new.load(path)
  end

  def load(path)
    data = open(path).read
    format = File.extname(path)[1..-1]
    parse(data, format)
  end

  private

  def parse(data, format)
    parse_method = "parse_#{format}"
    raise "unknown format: #{format}" unless respond_to?(parse_method, true)
    send(parse_method, data)
  end

  def parse_yaml(data)
    require "yaml"
    YAML.load(data)
  end

  alias :parse_yml :parse_yaml

  def parse_json(data)
    require "multi_json"
    MultiJson.load(data)
  end

  def parse_toml(data)
    require "toml"
    TOML.load(data)
  end

end

