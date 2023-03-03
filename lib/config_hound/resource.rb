require "config_hound/error"
require "config_hound/parser"
require "open-uri"
require "uri"

module ConfigHound

  LoadError = Class.new(ConfigHound::Error)

  # Represents a source of configuration data.
  #
  class Resource

    class << self

      def [](arg)
        return arg if arg.is_a?(Resource)
        new(uri_for(arg))
      end

      private(:new)

      private

      def uri_for(arg)
        case arg
        when URI
          arg
        when %r{^\w+:/}
          URI(arg)
        when %r{^/}
          URI("file://#{arg}")
        else
          URI("file://#{File.expand_path(arg)}")
        end
      end

    end

    attr_reader :uri

    def to_s
      uri.to_s
    end

    def resolve(path)
      Resource[uri + path]
    end

    def read
      URI.open(uri.scheme == "file" ? uri.path : uri.to_s) do |io|
        io.read
      end
    rescue Errno::ENOENT
      raise LoadError, "can't load: #{uri}"
    end

    def format
      File.extname(uri.path.to_s)[1..-1]
    end

    def load(options={})
      Parser.parse(read, format, options)
    end

    private

    def initialize(uri)
      @uri = uri
    end

  end

end
