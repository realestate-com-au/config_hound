module ConfigHound
  class Parser
    class YAML
      def self.parse(raw)
        require "yaml"
        ::YAML.safe_load(raw, permitted_classes: [], permitted_symbols: [], aliases: true)
      end

      def self.find_duplicate_keys(raw)
        require "psych"

        # Blatantly stolen from https://stackoverflow.com/a/55705853
        duplicate_keys = []

        validator = ->(node, parent_path) do
          if node.is_a?(Psych::Nodes::Mapping)
            children = node.children.each_slice(2)
            duplicates = children.map { |key_node, _value_node| key_node }.group_by(&:value).select { |_value, nodes| nodes.size > 1 }

            duplicates.each do |key, nodes|
              duplicate_keys << (parent_path + [key]).join('.')
            end

            children.each { |key_node, value_node| validator.call(value_node, parent_path + [key_node&.value].compact) }
          else
            node.children.to_a.each { |child| validator.call(child, parent_path) }
          end
        end

        ast = Psych.parse_stream(raw)
        validator.call(ast, [])

        duplicate_keys
      end
    end

    class YML < YAML ; end

  end
end
