require "config_hound/resource"

module ConfigHound

  class Loader

    DEFAULT_INCLUDE_KEY = "_include"

    def initialize(options = {})
      @include_key = options.fetch(:include_key, DEFAULT_INCLUDE_KEY)
    end

    def load(*paths)
      paths.reverse.map(&method(:load_path)).reduce({}, &ConfigHound.method(:deep_merge))
    end

    private

    def load_path(path)
      resource = Resource.new(path)
      data = resource.load
      includes = Array(data.delete(include_key))
      included_resource_paths = includes.map do |relative_path|
        resource.resolve(relative_path).to_s
      end
      ConfigHound.deep_merge(load(*included_resource_paths), data)
    end

    attr_reader :include_key

  end

end
