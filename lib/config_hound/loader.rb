require "config_hound/deep_merge"
require "config_hound/interpolation"
require "config_hound/resource"

module ConfigHound

  class Loader

    DEFAULT_INCLUDE_KEY = "_include"

    attr_accessor :include_key
    attr_accessor :expand_refs

    def initialize(options = {})
      @include_key = DEFAULT_INCLUDE_KEY
      options.each do |k, v|
        public_send("#{k}=", v)
      end
    end

    def load(sources)
      raw_hashes = Array(sources).map(&method(:load_source))
      result = raw_hashes.reverse.reduce({}, &ConfigHound.method(:deep_merge_into))
      result = Interpolation.expand(result) if expand_refs
      result
    end

    private

    def load_source(source)
      return source if source.is_a?(Hash)
      resource = Resource[source]
      raw_data = resource.load
      includes = Array(raw_data.delete(include_key))
      included_resources = includes.map do |relative_path|
        resource.resolve(relative_path)
      end
      ConfigHound.deep_merge_into(load(included_resources), raw_data)
    end

  end

end
