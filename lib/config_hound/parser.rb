require 'config_hound/parser/json'
require 'config_hound/parser/toml'
require 'config_hound/parser/yaml'

module ConfigHound
  class Parser

    def self.parse(*args)
      new.parse(*args)
    end

    def parse(raw, format)
      parse_class = "#{self.class}::#{format.upcase}"
      raise "unknown format: #{format}" unless ObjectSpace.each_object(Class).find{|c| c.to_s == parse_class }
      eval(parse_class).parse(raw)
    end

  end
end
