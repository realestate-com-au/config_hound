require "config_hound/parser"
require "config_hound/resource"

module ConfigHound

  class Loader

    DEFAULT_INCLUDE_KEY = "_include"

    def self.load(path, options = {})
      new(path, options).load
    end

    def initialize(path, options)
      @resource = Resource.new(path.to_s)
      @include_key = options.fetch(:include_key, DEFAULT_INCLUDE_KEY)
    end

    def load
      data = Parser.parse(resource.read, resource.format)
      Array(data.delete(include_key)).each do |i|
        defaults = Loader.load(resource.resolve(i))
        include_into!(data, defaults)
      end
      data
    end

    private

    attr_reader :resource
    attr_reader :include_key

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
