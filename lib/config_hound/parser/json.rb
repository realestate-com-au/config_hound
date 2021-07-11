module ConfigHound
  class Parser
    class JSON
      def self.parse(raw)
        require "multi_json"
        MultiJson.load(raw)
      end
    end
  end
end
