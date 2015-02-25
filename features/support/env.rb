require "configuration_loader"
require "cucumber/rspec/doubles"
require "stringio"

Before do
  @inputs = {}
  @loader = ConfigurationLoader.new
  allow_any_instance_of(ConfigurationLoader::Resource).to receive(:open) do |_, path, &block|
    if @inputs.has_key?(path)
      block.call(StringIO.new(@inputs[path].dup))
    else
      raise Errno::ENOENT, "can't load: #{path}"
    end
  end
end
