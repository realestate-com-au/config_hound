module ConfigHound

  class Parser

    def self.parse(*args)
      new.parse(*args)
    end

    def parse(raw, format)
      parse_method = "parse_#{format}"
      raise "unknown format: #{format}" unless respond_to?(parse_method, true)
      send(parse_method, raw)
    end

    protected

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

  end

end
