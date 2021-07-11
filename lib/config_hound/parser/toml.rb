module ConfigHound
  class Parser
    class TOML
      def self.parse(raw)
        require "toml"
        ::TOML.load(raw)
      end
    end
  end
end
