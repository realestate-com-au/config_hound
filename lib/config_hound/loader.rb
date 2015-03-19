require "config_hound/parser"
require "config_hound/resource"

module ConfigHound

  class Loader

    def self.load(path)
      new(path).load
    end

    def initialize(path)
      @resource = Resource.new(path.to_s)
    end

    attr_reader :resource

    def load
      data = Parser.parse(resource.read, resource.format)
      Array(data.delete("_include")).each do |i|
        defaults = Loader.load(resource.resolve(i))
        include_into!(data, defaults)
      end
      data
    end

    private

    def include_into!(data, defaults)
      return unless data.is_a?(Hash) && defaults.is_a?(Hash)
      defaults.each do |key, value|
        if data.has_key?(key)
          include_into!(data[key], value)
        else
          data[key] = value
        end
      end
    end

  end

end
