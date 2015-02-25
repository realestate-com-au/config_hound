require "configuration_loader/resource"
require "configuration_loader/version"

class ConfigurationLoader

  def self.load(path)
    new.load(path)
  end

  def load(path)
    resource = Resource.new(path.to_s)
    data = parse(resource.read, resource.format)
    includes = Array(data.delete("_include"))
    includes.each do |i|
      included_data = load(resource.resolve(i))
      data = deep_merge(included_data, data)
    end
    data
  end

  private

  def parse(raw, format)
    parse_method = "parse_#{format}"
    raise "unknown format: #{format}" unless respond_to?(parse_method, true)
    send(parse_method, raw)
  end

  def parse_yaml(raw)
    require "yaml"
    YAML.load(raw)
  end

  alias :parse_yml :parse_yaml

  def parse_json(raw)
    require "multi_json"
    MultiJson.load(raw)
  end

  def parse_toml(raw)
    require "toml"
    TOML.load(raw)
  end

  def deep_merge(a, b)
    if a.is_a?(Hash) && b.is_a?(Hash)
      a.merge(b) { |key, av, bv| deep_merge(av, bv) }
    else
      b
    end
  end

end


