require "uri"

class ConfigurationLoader

  # Represents a source of configuration data.
  #
  class Resource

    def initialize(path)
      @uri = uri_for(path)
    end

    def to_s
      @uri.to_s
    end

    private

    def uri_for(path)
      case path
      when URI
        path
      when %r{^\w+:/}
        URI(path)
      when %r{^/}
        URI("file:#{path}")
      else
        URI("file:#{File.expand_path(path)}")
      end
    end

  end

end
