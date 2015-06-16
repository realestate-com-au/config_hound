require "config_hound/resource"

module ConfigHound

  class Loader

    DEFAULT_INCLUDE_KEY = "_include"

    def initialize(options = {})
      @include_key = options.fetch(:include_key, DEFAULT_INCLUDE_KEY)
    end

    def load(*paths)
      paths.reverse.map do |path|
        load_resource(Resource[path])
      end.reduce({}, &ConfigHound.method(:deep_merge))
    end

    private

    attr_reader :include_key

    def load_resource(resource)
      raw_data = resource.load
      includes = Array(raw_data.delete(include_key))
      included_resources = includes.map do |relative_path|
        resource.resolve(relative_path)
      end
      ConfigHound.deep_merge(load(*included_resources), raw_data)
    end

  end

end
