module ConfigHound
  class Parser
    class YAML
      def self.parse(raw)
        require "yaml"
        ::YAML.safe_load(raw, permitted_classes: [], permitted_symbols: [], aliases: true)
      end
    end
    class YML < YAML ; end
  end
end
