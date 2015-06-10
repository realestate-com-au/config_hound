require "config_hound/resource"

module ConfigHound

  class Loader

    DEFAULT_INCLUDE_KEY = "_include"

    def self.load(paths, options = {})
      data = {}
      loader = new(data, options)
      Array(paths).each do |path|
        loader.load(path)
      end
      data
    end

    def initialize(data, options)
      @data = data
      @include_key = options.fetch(:include_key, DEFAULT_INCLUDE_KEY)
    end

    def load(path)
      resource = Resource.new(path.to_s)
      include_into!(data, resource.load)
      includes = Array(data.delete(include_key))
      includes.each do |i|
        load(resource.resolve(i))
      end
    end

    private

    attr_reader :data
    attr_reader :include_key

    def include_into!(data, more_data)
      return unless data.is_a?(Hash) && more_data.is_a?(Hash)
      more_data.each do |key, value|
        if data.has_key?(key)
          include_into!(data[key], value)
        else
          data[key] = value
        end
      end
    end

  end

end
