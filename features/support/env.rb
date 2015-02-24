require "configuration_loader"
require "stringio"

class CustomConfigurationLoader < ConfigurationLoader

  attr_accessor :inputs

  def read(path)
    if inputs.has_key?(path)
      inputs[path]
    else
      raise ConfigurationLoader::LoadError, "can't load: #{path}"
    end
  end

end

Before do
  @inputs = {}
  @loader = CustomConfigurationLoader.new
  @loader.inputs = @inputs
end
