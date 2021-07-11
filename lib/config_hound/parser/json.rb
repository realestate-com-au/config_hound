module ConfigHound
  class Parser
    class JSON
      def self.parse(raw)
        require "multi_json"
        MultiJson.load(raw)
      end

      def self.find_duplicate_keys(raw)
        require "ext/duplicate_key_checking_hash"
        require "multi_json"
        parsed = MultiJson.load(raw, object_class: DuplicateKeyCheckingHash)
        find_deep_duplicates([], parsed)
      end

      def self.find_deep_duplicates(parents, hash)
        return [] unless hash.is_a?(Hash)

        duplicates = hash.duplicate_keys.map{|d| [parents, d].join('.') }

        hash.each do |key, value|
          next unless value.is_a?(Hash)
          duplicates += find_deep_duplicates(parents + [key], value)
        end

        duplicates
      end
    end
  end
end
