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
      includes = Array(data.delete("_include"))
      includes.each do |i|
        included_data = Loader.load(resource.resolve(i))
        data = deep_merge(included_data, data)
      end
      data
    end

    private

    def deep_merge(a, b)
      if a.is_a?(Hash) && b.is_a?(Hash)
        a.merge(b) { |key, av, bv| deep_merge(av, bv) }
      else
        b
      end
    end

  end

end
