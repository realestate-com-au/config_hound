require 'config_hound/parser/duplicate_key_error'
require 'config_hound/parser/json'
require 'config_hound/parser/toml'
require 'config_hound/parser/yaml'

module ConfigHound
  class Parser

    def self.parse(*args)
      new.parse(*args)
    end

    def parse(raw, format, options={})
      begin
        parser = eval("#{self.class}::#{format.upcase}")
      rescue NameError
        raise "unknown format: #{format}"
      end

      if !options[:allow_duplicate_keys] && parser.respond_to?(:find_duplicate_keys)
        duplicates = parser.find_duplicate_keys(raw)
        raise DuplicateKeyError.new(duplicates) if duplicates.any?
      end

      parser.parse(raw)
    end

  end
end
