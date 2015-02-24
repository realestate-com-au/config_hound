require "configuration_loader/version"

class ConfigurationLoader

  def self.load(path)
    new.load(path)
  end

  def load(path)
    raw = read(path)
    format = File.extname(path)[1..-1]
    data = parse(raw, format)
    includes = Array(data.delete("_include"))
    includes.each do |included_path|
      included_data = load(included_path)
      data = deep_merge(load(included_path), data)
    end
    data
  end

  protected

  def read(path)
    open(path) do |io|
      io.read
    end
  rescue Errno::ENOENT
    raise ConfigurationLoader::LoadError, "can't load: #{path}"
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

  LoadError = Class.new(StandardError)

end


